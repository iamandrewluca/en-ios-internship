//
//  BNRItem.m
//  RandomItems
//
//  Created by iboicenco on 10/9/14.
//  Copyright (c) 2014 iboicenco. All rights reserved.
//

#import "BNRItem.h"

@implementation BNRItem
#pragma mark - overriding methods
-(NSString *)description
{
    NSString *descriptionString = [[NSString alloc] initWithFormat:@"%@ (%@): Worth $%d, recorded on %@",
                                                    self.itemName,
                                                    self.serialNumber,
                                                    self.valueInDollars,
                                                    self.dateCreated];
    return descriptionString;
}

#pragma mark - designated initializer
- (instancetype)initWithItemName:(NSString *)name
                  valueInDollars:(int)value
                    serialNumber:(NSString *)sNumber
{
    // Call the superclass's designated initializer
    self = [super init];
    // Did the superclass's designated initializer succeed?
    if (self) {
        // Give the instance variables initial values
        _itemName = name;
        _serialNumber = sNumber;
        _valueInDollars = value;
        // Set _dateCreated to the current date and time
        _dateCreated = [[NSDate alloc] init];
    }
    // Return the address of the newly initialized object
    return self;
}

#pragma mark - additional initializers
-(instancetype)init
{
    return  [self initWithItemName:@"Item"];
}

-(instancetype)initWithItemName:(NSString *)name
{
    return [self initWithItemName:name
                   valueInDollars:0
                     serialNumber:@""];
    
    
}

#pragma mark - Silver Challenge
-(instancetype)initWithName:(NSString *)name serialNumber:(NSString *)sNumber
{
    return [self initWithItemName:name
                   valueInDollars:0
                     serialNumber:sNumber];
}

#pragma mark - class methods
+(instancetype)randomItem
{
    // Create a immutable array of three adjectives
    NSArray *randomAdjectiveList = @[@"Fluffy", @"Rusty", @"Shiny"];
    // Create a immutable array of three nouns
    NSArray *randomNounList = @[@"Bear", @"Spork", @"Mac"];
    
    // Get the index of a ramdom adjective/noun from the lists
    // Note: The % operator, called the modulo operator, gives
    // you the reminder. So adjectiveIndex is a random number from 0 to 2 inclusive.
    
    NSInteger adjectiveIndex = arc4random() % [randomAdjectiveList count];
    NSInteger nounIndex = arc4random() % [randomNounList count];
    
    // Note that NSInteger is not an object, but a type definition for long.
    NSString *randomName = [NSString stringWithFormat:@"%@, %@", [randomAdjectiveList objectAtIndex:adjectiveIndex],
                                                                 [randomNounList objectAtIndex:nounIndex]];
    int randomValue = arc4random() % 100;
    
    NSString *randomSerialNumber = [NSString stringWithFormat:@"%c%c%c%c%c", '0' + arc4random() % 10,
                                                                             'A' + arc4random() % 26,
                                                                             '0' + arc4random() % 10,
                                                                             'A' + arc4random() % 26,
                                                                             '0' + arc4random() % 10];
    
    BNRItem *newItem = [[BNRItem alloc]initWithItemName:randomName
                                         valueInDollars:randomValue
                                           serialNumber:randomSerialNumber];
    return newItem;
}

-(void)dealloc
{
    NSLog(@"Destroyed: %@", self);
}

#pragma mark - defining accessors methods
-(void)setContainedItem:(BNRItem *)containedItem
{
    _containedItem = containedItem;
    self.containedItem.container = self;
}

/*
-(void)setContainedItem:(BNRItem *)item
{
    _containedItem = item;
    
    // When given an item to contain, the contained item will be given a pointer to its container
    item.container = self;
}

-(BNRItem *)containedItem
{
    return _containedItem;
}

-(void)setContainer:(BNRItem *)item
{
    _container = item;
}

-(BNRItem *)container
{
    return _container;
}

- (void)setItemName:(NSString *)str
{
    _itemName = str;
}

- (NSString *)itemName
{
    return _itemName;
}

- (void)setSerialNumber:(NSString *)str
{
    _serialNumber = str;
}

- (NSString *)serialNumber
{
    return _serialNumber;
}

- (void)setValueInDollars:(int)v
{
    _valueInDollars = v;
}

- (int)valueInDollars
{
    return _valueInDollars;
}

- (NSDate *)dateCreated
{
    return _dateCreated;
}
 */

@end
