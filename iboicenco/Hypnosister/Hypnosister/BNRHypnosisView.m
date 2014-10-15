//
//  BNRHypnosisView.m
//  Hypnosister
//
//  Created by iboicenco on 10/13/14.
//  Copyright (c) 2014 iboicenco. All rights reserved.
//

#import "BNRHypnosisView.h"

@implementation BNRHypnosisView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // All BNRHypnosisViews start with a clear background color.
        self.backgroundColor = [UIColor yellowColor];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
- (void)drawRect:(CGRect)rect
{
    CGRect bounds = self.bounds;
    CGContextRef currentContext = UIGraphicsGetCurrentContext();  // The current context is an application-wide pointer that is set to point to the context created for a view right before that view is sent drawRect:.
    
    // Figure out the center of the bounds rectangle
    CGPoint center;
    center.x = bounds.origin.x + bounds.size.width / 2.0;
    center.y = bounds.origin.y + bounds.size.height / 2.0;
    
    // The circle will be the largest that will fit in the view
    //float radius = (MIN(bounds.size.width, bounds.size.height) / 2.0);
    
    // The largest circle will circumscribe the view
    float maxRadius = hypot(bounds.size.width, bounds.size.height) / 2.0;
    
    
    UIBezierPath *path = [[UIBezierPath alloc]init];
/*
     // Add an arc to the path at center, with radius of radius from 0 to 2*PI radians (a circle)
     //    [path addArcWithCenter:center
     //                    radius:radius
     //                startAngle:0
     //                  endAngle:M_PI * 2.0
     //                 clockwise:YES];
*/
    for (float currentRadius = maxRadius; currentRadius > 0; currentRadius -= 20) {
        
        // pick up the pencil and move it to the correct spot
        [path moveToPoint:CGPointMake(center.x + currentRadius, center.y)];
        
        [path addArcWithCenter:center
                        radius:currentRadius
                    startAngle:0.0
                      endAngle:M_PI * 2.0
                     clockwise:YES];
    }
    // Configure line width to 10 points
    path.lineWidth = 10;
    // Configure the drawing color to light gray
    [[UIColor blueColor]setStroke];
    // Draw the line
    [path stroke];
    
    // Draw logo image      #### bronze challenge ####
    //    CGRect logo = CGRectMake(bounds.size.width / 4.0, bounds.size.height / 4.0, bounds.size.width / 2.0, bounds.size.height / 2.0);
    //    UIImage *logoImage = [UIImage imageNamed:@"logo"];
    //    [logoImage drawInRect:logo];
    
    // Draw shadows - bronze + golden challenge
    CGRect logoRect = CGRectMake(bounds.size.width / 4.0, bounds.size.height / 4.0, bounds.size.width / 2.0, bounds.size.height / 2.0);
    
    CGContextSaveGState(currentContext); // there is no function for clearing the clip path, so typically we save the graphics state before installing the clipping path and restore the state
    UIBezierPath *trianglePath = [[UIBezierPath alloc] init];
    [trianglePath moveToPoint:CGPointMake(center.x, logoRect.origin.y)];
    [trianglePath addLineToPoint:CGPointMake(logoRect.origin.x, logoRect.origin.y + logoRect.size.height)];
    [trianglePath addLineToPoint:CGPointMake(logoRect.origin.x + logoRect.size.width, logoRect.origin.y + logoRect.size.height)];
    [trianglePath closePath];
    
    [trianglePath addClip];   // if !clipping path the gradients will cover everything in the view
    
    CGFloat locations[2] = {0.0, 1.0};
    CGFloat components[8] = {0.0, 1.0, 0.0, 1.0,  // Start color
                             1.0, 1.0, 0.0, 1.0};  // End color
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB(); // Ref sufix incorporate the asteriks(*) and have strong ownership
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, components, locations, 2); // Ref
    
    CGPoint startPoint = CGPointMake(center.x, logoRect.origin.y);
    CGPoint endPoint = CGPointMake(center.x, logoRect.origin.y + logoRect.size.height);
    
    CGContextDrawLinearGradient(currentContext, gradient, startPoint, endPoint, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    
    //The rule is: if you create a Core Graphics object with a function that has the word Create or Copy in it, you must call the matching Release function and pass a pointer to the object as the first argument
    CGColorSpaceRelease(colorSpace); // Strong ownership so must be released
    CGGradientRelease(gradient);     // Strong ownership so must be released
    CGContextRestoreGState(currentContext); // restore the state
    
    
    CGContextSaveGState(currentContext); // need to save graphics state before setting the shadow and then restore if after setting the shadow
    CGContextSetShadow(currentContext, CGSizeMake(8, 14), 2); // offset and blur in points
    UIImage *logoImage = [UIImage imageNamed:@"logo.png"];
    [logoImage drawInRect:logoRect];
    CGContextRestoreGState(currentContext); // if !restore CGContextState the shadow will not unset
}


@end
