//
//  NotebooksStore.h
//  ENote
//
//  Created by Andrei Luca on 11/11/14.
//  Copyright (c) 2014 Endava. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Store.h"

@interface NotebooksStore : Store

+ (instancetype)sharedStore;

@end
