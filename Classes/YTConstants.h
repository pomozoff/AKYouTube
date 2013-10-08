//
//  YTConstants.h
//  AKYouTube
//
//  Created by Anton Pomozov on 10.09.13.
//  Copyright (c) 2013 Akademon Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const YTGrantTypeAuthCode     = @"authorization_code";
static NSString *const YTGrantTypeRefreshToken = @"refresh_token";

static NSString *const YTGoogleOAuthURL = @"https://accounts.google.com/o/oauth2/auth";
static NSString *const YTGoogleTokenURL = @"https://accounts.google.com/o/oauth2/token";
static NSString *const YTRedirectURI    = @"http://localhost/oauth2callback";

static NSString *const YTScopesPrefix = @"https://www.googleapis.com/auth/";
static NSString *const YTMandatoryScope = @"youtube";

static NSString *const YTAPIListChannelsURL  = @"https://www.googleapis.com/youtube/v3/channels";
static NSString *const YTAPIListPlaylistsURL = @"https://www.googleapis.com/youtube/v3/playlists";

static NSString *const YTDefaultsRefreshToken = @"ru.akademon.YTConnector.Defaults.RefreshToken";

static NSInteger const YTHttpResponseStatusOK = 200;
static NSUInteger const YTTimeoutSeconds = 30;

static NSUInteger const YTWebViewHorizontalMargin = 30;
static NSUInteger const YTWebViewVerticalMargin   = 44;

typedef enum {
    REST_METHOD_POST,
    REST_METHOD_GET
} RestMethod;
