//
//  ENoteCommons.h
//  ENote
//
//  Created by Andrei Luca on 11/18/14.
//  Copyright (c) 2014 Endava. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ENoteCommons : NSObject

@property (nonatomic, readonly) NSString *documentDirectory;
@property (nonatomic, readonly) NSString *indexFile;

- (NSArray *)getValidItemsPathsInFolder:(NSString *)folder;

+ (instancetype)shared;

@end
