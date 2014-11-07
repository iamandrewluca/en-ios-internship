//
//  BNRItem.h
//  RandomItems
//
//  Created by Andrei Luca on 10/8/14.
//  Copyright (c) 2014 Andrei Luca. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BNRItem : NSObject <NSCoding>

@property (nonatomic, copy) NSString *itemName;
@property (nonatomic, copy) NSString *serialNumber;
@property (nonatomic) int valueInDollars;
@property (nonatomic) NSDate *dateCreated;
@property (nonatomic, copy) NSString *itemKey;
@property (nonatomic) UIImage *thumbnail;

+ (instancetype)randomItem;

- (instancetype)initWithItemName:(NSString *)name
                  valueInDollars:(int)value
                    serialNumber:(NSString *)sNumber;

- (instancetype)initWithItemName:(NSString *)name;

- (void)setItemName:(NSString *)str;
- (NSString *)itemName;

- (void)setSerialNumber:(NSString *)str;
- (NSString *)serialNumber;

- (void)setValueInDollars:(int)value;
- (int)valueInDollars;

- (NSDate *)dateCreated;

- (void)setThumbnailFromImage:(UIImage *)image;

@end
