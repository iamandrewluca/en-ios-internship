//
//  main.m
//  RandomItems
//
//  Created by iboicenco on 10/9/14.
//  Copyright (c) 2014 iboicenco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BNRItem.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // Create a mutable array object, store it's address  in items variable
        NSMutableArray *items = [[NSMutableArray alloc]init];
        
        for (int i = 0; i<10; i++) {
            BNRItem *item = [BNRItem randomItem];
            [items addObject:item];
        }
        
        BNRItem *itemWithNameAndSerial = [[BNRItem alloc]initWithName:@"White Sofa" serialNumber:@"A1B77"];
        [items addObject:itemWithNameAndSerial];
        
//        id lastObj = [items lastObject];
//        [lastObj count];
        
        for (BNRItem *item in items) {
            NSLog(@"%@", item);
           // NSLog(@"%@", items[11]);   // Bronze Challenge
        }
        
/*
        // Send the message addObject: to the NSMutableArray pointed to
        // by the variable items, passing a string each time
        //[items addObject:@"One"];
        //[items addObject:@"Two"];
        //[items addObject:@"Three"];

        // Send another message, insertObject:atIndex:, to that same array object
        //[items insertObject:@"Zero" atIndex:0];
        
        // For every item in items array
        //for (NSString *item in items) {
            // Log the description of item
            //NSLog(@"%@", item);
*/
        
/*
        //BNRItem *item = [[BNRItem alloc]init];
        
        // This creates an NSString, "Red Sofa" and gives it to the BNRItem
        //[item setItemName:@"Red Sofa"];
        //item.itemName = @"Red Sofa";
        
        // This creates an NSString, "A1B2C" and gives it to the BNRItem
        //[item setSerialNumber:@"A1B2C"];
        //item.serialNumber = @"A1B2C";
        
        // This sends the value 100 to be used as the valueInDollars of this BNRItem
        //[item setValueInDollars:100];
        //item.valueInDollars = 100;
        
        //NSLog(@"%@ %@ %@ %d", [item itemName], [item dateCreated],
                              //[item serialNumber], [item valueInDollars]);
        //NSLog(@"%@ %@ %@ %d", item.itemName, item.dateCreated,
                             // item.serialNumber, item.valueInDollars);
        
        // The %@ token is replaced with the result of sending
        // the description message to the corresponding argument
*/
        
//        BNRItem *item = [[BNRItem alloc]initWithItemName:@"Red Sofa" valueInDollars:100 serialNumber:@"A1B2C"];
//        NSLog(@"%@", item);
//        
//        BNRItem *itemWithName = [[BNRItem alloc]initWithItemName:@"Blue Sofa"];
//        NSLog(@"%@", itemWithName);
//        
//        BNRItem *itemWithNoName = [[BNRItem alloc]init];
//        NSLog(@"%@", itemWithNoName);
        
        // Destroy the mutable array object
        items = nil;
    }
    return 0;
}
