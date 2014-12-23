//
//  ImagesStore.m
//  ENote
//
//  Created by Andrei Luca on 12/23/14.
//  Copyright (c) 2014 Endava. All rights reserved.
//

#import "ImagesStore.h"
#import "NotesStore.h"
#import "NotebooksStore.h"

typedef NS_ENUM(NSUInteger, ImageSizeType)
{
    ImageSizeOriginal,
    ImageSizeThumb,
    ImageSizePreview
};

@implementation ImagesStore

+ (instancetype)sharedStore
{
    static ImagesStore *sharedStore = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedStore = [[self alloc] init];
    });
    
    return sharedStore;
}

- (NotesStore *)storeForNote:(Note *)note
{
    return [[NotebooksStore sharedStore] notesStoreForNotebookID:note.notebookID];
}

- (void)addImage:(UIImage *)image forNote:(Note *)note
{
    NSString *newImageID = [[NSUUID UUID] UUIDString];
    
    if (![note.imagesIDs count]) {
        note.thumbID = newImageID;
        
        UIImage *thumb = [self prepareThumbForImage:image];
        NSData *thumbData = UIImageJPEGRepresentation(thumb, 1.0f);
        [[NSFileManager defaultManager] createFileAtPath:[self pathForImageWithID:newImageID forNote:note withSize:ImageSizeThumb] contents:thumbData attributes:nil];
    }
    
    UIImage *preview = [self preparePreviewForImage:image];
    NSData *previewData = UIImageJPEGRepresentation(preview, 1.0);
    [[NSFileManager defaultManager] createFileAtPath:[self pathForImageWithID:newImageID forNote:note withSize:ImageSizePreview] contents:previewData attributes:nil];
    
    [note addImageID:newImageID];
    [[self storeForNote:note] saveNote:note];
    
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0f);
    
    [[NSFileManager defaultManager] createFileAtPath:[self pathForImageWithID:newImageID forNote:note withSize:ImageSizeOriginal] contents:imageData attributes:nil];
}

- (UIImage *)preparePreviewForImage:(UIImage *)image
{
    return [self createImageWithSize:CGSizeMake(64, 64) fromImage:image];
}

- (UIImage *)prepareThumbForImage:(UIImage *)image
{
    return [self createImageWithSize:CGSizeMake(100, 100) fromImage:image];
}

- (UIImage *)createImageWithSize:(CGSize)size fromImage:(UIImage *)image
{
    CGSize originalImageSize = image.size;
    CGRect finalImageSize = CGRectMake(0, 0, size.width, size.height);
    
    UIGraphicsBeginImageContext(finalImageSize.size);
    
    CGRect projectRect;
    
    if (originalImageSize.width > originalImageSize.height) {
        projectRect.size.height = size.height;
        projectRect.size.width = size.width * originalImageSize.width / originalImageSize.height;
    } else {
        projectRect.size.width = size.width;
        projectRect.size.height = size.height * originalImageSize.height / originalImageSize.width;
    }
    
    projectRect.origin.x = (finalImageSize.size.width - projectRect.size.width) / 2.0;
    projectRect.origin.y = (finalImageSize.size.height - projectRect.size.height) / 2.0;
    
    [image drawInRect:projectRect];
    
    UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return finalImage;
}

- (void)removeImageForNote:(Note *)note withImageID:(NSString *)ID
{
    [[NSFileManager defaultManager] removeItemAtPath:[self pathForImageWithID:ID forNote:note withSize:ImageSizeOriginal] error:nil];
    [[NSFileManager defaultManager] removeItemAtPath:[self pathForImageWithID:ID forNote:note withSize:ImageSizePreview] error:nil];
    
    if ([note.thumbID isEqualToString:ID]) {
        [[NSFileManager defaultManager] removeItemAtPath:[self pathForImageWithID:ID forNote:note withSize:ImageSizeThumb] error:nil];
        note.thumbID = @"";
    }
    
    [note removeImageID:ID];
    
    [[self storeForNote:note] saveNote:note];
}

- (NSString *)pathForImageWithID:(NSString *)ID forNote:(Note *)note withSize:(ImageSizeType)type
{
    return [NSString stringWithFormat:@"%@/%lu%@.jpg", [note path], type, ID];
}

- (UIImage *)imageWithSize:(ImageSizeType)type forNote:(Note *)note withImageID:(NSString *)ID
{
    NSString *notePath = [note path];
    
    NSData *imageData = [[NSFileManager defaultManager] contentsAtPath:[NSString stringWithFormat:@"%@/%lu%@.jpg", notePath, type, ID]];
    
    UIImage *finalImage = [UIImage imageWithData:imageData];
    
    return finalImage;
}

/*
 * This Method returns original image size
 */
- (UIImage *)imageForNote:(Note *)note withImageID:(NSString *)ID
{
    return [self imageWithSize:ImageSizeOriginal forNote:note withImageID:ID];
}

- (UIImage *)thumbForNote:(Note *)note
{
    return [self imageWithSize:ImageSizeThumb forNote:note withImageID:note.thumbID];
}

- (UIImage *)previewForNote:(Note *)note withImageID:(NSString *)ID
{
    return [self imageWithSize:ImageSizePreview forNote:note withImageID:ID];
}

@end
