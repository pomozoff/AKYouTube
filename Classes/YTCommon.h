//
//  YTCommon.h
//  AKYouTubeExample
//
//  Created by Anton Pomozov on 14.10.13.
//  Copyright (c) 2013 Akademon Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const YTGrantTypeAuthCode     = @"authorization_code";
static NSString *const YTGrantTypeRefreshToken = @"refresh_token";

static NSString *const YTGoogleOAuthURL    = @"https://accounts.google.com/o/oauth2/auth";
static NSString *const YTGoogleTokenURL    = @"https://accounts.google.com/o/oauth2/token";
static NSString *const YTGoogleUserInfoURL = @"https://www.googleapis.com/oauth2/v1/userinfo?alt=json";

static NSString *const YTScopeYouTubeAccess   = @"https://www.googleapis.com/auth/youtube";
static NSString *const YTScopeYouTubeReadOnly = @"https://www.googleapis.com/auth/youtube.readonly";
static NSString *const YTScopeUserInfoProfile = @"https://www.googleapis.com/auth/userinfo.profile";
static NSString *const YTScopeUserInfoEmail   = @"https://www.googleapis.com/auth/userinfo.email";

static NSString *const YTRedirectURI    = @"http://localhost/oauth2callback";

static NSString *const YTAPIListChannelsURL  = @"https://www.googleapis.com/youtube/v3/channels";
static NSString *const YTAPIListPlaylistsURL = @"https://www.googleapis.com/youtube/v3/playlists";

static NSString *const YTDefaultsRefreshToken = @"ru.akademon.YTConnector.Defaults.RefreshToken";

static NSInteger const YTHttpResponseStatusOK = 200;
static NSUInteger const YTTimeoutSeconds = 30;
static NSInteger const YTMaxItemsFetch = 50;

static NSUInteger const YTWebViewHorizontalMargin = 30;
static NSUInteger const YTWebViewVerticalMargin   = 44;

typedef enum {
    REST_METHOD_POST,
    REST_METHOD_GET
} RestMethod;

@interface YTCommon : NSObject

+ (NSString *)makeOptionsListFromOptions:(NSDictionary *)options;
+ (NSDictionary *)jsonAnswerForRequestMethod:(RestMethod)method
                               withUrlString:(NSString *)urlString
                              withParameters:(NSDictionary *)parameters
                                  responseIs:(NSHTTPURLResponse **)response
                                     errorIs:(NSError **)error;

@end
