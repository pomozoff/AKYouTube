//
//  YTCommon.h
//  AKYouTubeExample
//
//  Created by Anton Pomozov on 14.10.13.
//  Copyright (c) 2013 Akademon Ltd. All rights reserved.
//

@import Foundation;

static NSString * const YTGrantTypeAuthCode     = @"authorization_code";
static NSString * const YTGrantTypeRefreshToken = @"refresh_token";

static NSString * const YTGoogleOAuthURL    = @"https://accounts.google.com/o/oauth2/auth";
static NSString * const YTGoogleTokenURL    = @"https://accounts.google.com/o/oauth2/token";
static NSString * const YTGoogleUserInfoURL = @"https://www.googleapis.com/oauth2/v1/userinfo?alt=json";

static NSString * const YTScopeYouTubeAccess   = @"https://www.googleapis.com/auth/youtube";
static NSString * const YTScopeYouTubeReadOnly = @"https://www.googleapis.com/auth/youtube.readonly";
static NSString * const YTScopeUserInfoProfile = @"https://www.googleapis.com/auth/userinfo.profile";
static NSString * const YTScopeUserInfoEmail   = @"https://www.googleapis.com/auth/userinfo.email";

static NSString * const YTRedirectURI = @"http://localhost/oauth2callback";

static NSString * const YTAPIPlaylistsListURL     = @"https://www.googleapis.com/youtube/v3/playlists";
static NSString * const YTAPIChannelsListURL      = @"https://www.googleapis.com/youtube/v3/channels";
static NSString * const YTAPIPlaylistItemsListURL = @"https://www.googleapis.com/youtube/v3/playlistItems";
static NSString * const YTAPIVideosListURL        = @"https://www.googleapis.com/youtube/v3/videos";

static NSString * const YTDefaultsRefreshToken = @"ru.akademon.YTConnector.Defaults.RefreshToken";

static NSString * const YTQueueRefreshAccessToken = @"ru.akademon.YTConnector.Queue.RefreshAccessToken";
static NSString * const YTQueueExchangeAuthCode   = @"ru.akademon.YTConnector.Queue.ExchangeAuthCode";
static NSString * const YTQueueGetUserInfo        = @"ru.akademon.YTConnector.Queue.GetUserInfo";

static NSString * const YTQueueFetchPlaylistsList     = @"ru.akademon.YTConnector.Queue.FetchPlaylistsList";
static NSString * const YTQueueFetchChannelsList      = @"ru.akademon.YTConnector.Queue.FetchChannelsList";
static NSString * const YTQueueFetchPlaylistItemsList = @"ru.akademon.YTConnector.Queue.FetchPlaylistItemsList";
static NSString * const YTQueueFetchVideosList        = @"ru.akademon.YTConnector.Queue.FetchVideosList";

static NSInteger  const YTHttpResponseStatusOK = 200;
static NSUInteger const YTTimeoutSeconds = 30;
static NSInteger  const YTMaxItemsFetch = 50;

static NSUInteger const YTWebViewHorizontalMargin = 30;
static NSUInteger const YTWebViewVerticalMargin   = 44;

typedef NS_ENUM(NSInteger, YTRestMethod) {
    YT_REST_METHOD_POST,
    YT_REST_METHOD_GET
};

@interface YTCommon : NSObject

+ (NSString *)makeOptionsListFromOptions:(NSDictionary *)options;
+ (NSData *)dataAnswerForRequestMethod:(YTRestMethod)method
                         withUrlString:(NSString *)urlString
                        withParameters:(NSDictionary *)parameters
                              response:(NSHTTPURLResponse **)response
                                 error:(NSError **)error;
+ (NSDictionary *)jsonAnswerForRequestMethod:(YTRestMethod)method
                               withUrlString:(NSString *)urlString
                              withParameters:(NSDictionary *)parameters
                                    response:(NSHTTPURLResponse **)response
                                       error:(NSError **)error;

@end
