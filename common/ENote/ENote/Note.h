//  Note.h
//  ENote
//
//  Created by Andrei Luca on 11/12/14.
//  Copyright (c) 2014 Endava. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StoreItem.h"

@interface Note : StoreItem

@property (nonatomic, copy) NSString *text;

@end
