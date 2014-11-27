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

- (StoreItem *)storeItemFromDictionary:(NSDictionary *)dictionary {
    return [[Note alloc] initWithName:dictionary[@"name"] withText:dictionary[@"text"] atDate:dictionary[@"dateCreated"] andFolder:dictionary[@"itemFolder"]];
}

@end
