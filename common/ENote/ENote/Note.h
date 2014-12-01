//  Note.h
//  ENote
//
//  Created by Andrei Luca on 11/12/14.
//  Copyright (c) 2014 Endava. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Item.h"
#import "Notebook.h"

@interface Note : Item

@property (nonatomic, copy) NSString *text;
@property (nonatomic) NSMutableArray *tagsIDs;

@end
