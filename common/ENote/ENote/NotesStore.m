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

- (StoreItem *)createStoreItemWithName:(NSString *)name withText:(NSString *)text atDate:(NSDate *)date andFolder:(NSString *)folder {
    
    Note *note = [[Note alloc] initWithName:name withText:text atDate:date andFolder:folder];
    
    [self.allStoreItems addObject:note];
    
    return note;
}

- (StoreItem *)createStoreItemWithDictionary:(NSDictionary *)dictionary {
    return [self createStoreItemWithName:dictionary[@"name"]
                                withText:dictionary[@"text"]
                                  atDate:[NSDate dateWithTimeIntervalSince1970:[dictionary[@"dateCreated"] doubleValue]]
                               andFolder:dictionary[@"itemFolder"]];
}

- (StoreItem *)createStoreItemWithName:(NSString *)name atDate:(NSDate *)date andFolder:(NSString *)folder {
    
    Note *storeItem = [[Note alloc] initWithName:name atDate:date andFolder:folder];
    
    [self.allStoreItems addObject:storeItem];
    
    return storeItem;
}

@end
