//
//  BNRWebViewController.m
//  BNRNerdFeed
//
//  Created by Andrei Luca on 10/29/14.
//  Copyright (c) 2014 Andrei Luca. All rights reserved.
//

#import "BNRWebViewController.h"

@implementation BNRWebViewController

#pragma mark View

- (void)loadView
{
    UIWebView *webView = [[UIWebView alloc] init];
    
    webView.scalesPageToFit = YES;
    
    self.view = webView;
}

#pragma mark Set

-(void)setURL:(NSURL *)URL
{
    _URL = URL;
    
    if (_URL) {
        NSURLRequest *req = [NSURLRequest requestWithURL:URL];
        
        [(UIWebView *)self.view loadRequest:req];
    }
}

@end