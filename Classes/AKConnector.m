//
//  AKYouTube.m
//  AKYouTube
//
//  Created by Anton Pomozov on 10.09.13.
//  Copyright (c) 2013 Akademon Ltd. All rights reserved.
//

#import "AKConnector.h"
#import "AKYouTubeConstants.h"
#import "AKDefaultLoginViewController.h"

#import "NSData+AKRest.h"

@interface AKConnector()

@property (nonatomic, copy) NSString *clientId;
@property (nonatomic, copy) NSString *clientSecret;
@property (nonatomic, copy) NSString *scopesList;
@property (nonatomic, copy) NSString *expiresIn;
@property (nonatomic, copy) NSString *tokenType;
@property (nonatomic, copy) NSString *refreshToken;
@property (nonatomic, copy) NSString *accessToken;

@property (nonatomic, strong) NSDate *expireDateUTC;
@property (nonatomic, strong) UIViewController<AKLoginViewControllerInterface> *loginController;

@end

@implementation AKConnector

@synthesize loginController = _loginController;

#pragma mark - Private methods

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
- (NSString *)makeScopesList:(NSArray *)scopesArray {
    NSString *scopesList = @"";
    
    if ([scopesArray indexOfObject:YTMandatoryScope] == NSNotFound) {
        scopesList = [scopesList stringByAppendingFormat:@"%@%@", YTScopesPrefix, YTMandatoryScope];
    }

    for (NSString *scope in scopesArray) {
        scopesList = [scopesList stringByAppendingFormat:@" %@%@", YTScopesPrefix, scope];
    }
    
    return scopesList;
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
- (void)renewAccessTokenWithRefreshToken:(NSString *)refreshToken {
    
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
- (void)refreshAccessTokenWithRefreshToken:(NSString *)refreshToken {
    if (refreshToken) {
        NSDictionary *queryData = @{
                                    @"client_id"     : self.clientId,
                                    @"client_secret" : self.clientSecret,
                                    @"refresh_token" : refreshToken,
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
    }
}

#pragma mark - Public interface

+ (AKConnector *)sharedInstance {
    static dispatch_once_t once;
    static AKConnector *sharedInstance = nil;
    dispatch_once(&once, ^{
        sharedInstance = [[AKConnector alloc] init];
    });
    
    return sharedInstance;
}

- (void)useCustomLoginViewController:(UIViewController *)loginViewController {
    if ([loginViewController conformsToProtocol:@protocol(AKLoginViewControllerInterface)]) {
        self.loginController = (UIViewController<AKLoginViewControllerInterface> *)loginViewController;
    }
}
- (void)connectWithClientId:(NSString *)clientId
               clientSecret:(NSString *)clientSecret
                 scopesList:(NSString *)scopesList
               refreshToken:(NSString *)refreshToken {

    self.clientId     = clientId;
    self.clientSecret = clientSecret;
    self.scopesList   = scopesList;
    
    if (refreshToken) {
        self.refreshToken = refreshToken;
    } else {
        BOOL shouldPresentDefaultLoginVC = [self.delegate shouldPresentThisLoginViewController:self.loginController];
        if (shouldPresentDefaultLoginVC) {
            self.loginController.loginUrl = [self makeLoginURLRequest];
        }
    }
}

#pragma mark - Properties

- (UIViewController<AKLoginViewControllerInterface> *)loginController {
    if (!_loginController) {
        _loginController = [[AKDefaultLoginViewController alloc] init];
        _loginController.loginDelegate = self;
    }
    
    return _loginController;
}
- (void)setLoginController:(UIViewController<AKLoginViewControllerInterface> *)loginController {
    [_loginController dismissViewControllerAnimated:YES completion:NULL];
    
    _loginController = loginController;
    _loginController.loginDelegate = self;
    _loginController.loginUrl = [self makeLoginURLRequest];
}
- (void)setRefreshToken:(NSString *)refreshToken {
    BOOL isNewRefreshTokenEmpty = refreshToken == nil;
    BOOL isOldRefreshTokenEmpty = _refreshToken == nil;
    BOOL areRefreshTokensSame = _refreshToken == refreshToken;
    
    _refreshToken = refreshToken;
    
    // Update access token and say to delegate about refresh token update
    if (!isNewRefreshTokenEmpty && !isOldRefreshTokenEmpty && !areRefreshTokensSame) {
        [self refreshAccessTokenWithRefreshToken:refreshToken];
        [self.delegate didUpdateRefreshToken:refreshToken];
    }
}
- (void)setExpiresIn:(NSString *)expiresIn {
    _expiresIn = expiresIn;
    
    NSTimeInterval secondsToExpire = [expiresIn floatValue] - YTTimeoutSeconds;
    
    self.expireDateUTC = [[NSDate date] dateByAddingTimeInterval:secondsToExpire];
}
- (void)setAccessToken:(NSString *)accessToken {
    _accessToken = accessToken;
    
    if (accessToken) {
        [self.delegate didUpdateAccessToken];
    }
}

#pragma mark - AKLogin delegate 

- (void)didReceiveAuthCode:(NSString *)authCode {
    [self exchangeAuthCodeForAccessAndRefreshTokens:authCode];
}

@end
