//
//  BHAlbum.m
//  CollectionViewTutorial
//
//  Created by Bryan Hansen on 11/3/12.
//  Copyright (c) 2012 Bryan Hansen. All rights reserved.
//

#import "NotesStorage.h"
#import "Note.h"

@interface NotesStorage ()

@property (nonatomic, strong) NSMutableArray *mutableNotes;

@end

@implementation NotesStorage

#pragma mark - Properties

- (NSArray *)notes
{
    return [self.mutableNotes copy];
}


#pragma mark - Lifecycle

- (id)init
{
    self = [super init];
    if (self) {
        self.mutableNotes = [NSMutableArray array];
    }
    return self;
}

#pragma mark - Notes

- (void)addNote:(Note *)note
{
    [self.mutableNotes addObject:note];
}

- (BOOL)removeNote:(Note *)note
{
    if ([self.mutableNotes indexOfObject:note] == NSNotFound) {
        return NO;
    }
    
    [self.mutableNotes removeObject:note];
    
    return YES;
}



@end
