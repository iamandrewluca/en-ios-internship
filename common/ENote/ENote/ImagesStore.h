//
//  ImagesStore.h
//  ENote
//
//  Created by Andrei Luca on 12/23/14.
//  Copyright (c) 2014 Endava. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Note.h"

@interface ImagesStore : NSObject

- (void)addImage:(UIImage *)image forNote:(Note *)note;
- (void)removeImageForNote:(Note *)note withImageID:(NSString *)ID;
- (UIImage *)imageForNote:(Note *)note withImageID:(NSString *)ID;
- (UIImage *)thumbForNote:(Note *)note;
- (UIImage *)previewForNote:(Note *)note withImageID:(NSString *)ID;

+ (instancetype)sharedStore;

@end
