//
//  BHPhoto.m
//  CollectionViewTutorial
//
//  Created by Bryan Hansen on 11/3/12.
//  Copyright (c) 2012 Bryan Hansen. All rights reserved.
//

#import "Note.h"

@interface Note ()

@property (nonatomic, strong, readwrite) NSURL *imageURL;
@property (nonatomic, strong, readwrite) UIImage *noteImage;

@end

@implementation Note

#pragma mark - Properties

- (UIImage *)image
{
    if (!_noteImage && self.imageURL) {
        NSData *imageData = [NSData dataWithContentsOfURL:self.imageURL];
        UIImage *noteImage = [UIImage imageWithData:imageData scale:[UIScreen mainScreen].scale];
        
        _noteImage = noteImage;
    }
    
    return _noteImage;
}

#pragma mark - Lifecycle

+ (Note *)noteWithImageURL:(NSURL *)imageURL
{
    return [[self alloc] initWithImageURL:imageURL];
}

- (id)initWithImageURL:(NSURL *)imageURL
{
    self = [super init];
    if (self) {
        self.imageURL = imageURL;
    }
    return self;
}

@end
