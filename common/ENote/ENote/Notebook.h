//
//  Notebook.h
//  ENote
//
//  Created by Andrei Luca on 11/11/14.
//  Copyright (c) 2014 Endava. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Notebook : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *folderName;
@property (nonatomic, copy, readonly) NSDate *dateCreated;
@property (nonatomic) NSMutableArray *notes;

- (instancetype)initWithName:(NSString *)name;

@end
