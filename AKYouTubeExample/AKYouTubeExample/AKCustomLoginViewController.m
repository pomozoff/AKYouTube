//
//  AKCustomLoginViewController.m
//  AKYouTubeExample
//
//  Created by Anton Pomozov on 11.10.13.
//  Copyright (c) 2013 Akademon Ltd. All rights reserved.
//

#import "AKCustomLoginViewController.h"

@interface AKCustomLoginViewController ()

@property (nonatomic, strong) IBOutlet UIWebView *webView;

@end

@implementation AKCustomLoginViewController

#pragma mark - Synthesizes

@synthesize webView = _webView;
@synthesize connector = _connector;

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    [YTConnector.sharedInstance authorizeAppWithScopesList:nil
                                     inLoginViewController:(UIViewController<YTLoginViewControllerInterface> *)self];
}
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [self.connector freeLoginViewController];
}
- (void)dealloc {
    self.webView.delegate = nil;
    [self.webView stopLoading];
}

@end
