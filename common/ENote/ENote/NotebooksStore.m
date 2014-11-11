//
//  NotebooksStore.m
//  ENote
//
//  Created by Andrei Luca on 11/11/14.
//  Copyright (c) 2014 Endava. All rights reserved.
//

#import "NotebooksStore.h"
#import "Notebook.h"

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
    
    Notebook *notebook = [[Notebook alloc] initWithName:name];
    
    [self.privateNotebooks addObject:notebook];
    
    return notebook;
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
    }
    
    return self;
}



@end
