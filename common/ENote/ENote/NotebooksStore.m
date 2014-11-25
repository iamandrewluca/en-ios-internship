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
#import "Note.h"
#import "ENoteCommons.h"

@interface NotebooksStore ()

@property (nonatomic) NSMutableArray *privateNotebooks;

@end

@implementation NotebooksStore

#pragma mark Notebook Related

- (void)loadNotebooks {
    
    NSArray *notebooksPaths = [ENoteCommons getValidPathsAtPath:[[ENoteCommons shared] documentDirectory]];
    
    for (NSString *notebookPath in notebooksPaths) {
        
        NSString *indexPath = [NSString stringWithFormat:@"%@/%@/%@", [[ENoteCommons shared] documentDirectory], notebookPath, [[ENoteCommons shared] indexFile]];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:indexPath]) {
            
            NSData *notebookData = [[NSFileManager defaultManager] contentsAtPath:indexPath];
            NSDictionary *notebookDictionary = [NSJSONSerialization JSONObjectWithData:notebookData options:NSJSONReadingMutableContainers error:nil];
            
            [self createNotebookWithDictionary:notebookDictionary];
        }
    }
}

- (NSArray *)allNotebooks {
    return self.privateNotebooks;
}

- (void)renameNotebook:(Notebook *)notebook withName:(NSString *)name {
    notebook.name = name;
    
    [self saveNotebook:notebook];
}

- (void)saveNotebook:(Notebook *)notebook {
    
    NSString *notebookPath = [NSString stringWithFormat:@"%@/%@", [[ENoteCommons shared] documentDirectory], notebook.notebookFolder];
    
    [[NSFileManager defaultManager] createDirectoryAtPath:notebookPath
                              withIntermediateDirectories:NO
                                               attributes:nil
                                                    error:nil];
    
    NSData *notebookData = [NSJSONSerialization dataWithJSONObject:[notebook dictionaryRepresentation] options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *indexPath = [NSString stringWithFormat:@"%@/%@", notebookPath, [[ENoteCommons shared] indexFile]];
    
    [[NSFileManager defaultManager] createFileAtPath:indexPath contents:notebookData attributes:nil];
    
}

- (Notebook *)createNotebook {
    return [self createNotebookWithName:@"Sample Notebook"];
}

- (Notebook *)createNotebookWithName:(NSString *)name {
    
    Notebook *notebook = [self createNotebookWithName:name atDate:[NSDate date] andFolder:[[NSUUID UUID] UUIDString]];
    
    [self saveNotebook:notebook];
    
    return notebook;
}

- (Notebook *)createNotebookWithName:(NSString *)name atDate:(NSDate *)date andFolder:(NSString *)folder {
    
    Notebook *notebook = [[Notebook alloc] initWithName:name atDate:date andFolder:folder];
    
    [self.privateNotebooks addObject:notebook];
    
    return notebook;
}

- (Notebook *)createNotebookWithDictionary:(NSDictionary *)dictionary {
    
    Notebook *notebook = [self createNotebookWithName:dictionary[@"name"]
                                               atDate:[NSDate dateWithTimeIntervalSince1970:[dictionary[@"dateCreated"] doubleValue]]
                                            andFolder:dictionary[@"notebookFolder"]];
    
    return notebook;
}

- (void)removeNotebook:(Notebook *)notebook {
    
    NSString *notebookPath = [NSString stringWithFormat:@"%@/%@", [[ENoteCommons shared] documentDirectory], notebook.notebookFolder];
    
    [[NSFileManager defaultManager] removeItemAtPath:notebookPath error:nil];
    
    [self.privateNotebooks removeObject:notebook];
    
}

+ (instancetype)sharedStore {
    
    static NotebooksStore *sharedStore = nil;
    
    if (!sharedStore) {
        sharedStore = [[self alloc] initPrivate];
    }
    
    return  sharedStore;
}

#pragma mark Init

- (instancetype)init {
    @throw [NSException exceptionWithName:@"Singleton" reason:@"Use +[NotebooksStore sharedStore]" userInfo:nil];
}

- (instancetype)initPrivate {
    
    self = [super init];
    
    if (self) {
        _privateNotebooks = [[NSMutableArray alloc] init];
        
        [self loadNotebooks];
    }
    
    return self;
}





@end
