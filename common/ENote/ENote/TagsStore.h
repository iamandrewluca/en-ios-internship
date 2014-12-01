//
//  TagsStore.h
//  ENote
//
//  Created by Andrei Luca on 11/28/14.
//  Copyright (c) 2014 Endava. All rights reserved.
//

#import "Store.h"
#import "Tag.h"

@interface TagsStore : Store

- (void)addTag:(Tag *)tag;
- (void)removeTag:(Tag *)tag;

- (Tag *)getTagWithID:(NSString *)ID;

+ (instancetype)sharedStore;

@end
