//
//  BNRContainer.m
//  RandomItems
//
//  Created by Andrei Luca on 10/8/14.
//  Copyright (c) 2014 Andrei Luca. All rights reserved.
//

#import "BNRContainer.h"

@implementation BNRContainer

- (void)setSubItems:(NSMutableArray *)items
{
    _subItems = items;
}

- (NSMutableArray *)subItems
{
    return _subItems;
}

- (void)addObject:(BNRItem *)item
{
    [_subItems addObject:item];
}

- (NSString *)description
{
    int totalValueInDollars = [self valueInDollars];
    
    NSString *subItemsDescription = [[NSString alloc] init];
    
    for (BNRItem *item in _subItems) {
        totalValueInDollars += [item valueInDollars];
        
        subItemsDescription = [subItemsDescription stringByAppendingFormat:@"\n%@",
                               [item description]];
    }
    
    return [[NSString alloc] initWithFormat:@"(C) %@ (%@) Worth: $%d Childs:%@",
            self.itemName, self.serialNumber, totalValueInDollars, subItemsDescription];
}

- (instancetype)initWithItemName:(NSString *)name valueInDollars:(int)value serialNumber:(NSString *)sNumber
{
    self = [super initWithItemName:name valueInDollars:value serialNumber:sNumber];
    
    if (self) {
        _subItems = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (instancetype)initWithItemName:(NSString *)name
{
    return [self initWithItemName:name valueInDollars:0 serialNumber:@""];
}

- (instancetype)initWithItem:(BNRItem *)item
{
    return [self initWithItemName:item.itemName valueInDollars:item.valueInDollars serialNumber:item.serialNumber];
}

- (instancetype)init
{
    return [self initWithItemName:@"ItemsContainer"];
}

+ (BNRContainer *)randomItem
{
    return [[BNRContainer alloc] initWithItem:[super randomItem]];
}

@end
