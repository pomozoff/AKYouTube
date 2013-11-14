//
//  YTConnector.m
//  AKYouTube
//
//  Created by Anton Pomozov on 10.09.13.
//  Copyright (c) 2013 Akademon Ltd. All rights reserved.
//

#import "YTConnector.h"
#import "YTCommon.h"
#import "YTLoginViewController.h"

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

#pragma mark - block

void(^connectCompletionBlock)(YTConnector *selfWeak, NSError *error) = ^void(YTConnector *selfWeak, NSError *error) {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (error) {
            if ([selfWeak.delegate respondsToSelector:@selector(connectionDidFailWithError:)]) {
                [selfWeak.delegate connectionDidFailWithError:error];
            }
        } else {
            if ([selfWeak.delegate respondsToSelector:@selector(connectionEstablished)]) {
                [selfWeak.delegate connectionEstablished];
            }
        }
    });
};

#pragma mark - Synthesize

@synthesize loginController = _loginController;
@synthesize refreshToken = _refreshToken;

#pragma mark - Private methods - Others

- (void)networkActivityIndicatorIsVisible:(BOOL)isVisible {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:isVisible];
}
- (void)scaleLoadedPageToWidth {
    // Fix Google's storm in the minds
    // <meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1, user-scalable=0" />
    
    CGFloat scale = self.loginController.webView.frame.size.width / UIScreen.mainScreen.applicationFrame.size.width;
    if (scale != 1.0f) {
        NSString *makeScalableJS = @"var all_metas = document.getElementsByTagName('meta');\
        if (all_metas){\
            var k;\
            for (k = 0; k < all_metas.length; k++) {\
                var meta_tag = all_metas[k];\
                var viewport = meta_tag.getAttribute('name');\
                if (viewport && viewport == 'viewport') {\
                    meta_tag.setAttribute('content','width=device-width; initial-scale=%.2f; maximum-scale=1.0; user-scalable=1;');\
                }\
            }\
        }";
        
        NSString *formattedString = [NSString stringWithFormat:makeScalableJS, scale];
        [self.loginController.webView stringByEvaluatingJavaScriptFromString:formattedString];
    }
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
- (void)setupLoginController:(UIViewController<YTLoginViewControllerInterface> *)loginController {
    loginController.webView.delegate = self;
    [loginController.webView loadRequest:[self makeLoginURLRequest]];
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

#pragma mark - Private methods - App auth

- (void)exchangeAuthCodeForAccessAndRefreshTokens:(NSString *)authCode withCompletion:(void (^)(NSError *))completion {
    NSDictionary *queryData = @{
                                @"code"          : authCode,
                                @"client_id"     : self.clientId,
                                @"client_secret" : self.clientSecret,
                                @"redirect_uri"  : YTRedirectURI,
                                @"grant_type"    : YTGrantTypeAuthCode
                                };
    
	NSHTTPURLResponse *response;
    NSError *error = nil;
    
    NSDictionary *jsonAnswer = [YTCommon jsonAnswerForRequestMethod:REST_METHOD_POST
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

    completion(error);
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
        
        NSDictionary *jsonAnswer = [YTCommon jsonAnswerForRequestMethod:REST_METHOD_POST
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

+ (instancetype)sharedInstance {
    static dispatch_once_t once;
    static id _sharedInstance = nil;
    dispatch_once(&once, ^{
        _sharedInstance = [[self alloc] init];
    });
    
    return _sharedInstance;
}
- (void)connectWithClientId:(NSString *)clientId andClientSecret:(NSString *)clientSecret {
    self.clientId     = clientId;
    self.clientSecret = clientSecret;
    
    if (self.refreshToken) {
        dispatch_queue_t connectQueue = dispatch_queue_create("YouTube refresh access token queue", NULL);
        dispatch_async(connectQueue, ^{
            [self refreshAccessTokenWithCompletion:^(NSError *error) {
                __weak YTConnector *selfWeak = self;
                connectCompletionBlock(selfWeak, error);
            }];
        });
    } else {
        if ([self.delegate respondsToSelector:@selector(appDidFailAuthorize)]) {
            [self.delegate appDidFailAuthorize];
        }
    }
}
- (void)authorizeAppWithScopesList:(NSString *)scopesList
             inLoginViewController:(UIViewController<YTLoginViewControllerInterface> *)loginViewController {
    self.scopesList = scopesList;
    self.loginController = loginViewController;
    
    if ([self.delegate respondsToSelector:@selector(presentLoginViewControler:)]) {
        [self.delegate presentLoginViewControler:self.loginController];
    }
}
- (void)freeLoginViewController {
    self.loginController = nil;
    NSLog(@"Login controller freed ...");
}
- (void)getUserInfoWithBlockCompletion:(void(^)(NSDictionary *))completionBlock {
    if (self.accessToken) {
        NSString *urlString = [NSString stringWithFormat:@"%@&access_token=%@",
                               YTGoogleUserInfoURL, self.accessToken];
        NSHTTPURLResponse *response;
        NSError *error = nil;
        
        NSDictionary *jsonAnswer = [YTCommon jsonAnswerForRequestMethod:REST_METHOD_GET
                                                      withUrlString:urlString
                                                     withParameters:nil
                                                         responseIs:&response
                                                            errorIs:&error];
        
        if (!error) {
            if ( YTHttpResponseStatusOK == response.statusCode ) {
                completionBlock(jsonAnswer);
            }
        }
    }
}

#pragma mark - Properties

- (UIViewController<YTLoginViewControllerInterface> *)loginController {
    if (!_loginController) {
        _loginController = [[YTLoginViewController alloc] init];
        _loginController.connector = self;
        [self setupLoginController:_loginController];
    }
    
    return _loginController;
}
- (void)setLoginController:(UIViewController<YTLoginViewControllerInterface> *)loginController {
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
        _scopesList = [NSString stringWithFormat:@"%@/%@", YTScopeURL, YTScopeYouTubeReadOnly];
    }
    
    return _scopesList;
}

#pragma mark - UIWebView delegate

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self networkActivityIndicatorIsVisible:NO];
    NSLog(@"Failed load request: %@", error);
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self scaleLoadedPageToWidth];
    [self networkActivityIndicatorIsVisible:NO];
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    BOOL isRedirectUriFound = [request.URL.absoluteString hasPrefix:YTRedirectURI];
    if (isRedirectUriFound) {
        NSString *authCode = [self distinguishAuthCodeFromQuery:request.URL.query];
        if (authCode) {
            dispatch_queue_t connectQueue = dispatch_queue_create("YouTube exchange auth code queue", NULL);
            dispatch_async(connectQueue, ^{
                [self exchangeAuthCodeForAccessAndRefreshTokens:authCode withCompletion:^(NSError *error) {
                    __weak YTConnector *selfWeak = self;
                    connectCompletionBlock(selfWeak, error);
                }];
            });
        } else if ([self.delegate respondsToSelector:@selector(userRejectedApp)]) {
            [self.delegate userRejectedApp];
        }
    }
    
    [self networkActivityIndicatorIsVisible:!isRedirectUriFound];
    
    return !isRedirectUriFound;
}

@end
