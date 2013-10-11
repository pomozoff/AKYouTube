//
//  YTLoginViewController.m
//  AKYouTube
//
//  Created by Anton Pomozov on 10.09.13.
//  Copyright (c) 2013 Akademon Ltd. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "YTLoginViewController.h"
#import "YTConstants.h"

@interface YTLoginViewController ()

@property (nonatomic, strong) UIView *backView;

@end

@implementation YTLoginViewController

#pragma mark - Synthesizes

@synthesize webView = _webView;
@synthesize shouldPresentCloseButton = _shouldPresentCloseButton;
@synthesize closeButtonImageName = _closeButtonImageName;

#define CLOSE_BUTTON_SIZE 15.0f
#define MARGIN_BACK_VIEW_X 15.0f
#define MARGIN_BACK_VIEW_TOP 30.0f
#define MARGIN_BACK_VIEW_BOTTOM 25.0f
#define SHIFT_WEBVIEW 2.0f
#define VIEWS_CORNER_RADIUS 5.0f

#pragma mark - Private methods

- (void)closeButtonPressed:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}
- (CGRect)makeRectForView {
    CGRect appFrame = UIScreen.mainScreen.applicationFrame;
    CGRect rectWebView = CGRectMake(MARGIN_BACK_VIEW_X,
                                    MARGIN_BACK_VIEW_TOP,
                                    appFrame.size.width - MARGIN_BACK_VIEW_X * 2,
                                    appFrame.size.height - MARGIN_BACK_VIEW_BOTTOM);
    
    return rectWebView;
}
- (CGRect)makeRectForWebView {
    CGRect backFrame = self.backView.frame;
    CGRect rectWebView = CGRectMake(SHIFT_WEBVIEW,
                                    SHIFT_WEBVIEW,
                                    backFrame.size.width - SHIFT_WEBVIEW * 2,
                                    backFrame.size.height - SHIFT_WEBVIEW * 2);
    
    return rectWebView;
}
- (void)addCloseButton {
    if (self.navigationController) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                              target:self
                                                                                              action:@selector(closeButtonPressed:)];
    } else {
        CGRect backRect = self.backView.frame;
        CGFloat closeButtonX = backRect.origin.x - CLOSE_BUTTON_SIZE / 2;
        CGFloat closeButtonY = backRect.origin.y - CLOSE_BUTTON_SIZE / 2;
        
        CGRect rectCloseButton = CGRectMake(closeButtonX, closeButtonY, CLOSE_BUTTON_SIZE, CLOSE_BUTTON_SIZE);
        UIButton *closeButtonView = [[UIButton alloc] initWithFrame:rectCloseButton];
        [closeButtonView addTarget:self action:@selector(closeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [closeButtonView setImage:self.closeButtonImageName forState:UIControlStateNormal];
        [self.view addSubview:closeButtonView];
    }
}
- (void)removeSubviewsFromSuperviews {
    [self.backView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}
- (void)presentViews {
    [self removeSubviewsFromSuperviews];
    
    self.webView.frame = [self makeRectForWebView];
    [self.view addSubview:self.backView];
    [self.backView addSubview:self.webView];
    
    if (self.shouldPresentCloseButton) {
        [self addCloseButton];
    }
}

#pragma mark - Properties

- (UIWebView *)webView {
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:[self makeRectForWebView]];
        _webView.scalesPageToFit = YES;
        _webView.opaque = NO;
        _webView.backgroundColor = [UIColor clearColor];
        _webView.layer.cornerRadius = VIEWS_CORNER_RADIUS;
        _webView.layer.masksToBounds = YES;
    }
    
    return _webView;
}
- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] initWithFrame:[self makeRectForView]];
        _backView.backgroundColor = [UIColor lightGrayColor];
        _backView.layer.cornerRadius = VIEWS_CORNER_RADIUS;
    }
    
    return _backView;
}
- (UIImage *)closeButtonImageName {
    if (!_closeButtonImageName) {
        _closeButtonImageName = [UIImage imageNamed:@"closeButtonImageLoginViewController"];
    }
    
    return _closeButtonImageName;
}

#pragma mark - Lifecycle

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self presentViews];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
