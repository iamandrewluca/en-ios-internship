//
//  main.m
//  RandomItems
//
//  Created by Andrei Luca on 10/7/14.
//  Copyright (c) 2014 Andrei Luca. All rights reserved.
//

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        NSMutableArray *items = [[NSMutableArray alloc] init];
        
        [items addObject:@"One"];
        [items addObject:@"Two"];
        [items addObject:@"Three"];
        [items insertObject:@"Zero" atIndex:0];
        
        items = nil;
        
        for (NSString *item in items) {
            
            NSLog(@"%@", item);
            
        }
        
    }
    return 0;
}
