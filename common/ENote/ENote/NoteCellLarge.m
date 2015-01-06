//
//  NoteCellLarge.m
//  ENote
//
//  Created by Iurii Boicenco on 12/18/14.
//  Copyright (c) 2014 Endava. All rights reserved.
//

#import "NoteCellLarge.h"

@implementation NoteCellLarge

-(id)init
{
    if (!(self = [super init])) return nil;
    
    self.itemSize = CGSizeMake(100, 100);
    self.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    self.minimumInteritemSpacing = 10.0f;
    self.minimumLineSpacing = 10.0f;
    
    return self;
}

@end
