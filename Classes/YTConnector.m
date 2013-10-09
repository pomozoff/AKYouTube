//
//  YTConnector.m
//  AKYouTube
//
//  Created by Anton Pomozov on 10.09.13.
//  Copyright (c) 2013 Akademon Ltd. All rights reserved.
//

#import "YTConnector.h"
#import "YTConstants.h"
#import "YTLoginViewController.h"

#import "NSData+AKRest.h"

@interface YTConnector() <UIWebViewDelegate>

@property (nonatomic, copy) NSString *clientId;
@property (nonatomic, copy) NSString *clientSecret;
@property (nonatomic, copy) NSString *scopesList;
@property (nonatomic, copy) NSString *expiresIn;
@property (nonatomic, copy) NSString *tokenType;
@property (nonatomic, copy) NSString *refreshToken;
@property (nonatomic, copy) NSString *accessToken;

@property (nonatomic, strong) NSDate *expireDateUTC;
@property (nonatomic, strong) UIViewController<YTLoginViewControllerInterface> *loginController;

@end

@implementation YTConnector

#pragma mark - Synthesize

@synthesize loginController = _loginController;
@synthesize refreshToken = _refreshToken;

#pragma mark - Private methods

- (void)networkActivityIndicatorIsVisible:(BOOL)isVisible {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:isVisible];
}
- (void)scaleLoadedPageToWidth {
    CGSize contentSize = self.loginController.webView.scrollView.contentSize;
    CGSize viewSize = self.loginController.webView.bounds.size;
    
    float rw = viewSize.width / contentSize.width;
    
    self.loginController.webView.scrollView.minimumZoomScale = rw;
    self.loginController.webView.scrollView.maximumZoomScale = rw;
    self.loginController.webView.scrollView.zoomScale = rw;
}
- (void)setupLoginController:(UIViewController<YTLoginViewControllerInterface> *)loginController {
    loginController.webView.delegate = self;
    [loginController.webView loadRequest:[self makeLoginURLRequest]];
}
- (NSURLRequest *)makeLoginURLRequest {
    NSString *stringUrl = [NSString stringWithFormat:@"%@?" \
                           "client_id=%@&" \
                           "redirect_uri=%@&" \
                           "scope=%@&" \
                           "response_type=code&" \
                           "access_type=offline",
                           YTGoogleOAuthURL, self.clientId, YTRedirectURI, self.scopesList];
    NSURL *url = [NSURL URLWithString:[stringUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    return request;
}
- (NSString *)distinguishAuthCodeFromQuery:(NSString *)query {
    NSString *authCode = nil;
    
    NSArray *queryParts = [query componentsSeparatedByString:@"="];
    if ( (queryParts.count == 2) && ([[queryParts objectAtIndex:0] isEqualToString:@"code"]) ) {
        authCode = queryParts.lastObject;
    }
    
    return authCode;
}
- (BOOL)isAccessTokenExpired {
    BOOL isExpired;
    
    if (self.expireDateUTC) {
        NSDate *currentDateUTC = [NSDate date];
        isExpired = [currentDateUTC compare:self.expireDateUTC] != NSOrderedAscending;
    } else {
        isExpired = YES;
    }
    
    return isExpired;
}

- (NSDictionary *)jsonAnswerForRequestMethod:(RestMethod)method
                               withUrlString:(NSString *)urlString
                              withParameters:(NSDictionary *)parameters
                                  responseIs:(NSHTTPURLResponse **)response
                                     errorIs:(NSError **)error {
    NSString *methodString;
    switch (method) {
        case REST_METHOD_GET:
            methodString = @"GET";
            break;
        case REST_METHOD_POST:
            methodString = @"POST";
            break;
            
        default:
            break;
    }
    
    NSData *data = [NSData dataUseMethod:methodString
                           withStringUrl:urlString
                          withParameters:parameters
                            httpResponse:response
                                   error:error];
    
    NSDictionary *jsonAnswer;
    if ( !(*error) ) {
        jsonAnswer = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:error];
        
        //        NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        //        NSLog(@"Response is:\n%@", jsonString);
    }
    
    return jsonAnswer;
}
- (void)exchangeAuthCodeForAccessAndRefreshTokens:(NSString *)authCode {
    NSDictionary *queryData = @{
                                @"code"          : authCode,
                                @"client_id"     : self.clientId,
                                @"client_secret" : self.clientSecret,
                                @"redirect_uri"  : YTRedirectURI,
                                @"grant_type"    : YTGrantTypeAuthCode
                                };
    
	NSHTTPURLResponse *response;
    NSError *error = nil;
    
    NSDictionary *jsonAnswer = [self jsonAnswerForRequestMethod:REST_METHOD_POST
                                                  withUrlString:YTGoogleTokenURL
                                                 withParameters:queryData
                                                     responseIs:&response
                                                        errorIs:&error];
    
    if (!error) {
        if ( YTHttpResponseStatusOK == response.statusCode ) {
            self.expiresIn    = jsonAnswer[@"expires_in"];
            self.tokenType    = jsonAnswer[@"token_type"];
            self.refreshToken = jsonAnswer[@"refresh_token"];
            self.accessToken  = jsonAnswer[@"access_token"];
        }
    }
}
- (void)refreshAccessTokenWithCompletion:(void (^)(NSError *))completion {
    if (self.refreshToken) {
        NSDictionary *queryData = @{
                                    @"client_id"     : self.clientId,
                                    @"client_secret" : self.clientSecret,
                                    @"refresh_token" : self.refreshToken,
                                    @"grant_type"    : YTGrantTypeRefreshToken
                                    };
        
        NSHTTPURLResponse *response;
        NSError *error = nil;
        
        NSDictionary *jsonAnswer = [self jsonAnswerForRequestMethod:REST_METHOD_POST
                                                      withUrlString:YTGoogleTokenURL
                                                     withParameters:queryData
                                                         responseIs:&response
                                                            errorIs:&error];
        
        if (!error) {
            if ( YTHttpResponseStatusOK == response.statusCode ) {
                self.expiresIn   = jsonAnswer[@"expires_in"];
                self.tokenType   = jsonAnswer[@"token_type"];
                self.accessToken = jsonAnswer[@"access_token"];
            }
        }
        
        completion(error);
    }
}

#pragma mark - Public interface

+ (YTConnector *)sharedInstance {
    static dispatch_once_t once;
    static YTConnector *sharedInstance = nil;
    dispatch_once(&once, ^{
        sharedInstance = [[YTConnector alloc] init];
    });
    
    return sharedInstance;
}
- (void)connectWithClientId:(NSString *)clientId andClientSecret:(NSString *)clientSecret {
    self.clientId     = clientId;
    self.clientSecret = clientSecret;
    
    if (self.refreshToken) {
        dispatch_queue_t connectQueue = dispatch_queue_create("YouTube connect queue", NULL);
        dispatch_async(connectQueue, ^{
            [self refreshAccessTokenWithCompletion:^(NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (error) {
                        [self.delegate connectionDidFailWithError:error];
                    } else {
                        [self.delegate connectionEstablished];
                    }
                });
            }];
        });
    } else {
        [self.delegate appDidFailAuthorize];
    }
}
- (void)authorizeAppWithScopesList:(NSString *)scopesList
             inLoginViewController:(UIViewController<YTLoginViewControllerInterface> *)loginViewController {
    self.scopesList = scopesList;
    self.loginController = loginViewController;
    [self.delegate presentLoginViewControler:self.loginController];
}

#pragma mark - Properties

- (UIViewController<YTLoginViewControllerInterface> *)loginController {
    if (!_loginController) {
        _loginController = [[YTLoginViewController alloc] init];
        [self setupLoginController:_loginController];
    }
    
    return _loginController;
}
- (void)setLoginController:(UIViewController<YTLoginViewControllerInterface> *)loginController {
    [_loginController dismissViewControllerAnimated:YES completion:NULL];
    
    _loginController = loginController;
    [self setupLoginController:_loginController];
}
- (NSString *)refreshToken {
    if (!_refreshToken) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults synchronize];
        
        _refreshToken = [defaults objectForKey:YTDefaultsRefreshToken];
    }
    
    return _refreshToken;
}
- (void)setRefreshToken:(NSString *)refreshToken {
    _refreshToken = refreshToken;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:refreshToken forKey:YTDefaultsRefreshToken];
    [defaults synchronize];
}
- (void)setExpiresIn:(NSString *)expiresIn {
    _expiresIn = expiresIn;
    
    NSTimeInterval secondsToExpire = [expiresIn floatValue] - YTTimeoutSeconds;
    
    self.expireDateUTC = [[NSDate date] dateByAddingTimeInterval:secondsToExpire];
}
- (NSString *)scopesList {
    if (!_scopesList) {
        _scopesList = @"https://www.googleapis.com/auth/youtube.readonly";
    }
    
    return _scopesList;
}

#pragma mark - UIWebView delegate

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self networkActivityIndicatorIsVisible:NO];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self scaleLoadedPageToWidth];
    [self networkActivityIndicatorIsVisible:NO];
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    BOOL isRedirectUriFound = [request.URL.absoluteString hasPrefix:YTRedirectURI];
    if (isRedirectUriFound) {
        NSString *authCode = [self distinguishAuthCodeFromQuery:request.URL.query];
        [self exchangeAuthCodeForAccessAndRefreshTokens:authCode];
    }
    
    [self networkActivityIndicatorIsVisible:!isRedirectUriFound];
    
    return !isRedirectUriFound;
}

@end
