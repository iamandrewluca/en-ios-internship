//  Note.h
//  ENote
//
//  Created by Andrei Luca on 11/12/14.
//  Copyright (c) 2014 Endava. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Note : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *noteFolder;
@property (nonatomic, readonly, copy) NSDate *dateCreated;

- (instancetype)initWithName:(NSString *)name;
- (instancetype)initWithName:(NSString *)name withText:(NSString *)text atDate:(NSDate *)date andFolder:(NSString *)folder;
- (NSDictionary *)dictionaryRepresentation;

// for future features )
// @property (nonatomic) UIImage *image;

@end
