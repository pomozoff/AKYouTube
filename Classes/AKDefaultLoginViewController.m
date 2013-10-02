//
//  AKDefaultLoginViewController.m
//  AKYouTube
//
//  Created by Anton Pomozov on 25.09.13.
//  Copyright (c) 2013 Akademon Ltd. All rights reserved.
//

#import "AKDefaultLoginViewController.h"

@interface AKDefaultLoginViewController ()

@end

@implementation AKDefaultLoginViewController

@synthesize webView = _webView;

#pragma mark - Private methods

- (void)presentSubviews:(UIView *)view {
    [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.view addSubview:view];
}

#pragma mark - Properties

- (UIWebView *)webView {
    if (!_webView) {
        UIWebView *webView = [[UIWebView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
        webView.delegate = self;
        webView.scalesPageToFit = YES;
        webView.backgroundColor = [UIColor clearColor];
        [self presentSubviews:webView];
        
        _webView = webView;
    }
    
    return _webView;
}

#pragma mark - Lifecycle

- (void)loadView {
    self.view.backgroundColor = [UIColor blackColor];
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor clearColor];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
