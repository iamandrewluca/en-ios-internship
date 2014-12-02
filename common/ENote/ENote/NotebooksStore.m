//
//  NotebooksStore.m
//  ENote
//
//  Created by Andrei Luca on 11/11/14.
//  Copyright (c) 2014 Endava. All rights reserved.
//

#import "NotebooksStore.h"
#import "Notebook.h"
#import "NotesStore.h"
#import "ENoteCommons.h"
#import "TagsStore.h"


@interface NotebooksStore ()

@property (nonatomic) NSMutableArray *allPrivateNotebooks;

@end

@implementation NotebooksStore

- (NSArray *)allNotebooks {
    return _allPrivateNotebooks;
}

+ (instancetype)sharedStore {
    
    static NotebooksStore *sharedStore = nil;
    
    if (!sharedStore) {
        sharedStore = [[self alloc] initPrivate];
    }
    
    return sharedStore;
}

- (instancetype)init {
    @throw [NSException exceptionWithName:@"Singleton" reason:@"Use +[TagsStore sharedStore]" userInfo:nil];
}

- (instancetype)initPrivate {
    
    self = [super init];
    
    if (self) {
        _allPrivateNotebooks = [[NSMutableArray alloc] init];
        
        [self loadNotebooks];
    }
    
    return self;
}

- (Notebook *)notebookWithID:(NSString *)ID {
    for (Notebook *notebook in _allPrivateNotebooks) {
        if ([ID isEqualToString:notebook.ID]) {
            return notebook;
        }
    }
    
    return nil;
}

- (Notebook *)createNotebookWithName:(NSString *)name {
    Notebook *notebook = [[Notebook alloc] initWithName:name];
    [self addNotebook:notebook];
    [self saveNotebook:notebook];
    return notebook;
}

- (void)addNotebook:(Notebook *)notebook {
    [_allPrivateNotebooks addObject:notebook];
}

- (void)removeNotebook:(Notebook *)notebook {
    NSString *itemPath = [NSString stringWithFormat:@"%@/%@", [[ENoteCommons shared] documentDirectory], notebook.ID];
    
    [[NSFileManager defaultManager] removeItemAtPath:itemPath error:nil];
    
    for (NSString *noteID in notebook.notesIDs) {
        [[NotesStore sharedStore] removeNoteWithID:noteID];
    }
    
    [_allPrivateNotebooks removeObject:notebook];
}

- (void)saveNotebook:(Notebook *)notebook {
    
    NSString *notebookPath = [NSString stringWithFormat:@"%@/%@", [[ENoteCommons shared] documentDirectory], notebook.ID];
    
    [[NSFileManager defaultManager] createDirectoryAtPath:notebookPath
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:nil];
    
    NSData *notebookData = [NSJSONSerialization dataWithJSONObject:[notebook dictionaryRepresentation]
                                                       options:0
                                                         error:nil];
    
    NSString *indexPath = [NSString stringWithFormat:@"%@/%@", notebookPath, [[ENoteCommons shared] indexFile]];
    
    [[NSFileManager defaultManager] createFileAtPath:indexPath contents:notebookData attributes:nil];
}

- (void)saveNotebookWithID:(NSString *)ID {
    for (Notebook *notebook in _allPrivateNotebooks) {
        if ([ID isEqualToString:notebook.ID]) {
            [self saveNotebook:notebook];
            return;
        }
    }
}

- (void)loadNotebooks {
    
    NSArray *itemPaths = [[ENoteCommons shared] getValidItemsPathsInFolder:[[ENoteCommons shared] documentDirectory]];
    
    for (NSString *itemPath in itemPaths) {
        
        NSString *indexPath = [NSString stringWithFormat:@"%@/%@/%@", [[ENoteCommons shared] documentDirectory], itemPath, [[ENoteCommons shared] indexFile]];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:indexPath]) {
            
            NSData *itemData = [[NSFileManager defaultManager] contentsAtPath:indexPath];
            NSDictionary *itemDictionary = [NSJSONSerialization JSONObjectWithData:itemData options:NSJSONReadingMutableContainers error:nil];
            [self addNotebookWithDictionary:itemDictionary];
        }
    }
}

- (void)addNotebookWithDictionary:(NSDictionary *)dictionary {
    
    Notebook *notebook = [[Notebook alloc] initWithDictionary:dictionary];
    
    [_allPrivateNotebooks addObject:notebook];
}

@end
