//
//  BNRWebViewController.m
//  BNRNerdFeed
//
//  Created by Andrei Luca on 10/29/14.
//  Copyright (c) 2014 Andrei Luca. All rights reserved.
//

#import "BNRWebViewController.h"

@interface BNRWebViewController () <UIWebViewDelegate>


@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backward;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *forward;

@end

@implementation BNRWebViewController

#pragma mark View

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self checkHistory];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
}

#pragma mark UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    [self checkHistory];
    
    return YES;
}

#pragma mark Init

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        [self loadView];
        self.webView.delegate = self;
    }
    
    return self;
}

#pragma mark Set

- (void)setURL:(NSURL *)URL
{
    _URL = URL;
    
    if (_URL) {
        NSURLRequest *req = [NSURLRequest requestWithURL:URL];
        
        [self.webView loadRequest:req];
    }
}

#pragma mark Buttons

- (IBAction)goBackward:(id)sender
{
    if (self.webView.canGoBack) {
        [self.webView goBack];
    }
}

- (IBAction)goForward:(id)sender
{
    if (self.webView.canGoForward) {
        [self.webView goForward];
    }
}

#pragma mark Other

- (void)checkHistory
{
    if (self.webView.canGoBack) {
        self.backward.enabled = YES;
    } else {
        self.backward.enabled = NO;
    }
    
    if (self.webView.canGoForward) {
        self.forward.enabled = YES;
    } else {
        self.forward.enabled = NO;
    }
}

@end