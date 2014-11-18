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

- (void)saveNotebooks {
   
    NSMutableArray *notebooks = [[NSMutableArray alloc] init];
    
    for (Notebook *notebook in [[NotebooksStore sharedStore] allNotebooks]) {
        
        [notebook.notesStore saveNotes];
        [notebooks addObject:[notebook dictionaryRepresentation]];
        
    }
    
    NSMutableDictionary *notebooksDictionary = [[NSMutableDictionary alloc] init];
    
    [notebooksDictionary setValue:notebooks forKey:@"notebooks"];
    
    NSData *notebooksData = [NSJSONSerialization dataWithJSONObject:notebooksDictionary options:NSJSONWritingPrettyPrinted error:nil];
    
    [[NSFileManager defaultManager] createFileAtPath:[NSString stringWithFormat:@"%@/%@", [[ENoteCommons shared] documentDirectory], [[ENoteCommons shared] indexFile]] contents:notebooksData attributes:nil];
}

- (NSArray *)allNotebooks {
    return self.privateNotebooks;
}

- (Notebook *)createNotebook {
    return [self createNotebookWithName:@"Sample Notebook"];
}

- (Notebook *)createNotebookWithName:(NSString *)name {
    return [self createNotebookWithName:name atDate:[NSDate date] andFolder:[[NSUUID UUID] UUIDString]];
}

- (Notebook *)createNotebookWithName:(NSString *)name atDate:(NSDate *)date andFolder:(NSString *)folder {
    
    Notebook *notebook = [[Notebook alloc] initWithName:name atDate:date andFolder:folder];
    
    [self.privateNotebooks addObject:notebook];
    
    return notebook;
}

- (Notebook *)createNotebookWithDictionary:(NSDictionary *)dictionary {
    
    Notebook *notebook = [self createNotebookWithName:dictionary[@"name"] atDate:[NSDate dateWithTimeIntervalSince1970:[dictionary[@"dateCreated"] doubleValue]] andFolder:dictionary[@"notebookName"]];
    
    return notebook;
}

- (void)removeNotebook:(Notebook *)notebook {
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
        
        NSString *indexPath = [NSString stringWithFormat:@"%@/%@", [[ENoteCommons shared] documentDirectory], [[ENoteCommons shared] indexFile]];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:indexPath]) {
            
            NSData *notebooksData = [[NSFileManager defaultManager] contentsAtPath:indexPath];
            NSDictionary *notebooksDictionary = [NSJSONSerialization JSONObjectWithData:notebooksData options:NSJSONReadingMutableContainers error:nil];
            
            NSMutableArray *notebooks = notebooksDictionary[@"notebooks"];
            
            for (int i = 0; i < [notebooks count]; i++) {
                [self createNotebookWithDictionary:notebooks[i]];
            }
        }
    }
    
    return self;
}





@end
