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
    
    CGRect toolbaFrame = CGRectMake(0, 50, webView.frame.size.width, 50);
    
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    
    [webView addSubview:toolbar];
    
    UIBarButtonItem *backwardButton = [[UIBarButtonItem alloc] initWithTitle:@"Backward" style:UIBarButtonItemStylePlain target:self action:@selector(backwardWebView)];
    UIBarButtonItem *forwardButton = [[UIBarButtonItem alloc] initWithTitle:@"Forward" style:UIBarButtonItemStylePlain target:self action:@selector(forwardWebView)];
    
    NSArray *toolbarButtons = [NSArray arrayWithObjects:backwardButton, forwardButton, nil];
    
    [toolbar setItems:toolbarButtons];
    
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

#pragma mark Buttons

- (void)backwardWebView
{
    if (((UIWebView *)self).canGoBack) {
        [((UIWebView *)self) goBack];
    }
}

- (void)forwardWebView
{
    if (((UIWebView *)self).canGoForward) {
        [((UIWebView *)self) goForward];
    }

}

@end