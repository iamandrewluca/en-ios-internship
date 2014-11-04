//
//  BNRImageStore.h
//  BNRHomepwner
//
//  Created by Andrei Luca on 10/21/14.
//  Copyright (c) 2014 Andrei Luca. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BNRImageStore : NSObject

+ (instancetype)sharedStore;
- (void)setImage:(UIImage *)image forKey:(NSString *)key;
- (UIImage *)imageForKey:(NSString *)key;
- (void)deleteImageForKey:(NSString *)key;

@end
