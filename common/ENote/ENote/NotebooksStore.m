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

@interface NotebooksStore ()

@property (nonatomic) NSMutableArray *privateNotebooks;

@end

@implementation NotebooksStore

#pragma mark Other

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
        
        NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentDirectory = [documentDirectories firstObject];
        NSString *indexPath = [NSString stringWithFormat:@"%@/%@", documentDirectory, @"index.json"];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:indexPath]) {
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateStyle:NSDateFormatterLongStyle];
            [formatter setTimeStyle:NSDateFormatterLongStyle];
            
            NSData *notebooksData = [[NSFileManager defaultManager] contentsAtPath:indexPath];
            NSDictionary *notebooksDictionary = [NSJSONSerialization JSONObjectWithData:notebooksData options:NSJSONReadingMutableContainers error:nil];
            
            NSMutableArray *notebooks = notebooksDictionary[@"notebooks"];
            
            for (int i = 0; i < [notebooks count]; i++) {
                
                NSDictionary *notebookDictionary = notebooks[i];
                
                NSString *notebookName = notebookDictionary[@"name"];
                NSDate *notebookDate = [formatter dateFromString:notebookDictionary[@"dateCreated"]];
                NSString *notebookFolder = notebookDictionary[@"notebookFolder"];
                
                Notebook *notebook = [self createNotebookWithName:notebookName atDate:notebookDate andFolder:notebookFolder];
                
                NSMutableArray *notes = notebookDictionary[@"notes"];
                
                for (int j = 0; j < [notes count]; j++) {
                    
                    NSDictionary *noteDictionary = notes[i];
                    
                    NSString *noteText = noteDictionary[@"text"];
                    NSDate *noteDate = [formatter dateFromString:noteDictionary[@"dateCreated"]];
                    NSString *noteFolder = noteDictionary[@"notebookFolder"];
                    
                    [notebook.notes createNoteWithText:noteText atDate:noteDate andFolder:noteFolder];
                }
            }
        }

        for (int i = 0; i < 3; i++) {
            [self createNotebook];
            
        }
    }
    
    return self;
}





@end
