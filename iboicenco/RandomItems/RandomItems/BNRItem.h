//
//  BNRItem.h
//  RandomItems
//
//  Created by iboicenco on 10/9/14.
//  Copyright (c) 2014 iboicenco. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - instance variables
@interface BNRItem : NSObject
{
    NSString *_itemName;
    NSString *_serialNumber;
    int _valueInDollars;
    NSDate *_dateCreated; // readonly
}

#pragma mark - class method
+(instancetype)randomItem;

#pragma mark - initializers
// Designated initializer for BNRItem
-(instancetype)initWithItemName:(NSString *)name
                 valueInDollars:(int)value
                   serialNumber:(NSString *)sNumber;


-(instancetype)initWithItemName:(NSString *)name;


#pragma mark - accessors methods
- (void)setItemName:(NSString *)str;
- (NSString *)itemName;

- (void)setSerialNumber:(NSString *)str;
- (NSString *)serialNumber;

- (void)setValueInDollars:(int)v;
- (int)valueInDollars;

- (NSDate *)dateCreated;

@end
