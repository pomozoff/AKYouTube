//
//  YTFetcher.m
//  AKYouTubeExample
//
//  Created by Anton Pomozov on 14.10.13.
//  Copyright (c) 2013 Akademon Ltd. All rights reserved.
//

#import "YTFetcher.h"
#import "YTCommon.h"
#import "YTConnector.h"

static NSString *const YTOptionsKeyMine = @"mine";
static NSString *const YTOptionsKeyPart = @"part";
static NSString *const YTOptionsKeyMaxResults = @"maxResults";

@implementation YTFetcher

#pragma mark - Private methods

+ (NSString *)textOfPlaylistPart:(YTRequestPlaylistPart)part {
    NSString *partText;
    switch (part) {
        case REQUEST_PLAYLIST_PART_ID:
            partText = @"id";
            break;
        case REQUEST_PLAYLIST_PART_SNIPPET:
            partText = @"snippet";
            break;
        case REQUEST_PLAYLIST_PART_STATUS:
            partText = @"status";
            break;
            
        default:
            break;
    }
    
    return partText;
}

+ (NSString *)textOfChannelPart:(YTRequestChannelPart)part {
    NSString *partText;
    switch (part) {
        case REQUEST_CHANNEL_PART_ID:
            partText = @"id";
            break;
        case REQUEST_CHANNEL_PART_SNIPPET:
            partText = @"snippet";
            break;
        case REQUEST_CHANNEL_PART_AUDIT_DETAILS:
            partText = @"auditDetails";
            break;
        case REQUEST_CHANNEL_PART_BRANDING_SETTINGS:
            partText = @"brandingSettings";
            break;
        case REQUEST_CHANNEL_PART_CONTENT_DETAILS:
            partText = @"contentDetails";
            break;
        case REQUEST_CHANNEL_PART_INVIDEO_PROMOTION:
            partText = @"invideoPromotion";
            break;
        case REQUEST_CHANNEL_PART_STATISTICS:
            partText = @"statistics";
            break;
        case REQUEST_CHANNEL_PART_TOPIC_DETAILS:
            partText = @"topicDetails";
            break;
            
        default:
            break;
    }
    
    return partText;
}
+ (void)addPartText:(NSString *)partText toOptionsList:(NSMutableDictionary *)options {
    if (partText) {
        [options setObject:partText forKey:YTOptionsKeyPart];
    }
}
+ (NSString *)makeUrlForTemplate:(NSString *)template withOptions:(NSDictionary *)options {
    NSDictionary *resultOptions;
    if ([options objectForKey:YTOptionsKeyMine]) {
        resultOptions = options;
    } else {
        NSMutableDictionary *mutableOptions = [options mutableCopy];
        [mutableOptions addEntriesFromDictionary:@{YTOptionsKeyMine : @"true"}];
        
        resultOptions = mutableOptions;
    }
    
    NSString *optionsList = [YTCommon makeOptionsListFromOptions:resultOptions];
    NSString *url = [NSString stringWithFormat:@"%@?%@", template, optionsList];
    
    NSString *accessToken = YTConnector.sharedInstance.accessToken;
    NSString *urlWithToken = [url stringByAppendingString:[NSString stringWithFormat:@"&access_token=%@", accessToken]];
    
    return urlWithToken;
}
+ (NSDictionary *)fetchPlaylistsWithOptions:(NSDictionary *)options errorIs:(NSError **)error {
    NSString *urlWithToken = [self makeUrlForTemplate:YTAPIListPlaylistsURL withOptions:options];
    NSHTTPURLResponse *response;
    NSDictionary *jsonAnswer = [YTCommon jsonAnswerForRequestMethod:REST_METHOD_GET
                                                                withUrlString:urlWithToken
                                                               withParameters:nil
                                                                   responseIs:&response
                                                                      errorIs:error];
    
    return jsonAnswer;
}
+ (NSDictionary *)fetchChannelsWithOptions:(NSDictionary *)options errorIs:(NSError **)error {
    NSString *urlWithToken = [self makeUrlForTemplate:YTAPIListChannelsURL withOptions:options];
    NSHTTPURLResponse *response;
    NSDictionary *jsonAnswer = [YTCommon jsonAnswerForRequestMethod:REST_METHOD_GET
                                                                withUrlString:urlWithToken
                                                               withParameters:nil
                                                                   responseIs:&response
                                                                      errorIs:error];
    
    return jsonAnswer;
}

#pragma mark - Public interface

+ (void)getUserInfoCompletion:(void(^)(NSDictionary *, NSError *))completion {
    NSString *accessToken = YTConnector.sharedInstance.accessToken;
    NSString *urlString = [NSString stringWithFormat:@"%@&access_token=%@",
                           YTGoogleUserInfoURL, accessToken];
    dispatch_queue_t connectQueue = dispatch_queue_create("YouTube get user info as JSON", NULL);
    dispatch_async(connectQueue, ^{
        NSHTTPURLResponse *response;
        NSError *error = nil;
        NSDictionary *jsonAnswer = [YTCommon jsonAnswerForRequestMethod:REST_METHOD_GET
                                                          withUrlString:urlString
                                                         withParameters:nil
                                                             responseIs:&response
                                                                errorIs:&error];
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(jsonAnswer, error);
        });
    });
}

+ (void)fetchPlaylistsJsonWithOptions:(NSDictionary *)options completion:(void (^)(NSDictionary *, NSError *))completion {
    dispatch_queue_t connectQueue = dispatch_queue_create("YouTube fetch playlists as JSON", NULL);
    dispatch_async(connectQueue, ^{
        NSError *error = nil;
        NSDictionary *jsonAnswer = [self fetchPlaylistsWithOptions:options errorIs:&error];
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(jsonAnswer, error);
        });
    });
}
+ (void)fetchMinePlaylistsJsonWithPart:(YTRequestPlaylistPart)part completion:(void (^)(NSDictionary *, NSError *))completion {
    NSMutableDictionary *options = [NSMutableDictionary dictionary];
    NSString *partText = [self textOfPlaylistPart:part];
    [self addPartText:partText toOptionsList:options];
    
    [self fetchPlaylistsJsonWithOptions:options completion:completion];
}
+ (void)fetchMinePlaylistsJsonNumber:(NSUInteger)count withPart:(YTRequestPlaylistPart)part completion:(void (^)(NSDictionary *, NSError *))completion {
    NSMutableDictionary *options = [NSMutableDictionary dictionary];
    [options setObject:[NSNumber numberWithInteger:count] forKey:YTOptionsKeyMaxResults];

    NSString *partText = [self textOfPlaylistPart:part];
    [self addPartText:partText toOptionsList:options];
    
    [self fetchPlaylistsJsonWithOptions:options completion:completion];
}

+ (void)fetchChannelsJsonWithOptions:(NSDictionary *)options completion:(void (^)(NSDictionary *, NSError *))completion {
    dispatch_queue_t connectQueue = dispatch_queue_create("YouTube fetch channels as JSON", NULL);
    dispatch_async(connectQueue, ^{
        NSError *error = nil;
        NSDictionary *jsonAnswer = [self fetchChannelsWithOptions:options errorIs:&error];
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(jsonAnswer, error);
        });
    });
}
+ (void)fetchMineChannelsJsonWithPart:(YTRequestChannelPart)part completion:(void (^)(NSDictionary *, NSError *))completion {
    NSMutableDictionary *options = [NSMutableDictionary dictionary];
    NSString *partText = [self textOfChannelPart:part];
    [self addPartText:partText toOptionsList:options];
    
    [self fetchChannelsJsonWithOptions:options completion:completion];
}
+ (void)fetchMineChannelsJsonNumber:(NSUInteger)count withPart:(YTRequestChannelPart)part completion:(void (^)(NSDictionary *, NSError *))completion {
    NSMutableDictionary *options = [NSMutableDictionary dictionary];
    [options setObject:[NSNumber numberWithInteger:count] forKey:YTOptionsKeyMaxResults];

    NSString *partText = [self textOfChannelPart:part];
    [self addPartText:partText toOptionsList:options];
    
    [self fetchChannelsJsonWithOptions:options completion:completion];
}

+ (void)fetchItemsOfPlaylist:(NSString *)playlistId withPart:(YTPlaylistItemsPart)part completion:(void (^)(NSDictionary *, NSError *))completion {
    
}

@end
