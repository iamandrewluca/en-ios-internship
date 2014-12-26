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
@property (nonatomic) NSMutableDictionary *allPrivateNotesStores;

@end

@implementation NotebooksStore

- (NSArray *)allNotebooks {
    return _allPrivateNotebooks;
}

+ (instancetype)sharedStore {
    
    static NotebooksStore *sharedStore = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedStore = [[self alloc] initPrivate];
    });
    
    return sharedStore;
}

- (instancetype)initPrivate {
    
    self = [super init];
    
    if (self) {
        _allPrivateNotebooks = [[NSMutableArray alloc] init];
        _allPrivateNotesStores = [[NSMutableDictionary alloc] init];
        
        [self loadNotebooks];
    }
    
    return self;
}

- (NotesStore *)notesStoreForNotebook:(Notebook *)notebook {
    return [_allPrivateNotesStores valueForKey:notebook.ID];
}

- (NotesStore *)notesStoreForNotebookID:(NSString *)ID {
    return [_allPrivateNotesStores valueForKey:ID];
}

- (instancetype)init {
    @throw [NSException exceptionWithName:@"Singleton" reason:@"Use +[TagsStore sharedStore]" userInfo:nil];
}

- (Notebook *)notebookWithID:(NSString *)ID {
    for (Notebook *notebook in _allPrivateNotebooks) {
        if ([ID isEqualToString:notebook.ID]) {
            return notebook;
        }
    }
    
    return nil;
}

- (void)createNotesStoreForNotebook:(Notebook *)notebook {
    NotesStore *notesStore = [[NotesStore alloc] initWithNotebook:notebook];
    [_allPrivateNotesStores setValue:notesStore forKey:notebook.ID];
}

- (void)createNotesStoreForNotebookID:(NSString *)ID {
    for (Notebook *notebook in _allPrivateNotebooks) {
        if ([ID isEqualToString:notebook.ID]) {
            [self createNotesStoreForNotebook:notebook];
            return;
        }
    }
}

- (void)removeNotesStoreForNotebook:(Notebook *)notebook {
    [_allPrivateNotesStores removeObjectForKey:notebook.ID];
}

- (void)removeNotesStoreForNotebookID:(NSString *)ID {
    [_allPrivateNotesStores removeObjectForKey:ID];
}

- (Notebook *)createNotebookWithName:(NSString *)name {
    Notebook *notebook = [[Notebook alloc] initWithName:name];
    [self createNotesStoreForNotebook:notebook];
    
    [self addNotebook:notebook];
    [self saveNotebook:notebook];
    return notebook;
}

- (void)addNotebook:(Notebook *)notebook {
    [_allPrivateNotebooks insertObject:notebook atIndex:0];
}

- (void)removeNotebook:(Notebook *)notebook {
    
    [self removeNotesStoreForNotebook:notebook];
    
    NSString *itemPath = [NSString stringWithFormat:@"%@/%@", [[ENoteCommons shared] documentDirectory], notebook.ID];
    
    [[NSFileManager defaultManager] removeItemAtPath:itemPath error:nil];
    
    [_allPrivateNotebooks removeObject:notebook];
    
    [self saveNotebooksIDs];
}

- (void)removeNotebookWithID:(NSString *)ID {
    for (Notebook *notebook in _allPrivateNotebooks) {
        if ([ID isEqualToString:notebook.ID]) {
            [self removeNotebook:notebook];
            return;
        }
    }
}

- (void)saveNotebooksIDs
{
    NSMutableArray *notebooksIDs = [NSMutableArray arrayWithCapacity:[_allPrivateNotebooks count]];
    for (Notebook *notebook in _allPrivateNotebooks) {
        [notebooksIDs addObject:notebook.ID];
    }
    NSMutableDictionary *notebooksIDsDictionary = [NSMutableDictionary new];
    [notebooksIDsDictionary setValue:notebooksIDs forKey:@"notebooksIDs"];
    NSData *data = [NSJSONSerialization dataWithJSONObject:notebooksIDsDictionary options:0 error:nil];
    [[NSFileManager defaultManager] createFileAtPath:[NSString stringWithFormat:@"%@/root.json", [[ENoteCommons shared] documentDirectory]] contents:data attributes:nil];
}

- (void)saveNotebook:(Notebook *)notebook
{
    [self saveNotebooksIDs];
    
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

- (void)loadNotebooks
{
    NSData *data = [[NSFileManager defaultManager] contentsAtPath:[NSString stringWithFormat:@"%@/root.json", [[ENoteCommons shared] documentDirectory]]];
    
    if (data) {
        NSArray *itemPaths = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil][@"notebooksIDs"];
        
        for (NSString *itemPath in itemPaths) {
            
            NSString *indexPath = [NSString stringWithFormat:@"%@/%@/%@", [[ENoteCommons shared] documentDirectory], itemPath, [[ENoteCommons shared] indexFile]];
            
            if ([[NSFileManager defaultManager] fileExistsAtPath:indexPath]) {
                
                NSData *itemData = [[NSFileManager defaultManager] contentsAtPath:indexPath];
                NSDictionary *itemDictionary = [NSJSONSerialization JSONObjectWithData:itemData options:NSJSONReadingMutableContainers error:nil];
                [self addNotebookWithDictionary:itemDictionary];
            }
        }
    }
}

- (void)addNotebookWithDictionary:(NSDictionary *)dictionary {
    
    Notebook *notebook = [[Notebook alloc] initWithDictionary:dictionary];
    
    [self createNotesStoreForNotebook:notebook];
    
    [_allPrivateNotebooks addObject:notebook];
}

@end
