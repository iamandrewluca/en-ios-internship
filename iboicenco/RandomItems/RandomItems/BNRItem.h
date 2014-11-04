//
//  BNRItem.h
//  RandomItems
//
//  Created by iboicenco on 10/9/14.
//  Copyright (c) 2014 iboicenco. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BNRItem : NSObject
#pragma mark - declaring properties
@property (nonatomic, strong) BNRItem *containedItem;
@property (nonatomic, weak) BNRItem *container;

@property (nonatomic, copy) NSString *itemName; // When property points to an instance that has mutable subclass set attribute to copy.
@property (nonatomic, copy) NSString *serialNumber;
@property (nonatomic) int valueInDollars;
@property (nonatomic, readonly, strong) NSDate *dateCreated;

#pragma mark - instance variables
/*
{
    NSString *_itemName;
    NSString *_serialNumber;
    int _valueInDollars;
    NSDate *_dateCreated; // readonly
    
    BNRItem *_containedItem;
    __weak BNRItem *_container;  // weak reference.
}
 */

#pragma mark - class method
+(instancetype)randomItem;

#pragma mark - initializers
// Designated initializer for BNRItem
-(instancetype)initWithItemName:(NSString *)name
                 valueInDollars:(int)value
                   serialNumber:(NSString *)sNumber;

#pragma mark - additional initializers
-(instancetype)initWithItemName:(NSString *)name;

// Silver Challenge
-(instancetype)initWithName:(NSString *)name
               serialNumber:(NSString *)sNumber;

#pragma mark - accessors methods
/*
-(void)setContainedItem:(BNRItem *)item;
-(BNRItem *)containedItem;

-(void)setContainer:(BNRItem *)item;
-(BNRItem *)container;

- (void)setItemName:(NSString *)str;
- (NSString *)itemName;

- (void)setSerialNumber:(NSString *)str;
- (NSString *)serialNumber;

- (void)setValueInDollars:(int)v;
- (int)valueInDollars;

- (NSDate *)dateCreated;
 */

@end
