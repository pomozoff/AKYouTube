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

static NSString * const YTOptionsKeyMine       = @"mine";
static NSString * const YTOptionsKeyPart       = @"part";
static NSString * const YTOptionsKeyMaxResults = @"maxResults";
static NSString * const YTOptionsKeyPlaylistId = @"playlistId";
static NSString * const YTOptionsKeyId         = @"id";

static NSUInteger const YTOptionsValueMaxResults = 50;

@implementation YTFetcher

#pragma mark - Private methods

+ (NSString *)textOfPartForPlaylistsList:(YTRequestPlaylistsList)part {
    NSString *partText;
    switch (part) {
        case YT_REQUEST_PLAYLISTS_LIST_ID:
            partText = @"id";
            break;
        case YT_REQUEST_PLAYLISTS_LIST_SNIPPET:
            partText = @"snippet";
            break;
        case YT_REQUEST_PLAYLISTS_LIST_STATUS:
            partText = @"status";
            break;
            
        default:
            break;
    }
    
    return partText;
}
+ (NSString *)textOfPartForChannelsList:(YTRequestChannelsList)part {
    NSString *partText;
    switch (part) {
        case YT_REQUEST_CHANNELS_LIST_ID:
            partText = @"id";
            break;
        case YT_REQUEST_CHANNELS_LIST_SNIPPET:
            partText = @"snippet";
            break;
        case YT_REQUEST_CHANNELS_LIST_AUDIT_DETAILS:
            partText = @"auditDetails";
            break;
        case YT_REQUEST_CHANNELS_LIST_BRANDING_SETTINGS:
            partText = @"brandingSettings";
            break;
        case YT_REQUEST_CHANNELS_LIST_CONTENT_DETAILS:
            partText = @"contentDetails";
            break;
        case YT_REQUEST_CHANNELS_LIST_INVIDEO_PROMOTION:
            partText = @"invideoPromotion";
            break;
        case YT_REQUEST_CHANNELS_LIST_STATISTICS:
            partText = @"statistics";
            break;
        case YT_REQUEST_CHANNELS_LIST_TOPIC_DETAILS:
            partText = @"topicDetails";
            break;
            
        default:
            break;
    }
    
    return partText;
}
+ (NSString *)textOfPartForPlaylistItemsList:(YTRequestPlaylistItemsList)part {
    NSString *partText;
    switch (part) {
        case YT_REQUEST_PLAYLIST_ITEMS_LIST_ID:
            partText = @"id";
            break;
        case YT_REQUEST_PLAYLIST_ITEMS_LIST_SNIPPET:
            partText = @"snippet";
            break;
        case YT_REQUEST_PLAYLIST_ITEMS_LIST_CONTENT_DETAILS:
            partText = @"contentDetails";
            break;
        case YT_REQUEST_PLAYLIST_ITEMS_LIST_STATUS:
            partText = @"status";
            break;
            
        default:
            break;
    }
    
    return partText;
}
+ (NSString *)textOfPartForVideosList:(YTRequestVideosList)part {
    NSString *partText;
    switch (part) {
        case YT_REQUEST_VIDEOS_LIST_ID:
            partText = @"id";
            break;
        case YT_REQUEST_VIDEOS_LIST_SNIPPET:
            partText = @"snippet";
            break;
        case YT_REQUEST_VIDEOS_LIST_CONTENT_DETAILS:
            partText = @"contentDetails";
            break;
        case YT_REQUEST_VIDEOS_LIST_FILE_DETAILS:
            partText = @"fileDetails";
            break;
        case YT_REQUEST_VIDEOS_LIST_LIVE_STREAMING_DETAILS:
            partText = @"liveStreamingDetails";
            break;
        case YT_REQUEST_VIDEOS_LIST_PLAYER:
            partText = @"player";
            break;
        case YT_REQUEST_VIDEOS_LIST_PROCESSING_DETAILS:
            partText = @"processingDetails";
            break;
        case YT_REQUEST_VIDEOS_LIST_RECORDING_DETAILS:
            partText = @"recordingDetails";
            break;
        case YT_REQUEST_VIDEOS_LIST_STATISTICS:
            partText = @"statistics";
            break;
        case YT_REQUEST_VIDEOS_LIST_STATUS:
            partText = @"status";
            break;
        case YT_REQUEST_VIDEOS_LIST_SUGGESTIONS:
            partText = @"suggestions";
            break;
        case YT_REQUEST_VIDEOS_LIST_TOPIC_DETAILS:
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
    NSString *optionsList = [YTCommon makeOptionsListFromOptions:options];
    NSString *url = [NSString stringWithFormat:@"%@?%@", template, optionsList];
    
    NSString *accessToken = [YTConnector sharedInstance].accessToken;
    NSString *urlWithToken = [url stringByAppendingString:[NSString stringWithFormat:@"&access_token=%@", accessToken]];
    
    return urlWithToken;
}

+ (NSDictionary *)fetchPlaylistsListWithOptions:(NSDictionary *)options errorIs:(NSError **)error {
    NSDictionary *resultOptions;
    if ([options objectForKey:YTOptionsKeyMine]) {
        resultOptions = options;
    } else {
        NSMutableDictionary *mutableOptions = [options mutableCopy];
        [mutableOptions addEntriesFromDictionary:@{YTOptionsKeyMine : @"true"}];
        
        resultOptions = mutableOptions;
    }
    
    NSString *urlWithToken = [self makeUrlForTemplate:YTAPIPlaylistsListURL withOptions:resultOptions];
    NSHTTPURLResponse *response;
    NSDictionary *jsonAnswer = [YTCommon jsonAnswerForRequestMethod:REST_METHOD_GET
                                                                withUrlString:urlWithToken
                                                               withParameters:nil
                                                                   responseIs:&response
                                                                      errorIs:error];
    
    return jsonAnswer;
}
+ (NSDictionary *)fetchChannelsListWithOptions:(NSDictionary *)options errorIs:(NSError **)error {
    NSDictionary *resultOptions;
    if ([options objectForKey:YTOptionsKeyMine]) {
        resultOptions = options;
    } else {
        NSMutableDictionary *mutableOptions = [options mutableCopy];
        [mutableOptions addEntriesFromDictionary:@{YTOptionsKeyMine : @"true"}];
        
        resultOptions = mutableOptions;
    }
    
    NSString *urlWithToken = [self makeUrlForTemplate:YTAPIChannelsListURL withOptions:resultOptions];
    NSHTTPURLResponse *response;
    NSDictionary *jsonAnswer = [YTCommon jsonAnswerForRequestMethod:REST_METHOD_GET
                                                                withUrlString:urlWithToken
                                                               withParameters:nil
                                                                   responseIs:&response
                                                                      errorIs:error];
    
    return jsonAnswer;
}
+ (NSDictionary *)fetchPlaylistItemsListWithOptions:(NSDictionary *)options errorIs:(NSError **)error {
    NSString *urlWithToken = [self makeUrlForTemplate:YTAPIPlaylistItemsListURL withOptions:options];
    NSHTTPURLResponse *response;
    NSDictionary *jsonAnswer = [YTCommon jsonAnswerForRequestMethod:REST_METHOD_GET
                                                      withUrlString:urlWithToken
                                                     withParameters:nil
                                                         responseIs:&response
                                                            errorIs:error];
    
    return jsonAnswer;
}
+ (NSDictionary *)fetchVideosListWithOptions:(NSDictionary *)options errorIs:(NSError **)error {
    NSDictionary *resultOptions;
    if ([options objectForKey:YTOptionsKeyMine]) {
        resultOptions = options;
    } else {
        NSMutableDictionary *mutableOptions = [options mutableCopy];
        [mutableOptions addEntriesFromDictionary:@{YTOptionsKeyMine : @"true"}];
        
        resultOptions = mutableOptions;
    }
    
    NSString *urlWithToken = [self makeUrlForTemplate:YTAPIVideosListURL withOptions:resultOptions];
    NSHTTPURLResponse *response;
    NSDictionary *jsonAnswer = [YTCommon jsonAnswerForRequestMethod:REST_METHOD_GET
                                                      withUrlString:urlWithToken
                                                     withParameters:nil
                                                         responseIs:&response
                                                            errorIs:error];
    
    return jsonAnswer;
}

#pragma mark - Public interface

+ (void)fetchUserInfoCompletion:(void(^)(NSDictionary *, NSError *))completion {
    NSString *accessToken = [YTConnector sharedInstance].accessToken;
    NSString *urlString = [NSString stringWithFormat:@"%@&access_token=%@",
                           YTGoogleUserInfoURL, accessToken];
    dispatch_queue_t connectQueue = dispatch_queue_create([YTQueueGetUserInfo UTF8String], NULL);
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
    dispatch_queue_t connectQueue = dispatch_queue_create([YTQueueFetchPlaylistsList UTF8String], NULL);
    dispatch_async(connectQueue, ^{
        NSError *error = nil;
        NSDictionary *jsonAnswer = [self fetchPlaylistsListWithOptions:options errorIs:&error];
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(jsonAnswer, error);
        });
    });
}
+ (void)fetchMinePlaylistsJsonWithPart:(YTRequestPlaylistsList)part completion:(void (^)(NSDictionary *, NSError *))completion {
    NSMutableDictionary *options = [NSMutableDictionary dictionary];
    NSString *partText = [self textOfPartForPlaylistsList:part];
    [self addPartText:partText toOptionsList:options];
    
    [self fetchPlaylistsJsonWithOptions:options completion:completion];
}
+ (void)fetchMinePlaylistsJsonNumber:(NSUInteger)number withPart:(YTRequestPlaylistsList)part completion:(void (^)(NSDictionary *, NSError *))completion {
    NSMutableDictionary *options = [NSMutableDictionary dictionary];
    [options setObject:[NSNumber numberWithInteger:number] forKey:YTOptionsKeyMaxResults];

    NSString *partText = [self textOfPartForPlaylistsList:part];
    [self addPartText:partText toOptionsList:options];
    
    [self fetchPlaylistsJsonWithOptions:options completion:completion];
}
+ (void)fetchMaxMinePlaylistsJsonWithPart:(YTRequestPlaylistsList)part completion:(void (^)(NSDictionary *, NSError *))completion {
    [self fetchMinePlaylistsJsonNumber:YTOptionsValueMaxResults withPart:part completion:completion];
}

+ (void)fetchChannelsJsonWithOptions:(NSDictionary *)options completion:(void (^)(NSDictionary *, NSError *))completion {
    dispatch_queue_t connectQueue = dispatch_queue_create([YTQueueFetchChannelsList UTF8String], NULL);
    dispatch_async(connectQueue, ^{
        NSError *error = nil;
        NSDictionary *jsonAnswer = [self fetchChannelsListWithOptions:options errorIs:&error];
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(jsonAnswer, error);
        });
    });
}
+ (void)fetchMineChannelsJsonWithPart:(YTRequestChannelsList)part completion:(void (^)(NSDictionary *, NSError *))completion {
    NSMutableDictionary *options = [NSMutableDictionary dictionary];
    NSString *partText = [self textOfPartForChannelsList:part];
    [self addPartText:partText toOptionsList:options];
    
    [self fetchChannelsJsonWithOptions:options completion:completion];
}
+ (void)fetchMineChannelsJsonNumber:(NSUInteger)number withPart:(YTRequestChannelsList)part completion:(void (^)(NSDictionary *, NSError *))completion {
    NSMutableDictionary *options = [NSMutableDictionary dictionary];
    [options setObject:[NSNumber numberWithInteger:number] forKey:YTOptionsKeyMaxResults];

    NSString *partText = [self textOfPartForChannelsList:part];
    [self addPartText:partText toOptionsList:options];
    
    [self fetchChannelsJsonWithOptions:options completion:completion];
}
+ (void)fetchMaxMineChannelsJsonWithPart:(YTRequestChannelsList)part completion:(void (^)(NSDictionary *, NSError *))completion {
    [self fetchMineChannelsJsonNumber:YTOptionsValueMaxResults withPart:part completion:completion];
}

+ (void)fetchItemsOfPlaylistJsonWithOptions:(NSDictionary *)options completion:(void (^)(NSDictionary *, NSError *))completion {
    dispatch_queue_t connectQueue = dispatch_queue_create([YTQueueFetchPlaylistItemsList UTF8String], NULL);
    dispatch_async(connectQueue, ^{
        NSError *error = nil;
        NSDictionary *jsonAnswer = [self fetchPlaylistItemsListWithOptions:options errorIs:&error];
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(jsonAnswer, error);
        });
    });
}
+ (void)fetchItemsOfPlaylist:(NSString *)playlistId withPart:(YTRequestPlaylistItemsList)part completion:(void (^)(NSDictionary *, NSError *))completion {
    NSMutableDictionary *options = [NSMutableDictionary dictionary];
    [options setObject:playlistId forKey:YTOptionsKeyPlaylistId];

    NSString *partText = [self textOfPartForPlaylistItemsList:part];
    [self addPartText:partText toOptionsList:options];
    
    [self fetchItemsOfPlaylistJsonWithOptions:options completion:completion];
}
+ (void)fetchItemsNumber:(NSUInteger)number ofPlaylist:(NSString *)playlistId withPart:(YTRequestPlaylistItemsList)part completion:(void (^)(NSDictionary *, NSError *))completion {
    NSMutableDictionary *options = [NSMutableDictionary dictionary];
    [options setObject:playlistId forKey:YTOptionsKeyPlaylistId];
    [options setObject:[NSNumber numberWithInteger:number] forKey:YTOptionsKeyMaxResults];

    NSString *partText = [self textOfPartForPlaylistItemsList:part];
    [self addPartText:partText toOptionsList:options];
    
    [self fetchItemsOfPlaylistJsonWithOptions:options completion:completion];
}
+ (void)fetchMaxItemsOfPlaylist:(NSString *)playlistId withPart:(YTRequestPlaylistItemsList)part completion:(void (^)(NSDictionary *, NSError *))completion {
    [self fetchItemsNumber:YTOptionsValueMaxResults ofPlaylist:playlistId withPart:part completion:completion];
}

+ (void)fetchVideosListJsonWithOptions:(NSDictionary *)options completion:(void (^)(NSDictionary *, NSError *))completion {
    dispatch_queue_t connectQueue = dispatch_queue_create([YTQueueFetchVideosList UTF8String], NULL);
    dispatch_async(connectQueue, ^{
        NSError *error = nil;
        NSDictionary *jsonAnswer = [self fetchVideosListWithOptions:options errorIs:&error];
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(jsonAnswer, error);
        });
    });
}
+ (void)fetchVideosListContentDetailForArrayOfVideoIds:(NSArray *)arrayOfIds completion:(void (^)(NSDictionary *, NSError *))completion {
    NSMutableDictionary *options = [NSMutableDictionary dictionary];
    NSString *listOfVideosId = [arrayOfIds componentsJoinedByString:@","];
    [options setObject:listOfVideosId forKey:YTOptionsKeyId];
    
    NSString *partText = [self textOfPartForVideosList:YT_REQUEST_VIDEOS_LIST_CONTENT_DETAILS];
    [self addPartText:partText toOptionsList:options];
    
    [self fetchVideosListJsonWithOptions:options completion:completion];
}

@end
