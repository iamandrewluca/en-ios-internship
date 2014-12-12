//
//  NotesStore.m
//  ENote
//
//  Created by Andrei Luca on 11/12/14.
//  Copyright (c) 2014 Endava. All rights reserved.
//

#import "NotesStore.h"
#import "Note.h"
#import "Notebook.h"
#import "NotebooksStore.h"
#import "ENoteCommons.h"
#import "TagsStore.h"

@interface NotesStore ()

@property (nonatomic) NSMutableArray *allPrivateNotes;
@property (nonatomic, copy) NSMutableDictionary *notesThumbs;

@end

@implementation NotesStore

- (void)addImage:(UIImage *)image forNote:(Note *)note
{
    note.imageName = [[NSUUID UUID] UUIDString];
    note.thumbName = [[NSUUID UUID] UUIDString];
    
    [self saveNote:note];
    
    UIImage *thumb = [self prepareThumbForImage:image];
    
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0f);
    NSData *thumbData = UIImageJPEGRepresentation(thumb, 1.0f);
    
    NSString *notePath = [self pathForNote:note];
    
    [[NSFileManager defaultManager] createFileAtPath:[NSString stringWithFormat:@"%@/%@.jpg", notePath, note.imageName] contents:imageData attributes:nil];
    [[NSFileManager defaultManager] createFileAtPath:[NSString stringWithFormat:@"%@/%@.jpg", notePath, note.thumbName] contents:thumbData attributes:nil];
    
    [_notesThumbs setValue:thumb forKey:note.ID];
}

- (UIImage *)prepareThumbForImage:(UIImage *)image
{
    CGSize originalImageSize = image.size;
    CGRect thumbImageSize = CGRectMake(0, 0, 100, 100);
    
    UIGraphicsBeginImageContext(thumbImageSize.size);
    
    CGRect projectRect;
    
    if (originalImageSize.width > originalImageSize.height) {
        projectRect.size.height = 100.0f;
        projectRect.size.width = 100.0f * originalImageSize.width / originalImageSize.height;
    } else {
        projectRect.size.width = 100.0f;
        projectRect.size.height = 100.0f * originalImageSize.height / originalImageSize.width;
    }
    
    projectRect.origin.x = (thumbImageSize.size.width - projectRect.size.width) / 2.0;
    projectRect.origin.y = (thumbImageSize.size.height - projectRect.size.height) / 2.0;
    
    [image drawInRect:projectRect];
    
    UIImage *thumbImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return thumbImage;
}

- (NSString *)pathForNote:(Note *)note
{
    return [NSString stringWithFormat:@"%@/%@/%@", [[ENoteCommons shared] documentDirectory], _notebook.ID, note.ID];
}

- (void)removeImageForNote:(Note *)note
{
    [_notesThumbs removeObjectForKey:note.ID];
    
    NSString *notePath = [self pathForNote:note];
    
    [[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"%@/%@.jpg", notePath, note.imageName] error:nil];
    [[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"%@/%@.jpg", notePath, note.thumbName] error:nil];
    
    note.imageName = @"";
    note.thumbName = @"";
    
    [self saveNote:note];
}

- (UIImage *)imageForNote:(Note *)note
{
    return [_notesThumbs valueForKey:note.ID];
}

- (instancetype)initWithNotebook:(Notebook *)notebook {
    
    self = [super init];
    
    if (self) {
        _allPrivateNotes = [[NSMutableArray alloc] init];
        _notebook = notebook;
        _notesThumbs = [NSMutableDictionary new];

        [self loadNotes];
    }
    
    return self;
}


- (NSArray *)allNotes {
    return _allPrivateNotes;
}

- (void)saveNote:(Note *)note {
    
    NSString *notePath = [self pathForNote:note];
    
    [[NSFileManager defaultManager] createDirectoryAtPath:notePath
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:nil];
    
    NSData *noteData = [NSJSONSerialization dataWithJSONObject:[note dictionaryRepresentation]
                                                           options:0
                                                             error:nil];
    
    NSString *indexPath = [NSString stringWithFormat:@"%@/%@", notePath, [[ENoteCommons shared] indexFile]];
    
    [[NSFileManager defaultManager] createFileAtPath:indexPath contents:noteData attributes:nil];
}

- (void)saveNoteWithID:(NSString *)ID {
    for (Note *note in _allPrivateNotes) {
        if ([ID isEqualToString:note.ID]) {
            [self saveNote:note];
            return;
        }
    }
}

- (void)addNote:(Note *)note {
    [_allPrivateNotes insertObject:note atIndex:0];
}

- (Note *)createNoteWithName:(NSString *)name {
    
    Note *note = [[Note alloc] initWithName:name forNotebookID:_notebook.ID];
    
    [_notebook addNoteID:note.ID];
    [[NotebooksStore sharedStore] saveNotebook:_notebook];

    [self addNote:note];
    [self saveNote:note];
    return note;
}

- (void)loadThumbForNote:(Note *)note
{
    NSString *notePath = [self pathForNote:note];
    
    NSData *thumbData = [[NSFileManager defaultManager] contentsAtPath:[NSString stringWithFormat:@"%@/%@.jpg", notePath, note.thumbName]];
    
    UIImage *thumbImage = [UIImage imageWithData:thumbData];
    
    [_notesThumbs setValue:thumbImage forKey:note.ID];
}

- (void)addNoteWithDictionary:(NSDictionary *)dictionary {
    Note *note = [[Note alloc] initWithDictionary:dictionary];
    
    [self loadThumbForNote:note];
    
    // maybe forin within SharedStore all tags?
    for (int i = 0; i < [note.tagsIDs count]; i++) {
        NSString *tagID = note.tagsIDs[i];
        
        if (![[TagsStore sharedStore] getTagWithID:tagID]) {
            [note removeTagID:tagID];
        }
    }
    
    [self addNote:note];
}

- (void)removeNote:(Note *)note {
    
    [_notebook removeNoteID:note.ID];
    [[NotebooksStore sharedStore] saveNotebook:_notebook];
    
    [_notesThumbs removeObjectForKey:note.ID];
    
    NSString *itemPath = [NSString stringWithFormat:@"%@/%@/%@", [[ENoteCommons shared] documentDirectory], _notebook.ID, note.ID];
    
    [[NSFileManager defaultManager] removeItemAtPath:itemPath error:nil];
    
    [_allPrivateNotes removeObject:note];
}

- (void)removeNoteWithID:(NSString *)ID {
    for (Note *note in _allPrivateNotes) {
        if ([ID isEqualToString:note.ID]) {
            [self removeNote:note];
            return;
        }
    }
}

- (Note *)noteWithID:(NSString *)ID {
    for (Note *note in _allPrivateNotes) {
        if ([ID isEqualToString:note.ID]) {
            return note;
        }
    }
    
    return nil;
}

- (void)loadNotes {
    
    for (NSString *noteID in _notebook.notesIDs) {
        
        NSString *itemPath = [NSString stringWithFormat:@"%@/%@/%@", [[ENoteCommons shared] documentDirectory], _notebook.ID, noteID];
        
        NSString *indexPath = [NSString stringWithFormat:@"%@/%@", itemPath, [[ENoteCommons shared] indexFile]];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:indexPath]) {
            
            NSData *itemData = [[NSFileManager defaultManager] contentsAtPath:indexPath];
            NSDictionary *itemDictionary = [NSJSONSerialization JSONObjectWithData:itemData options:NSJSONReadingMutableContainers error:nil];
            [self addNoteWithDictionary:itemDictionary];
        }
    }
}

@end
