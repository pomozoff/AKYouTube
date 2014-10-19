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
        case AKYouTubeRequestPlaylistsListId:
            partText = @"id";
            break;
        case AKYouTubeRequestPlaylistsListSnippet:
            partText = @"snippet";
            break;
        case AKYouTubeRequestPlaylistsListStatus:
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
        case AKYouTubeRequestChannelsListId:
            partText = @"id";
            break;
        case AKYouTubeRequestChannelsListSnippet:
            partText = @"snippet";
            break;
        case AKYouTubeRequestChannelsListAuditDetails:
            partText = @"auditDetails";
            break;
        case AKYouTubeRequestChannelsListBrandingSettings:
            partText = @"brandingSettings";
            break;
        case AKYouTubeRequestChannelsListContentDetails:
            partText = @"contentDetails";
            break;
        case AKYouTubeRequestChannelsListInvideoPromotion:
            partText = @"invideoPromotion";
            break;
        case AKYouTubeRequestChannelsListStatistics:
            partText = @"statistics";
            break;
        case AKYouTubeRequestChannelsListTopicDetails:
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
        case AKYouTubeRequestPlaylistItemsListId:
            partText = @"id";
            break;
        case AKYouTubeRequestPlaylistItemsListSnippet:
            partText = @"snippet";
            break;
        case AKYouTubeRequestPlaylistItemsListContentDetails:
            partText = @"contentDetails";
            break;
        case AKYouTubeRequestPlaylistItemsListStatus:
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
        case AKYouTubeRequestVideosListId:
            partText = @"id";
            break;
        case AKYouTubeRequestVideosListSnippet:
            partText = @"snippet";
            break;
        case AKYouTubeRequestVideosListContentDetails:
            partText = @"contentDetails";
            break;
        case AKYouTubeRequestVideosListFileDetails:
            partText = @"fileDetails";
            break;
        case AKYouTubeRequestVideosListLiveStreamingDetails:
            partText = @"liveStreamingDetails";
            break;
        case AKYouTubeRequestVideosListPlayer:
            partText = @"player";
            break;
        case AKYouTubeRequestVideosListProcessingDetails:
            partText = @"processingDetails";
            break;
        case AKYouTubeRequestVideosListRecordingDetails:
            partText = @"recordingDetails";
            break;
        case AKYouTubeRequestVideosListStatistics:
            partText = @"statistics";
            break;
        case AKYouTubeRequestVideosListStatus:
            partText = @"status";
            break;
        case AKYouTubeRequestVideosListSuggestions:
            partText = @"suggestions";
            break;
        case AKYouTubeRequestVideosListTopicDetails:
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

+ (NSDictionary *)fetchPlaylistsListWithOptions:(NSDictionary *)options error:(NSError **)error {
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
    NSDictionary *jsonAnswer = [YTCommon jsonAnswerForRequestMethod:AKRestMethodGet
                                                      withUrlString:urlWithToken
                                                     withParameters:nil
                                                           response:&response
                                                              error:error];
    
    return jsonAnswer;
}
+ (NSDictionary *)fetchChannelsListWithOptions:(NSDictionary *)options error:(NSError **)error {
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
    NSDictionary *jsonAnswer = [YTCommon jsonAnswerForRequestMethod:AKRestMethodGet
                                                      withUrlString:urlWithToken
                                                     withParameters:nil
                                                           response:&response
                                                              error:error];
    
    return jsonAnswer;
}
+ (NSDictionary *)fetchPlaylistItemsListWithOptions:(NSDictionary *)options error:(NSError **)error {
    NSString *urlWithToken = [self makeUrlForTemplate:YTAPIPlaylistItemsListURL withOptions:options];
    NSHTTPURLResponse *response;
    NSDictionary *jsonAnswer = [YTCommon jsonAnswerForRequestMethod:AKRestMethodGet
                                                      withUrlString:urlWithToken
                                                     withParameters:nil
                                                           response:&response
                                                              error:error];
    
    return jsonAnswer;
}
+ (NSDictionary *)fetchVideosListWithOptions:(NSDictionary *)options error:(NSError **)error {
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
    NSDictionary *jsonAnswer = [YTCommon jsonAnswerForRequestMethod:AKRestMethodGet
                                                      withUrlString:urlWithToken
                                                     withParameters:nil
                                                           response:&response
                                                              error:error];
    
    return jsonAnswer;
}

#pragma mark - Public interface

+ (void)fetchUserInfoCompletion:(void(^)(NSDictionary *, NSError *))completion {
    NSString *accessToken = [YTConnector sharedInstance].accessToken;
    NSString *urlString = [NSString stringWithFormat:@"%@&access_token=%@",
                           YTGoogleUserInfoURL, accessToken];
    dispatch_queue_t fetchQueue = dispatch_queue_create([YTQueueGetUserInfo UTF8String], NULL);
    dispatch_async(fetchQueue, ^{
        NSHTTPURLResponse *response;
        NSError *error;
        NSDictionary *jsonAnswer = [YTCommon jsonAnswerForRequestMethod:AKRestMethodGet
                                                          withUrlString:urlString
                                                         withParameters:nil
                                                               response:&response
                                                                  error:&error];
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(jsonAnswer, error);
        });
    });
}

+ (void)fetchPlaylistsJsonWithOptions:(NSDictionary *)options completion:(void (^)(NSDictionary *, NSError *))completion {
    dispatch_queue_t fetchQueue = dispatch_queue_create([YTQueueFetchPlaylistsList UTF8String], NULL);
    dispatch_async(fetchQueue, ^{
        NSError *error;
        NSDictionary *jsonAnswer = [self fetchPlaylistsListWithOptions:options error:&error];
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
    dispatch_queue_t fetchQueue = dispatch_queue_create([YTQueueFetchChannelsList UTF8String], NULL);
    dispatch_async(fetchQueue, ^{
        NSError *error;
        NSDictionary *jsonAnswer = [self fetchChannelsListWithOptions:options error:&error];
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
    dispatch_queue_t fetchQueue = dispatch_queue_create([YTQueueFetchPlaylistItemsList UTF8String], NULL);
    dispatch_async(fetchQueue, ^{
        NSError *error;
        NSDictionary *jsonAnswer = [self fetchPlaylistItemsListWithOptions:options error:&error];
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
    dispatch_queue_t fetchQueue = dispatch_queue_create([YTQueueFetchVideosList UTF8String], NULL);
    dispatch_async(fetchQueue, ^{
        NSError *error;
        NSDictionary *jsonAnswer = [self fetchVideosListWithOptions:options error:&error];
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(jsonAnswer, error);
        });
    });
}
+ (void)fetchVideosListContentDetailForArrayOfVideoIds:(NSArray *)arrayOfIds completion:(void (^)(NSDictionary *, NSError *))completion {
    NSMutableDictionary *options = [NSMutableDictionary dictionary];
    NSString *listOfVideosId = [arrayOfIds componentsJoinedByString:@","];
    [options setObject:listOfVideosId forKey:YTOptionsKeyId];
    
    NSString *partText = [self textOfPartForVideosList:AKYouTubeRequestVideosListContentDetails];
    [self addPartText:partText toOptionsList:options];
    
    [self fetchVideosListJsonWithOptions:options completion:completion];
}

@end
