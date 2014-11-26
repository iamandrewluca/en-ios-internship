//
//  NotesStore.m
//  ENote
//
//  Created by Andrei Luca on 11/12/14.
//  Copyright (c) 2014 Endava. All rights reserved.
//

#import "NotesStore.h"
#import "ENoteCommons.h"
#import "Note.h"

@interface NotesStore ()

@end

@implementation NotesStore

#pragma mark Note Creation

- (StoreItem *)createNoteWithName:(NSString *)name withText:(NSString *)text atDate:(NSDate *)date andFolder:(NSString *)folder {
    
    Note *note = [[Note alloc] initWithName:name withText:text atDate:date andFolder:folder];
    
    [self.allStoreItems addObject:note];
    
    return note;
}

- (StoreItem *)createNoteWithDictionary:(NSDictionary *)dictionary {
    return [self createNoteWithName:dictionary[@"name"]
                           withText:dictionary[@"text"]
                             atDate:[NSDate dateWithTimeIntervalSince1970:[dictionary[@"dateCreated"] doubleValue]]
                          andFolder:dictionary[@"noteFolder"]];
}

- (StoreItem *)createStoreItemWithName:(NSString *)name atDate:(NSDate *)date andFolder:(NSString *)folder {
    
    Note *storeItem = [[Note alloc] initWithName:name atDate:date andFolder:folder];
    
    [self.allStoreItems addObject:storeItem];
    
    return storeItem;
}

@end
