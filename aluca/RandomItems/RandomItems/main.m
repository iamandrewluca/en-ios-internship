//
//  main.m
//  RandomItems
//
//  Created by Andrei Luca on 10/7/14.
//  Copyright (c) 2014 Andrei Luca. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BNRItem.h"
#import "BNRContainer.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        BNRContainer *items = [BNRContainer randomItem];
        
        for (int i = 0; i < 10; i++) {
            BNRItem *item = (i % 2) ? [BNRItem randomItem] : [BNRContainer randomItem];
            
            [items addObject:item];
        }
        
        NSLog(@"%@", items);
        
        items = nil;
        
    }
    return 0;
}
