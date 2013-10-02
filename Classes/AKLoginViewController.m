//
//  AKLoginViewController.m
//  AKYouTube
//
//  Created by Anton Pomozov on 10.09.13.
//  Copyright (c) 2013 Akademon Ltd. All rights reserved.
//

#import "AKLoginViewController.h"
#import "AKYouTubeConstants.h"

@interface AKLoginViewController ()

@end

@implementation AKLoginViewController

@synthesize loginUrl = _loginUrl;
@synthesize webView = _webView;
@synthesize loginDelegate = _loginDelegate;

#pragma mark - Private methods

- (void)networkActivityIndicatorIsVisible:(BOOL)isVisible {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:isVisible];
}
- (NSString *)distinguishAuthCodeFromQuery:(NSString *)query {
    NSString *authCode = nil;
    
    NSArray *queryParts = [query componentsSeparatedByString:@"="];
    if ( (queryParts.count == 2) && ([[queryParts objectAtIndex:0] isEqualToString:@"code"]) ) {
        authCode = queryParts.lastObject;
    }
    
    return authCode;
}

#pragma mark - Public interface

#pragma mark - Properties

- (void)setLoginUrl:(NSURLRequest *)loginUrl {
    _loginUrl = loginUrl;
    [self.webView loadRequest:loginUrl];
}

#pragma mark - UIWebView delegate

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self networkActivityIndicatorIsVisible:NO];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self networkActivityIndicatorIsVisible:NO];
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    BOOL isRedirectUriFound = [request.URL.absoluteString hasPrefix:YTRedirectURI];
    if (isRedirectUriFound) {
        NSString *authCode = [self distinguishAuthCodeFromQuery:request.URL.query];
        [self.loginDelegate didReceiveAuthCode:(NSString *)authCode];
    }
    
    [self networkActivityIndicatorIsVisible:!isRedirectUriFound];
    
    return !isRedirectUriFound;
}

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.webView loadRequest:self.loginUrl];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
