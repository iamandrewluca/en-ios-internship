//
//  BNRContainer.h
//  RandomItems
//
//  Created by Andrei Luca on 10/8/14.
//  Copyright (c) 2014 Andrei Luca. All rights reserved.
//

#import "BNRItem.h"

@interface BNRContainer : BNRItem
{
    NSMutableArray *_subItems;
}

+ (instancetype)randomItem;

- (instancetype)initWithItemName:(NSString *)name
                  valueInDollars:(int)value
                    serialNumber:(NSString *)sNumber;

- (instancetype)initWithItemName:(NSString *)name;

- (instancetype)init;

- (void)setSubItems:(NSMutableArray *)items;
-(NSMutableArray *)subItems;

- (void)addObject:(BNRItem *)item;

@end
