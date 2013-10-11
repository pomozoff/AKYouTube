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

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    [YTConnector.sharedInstance authorizeAppWithScopesList:nil
                                     inLoginViewController:(UIViewController<YTLoginViewControllerInterface> *)self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
