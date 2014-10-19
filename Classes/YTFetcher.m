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
static NSString *const YTOptionsKeyplaylistId = @"playlistId";

static NSUInteger const YTOptionsValueMaxResults = 50;

@implementation YTFetcher

#pragma mark - Private methods

+ (NSString *)textOfPlaylistPart:(YTRequestPlaylistPart)part {
    NSString *partText;
    switch (part) {
        case AKYouTubeRequestPlaylistPartId:
            partText = @"id";
            break;
        case AKYouTubeRequestPlaylistPartSnippet:
            partText = @"snippet";
            break;
        case AKYouTubeRequestPlaylistPartStatus:
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
        case AKYouTubeRequestChannelPartId:
            partText = @"id";
            break;
        case AKYouTubeRequestChannelPartSnippet:
            partText = @"snippet";
            break;
        case AKYouTubeRequestChannelPartAuditDetails:
            partText = @"auditDetails";
            break;
        case AKYouTubeRequestChannelPartBrandingSetings:
            partText = @"brandingSettings";
            break;
        case AKYouTubeRequestChannelPartContentDetails:
            partText = @"contentDetails";
            break;
        case AKYouTubeRequestChannelPartInvideoPromotion:
            partText = @"invideoPromotion";
            break;
        case AKYouTubeRequestChannelPartStatistics:
            partText = @"statistics";
            break;
        case AKYouTubeRequestChannelPartTopicDetails:
            partText = @"topicDetails";
            break;
            
        default:
            break;
    }
    
    return partText;
}
+ (NSString *)textOfPlaylistItemsPart:(YTRequestPlaylistItemsPart)part {
    NSString *partText;
    switch (part) {
        case AKYouTubeRequestPlaylistItemsPartId:
            partText = @"id";
            break;
        case AKYouTubeRequestPlaylistItemsPartSnippet:
            partText = @"snippet";
            break;
        case AKYouTubeRequestPlaylistItemsPartContentDetails:
            partText = @"status";
            break;
        case AKYouTubeRequestPlaylistItemsPartStatus:
            partText = @"snippet";
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
    
    NSString *accessToken = YTConnector.sharedInstance.accessToken;
    NSString *urlWithToken = [url stringByAppendingString:[NSString stringWithFormat:@"&access_token=%@", accessToken]];
    
    return urlWithToken;
}
+ (NSDictionary *)fetchPlaylistsWithOptions:(NSDictionary *)options errorIs:(NSError **)error {
    NSDictionary *resultOptions;
    if ([options objectForKey:YTOptionsKeyMine]) {
        resultOptions = options;
    } else {
        NSMutableDictionary *mutableOptions = [options mutableCopy];
        [mutableOptions addEntriesFromDictionary:@{YTOptionsKeyMine : @"true"}];
        
        resultOptions = mutableOptions;
    }
    
    NSString *urlWithToken = [self makeUrlForTemplate:YTAPIListPlaylistsURL withOptions:resultOptions];
    NSHTTPURLResponse *response;
    NSDictionary *jsonAnswer = [YTCommon jsonAnswerForRequestMethod:AKRestMethodGet
                                                                withUrlString:urlWithToken
                                                               withParameters:nil
                                                                   responseIs:&response
                                                                      errorIs:error];
    
    return jsonAnswer;
}
+ (NSDictionary *)fetchPlaylistItemsWithOptions:(NSDictionary *)options errorIs:(NSError **)error {
    NSString *urlWithToken = [self makeUrlForTemplate:YTAPIListPlaylistItemsURL withOptions:options];
    NSHTTPURLResponse *response;
    NSDictionary *jsonAnswer = [YTCommon jsonAnswerForRequestMethod:AKRestMethodGet
                                                      withUrlString:urlWithToken
                                                     withParameters:nil
                                                         responseIs:&response
                                                            errorIs:error];
    
    return jsonAnswer;
}
+ (NSDictionary *)fetchChannelsWithOptions:(NSDictionary *)options errorIs:(NSError **)error {
    NSDictionary *resultOptions;
    if ([options objectForKey:YTOptionsKeyMine]) {
        resultOptions = options;
    } else {
        NSMutableDictionary *mutableOptions = [options mutableCopy];
        [mutableOptions addEntriesFromDictionary:@{YTOptionsKeyMine : @"true"}];
        
        resultOptions = mutableOptions;
    }
    
    NSString *urlWithToken = [self makeUrlForTemplate:YTAPIListChannelsURL withOptions:resultOptions];
    NSHTTPURLResponse *response;
    NSDictionary *jsonAnswer = [YTCommon jsonAnswerForRequestMethod:AKRestMethodGet
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
    dispatch_queue_t connectQueue = dispatch_queue_create([YTQueueGetUserInfo UTF8String], NULL);
    dispatch_async(connectQueue, ^{
        NSHTTPURLResponse *response;
        NSError *error = nil;
        NSDictionary *jsonAnswer = [YTCommon jsonAnswerForRequestMethod:AKRestMethodGet
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
    dispatch_queue_t connectQueue = dispatch_queue_create([YTQueueFetchPlaylists UTF8String], NULL);
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
+ (void)fetchMinePlaylistsJsonNumber:(NSUInteger)number withPart:(YTRequestPlaylistPart)part completion:(void (^)(NSDictionary *, NSError *))completion {
    NSMutableDictionary *options = [NSMutableDictionary dictionary];
    [options setObject:[NSNumber numberWithInteger:number] forKey:YTOptionsKeyMaxResults];

    NSString *partText = [self textOfPlaylistPart:part];
    [self addPartText:partText toOptionsList:options];
    
    [self fetchPlaylistsJsonWithOptions:options completion:completion];
}
+ (void)fetchMaxMinePlaylistsJsonWithPart:(YTRequestPlaylistPart)part completion:(void (^)(NSDictionary *, NSError *))completion {
    [self fetchMinePlaylistsJsonNumber:YTOptionsValueMaxResults withPart:part completion:completion];
}

+ (void)fetchChannelsJsonWithOptions:(NSDictionary *)options completion:(void (^)(NSDictionary *, NSError *))completion {
    dispatch_queue_t connectQueue = dispatch_queue_create([YTQueueFetchChannels UTF8String], NULL);
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
+ (void)fetchMineChannelsJsonNumber:(NSUInteger)number withPart:(YTRequestChannelPart)part completion:(void (^)(NSDictionary *, NSError *))completion {
    NSMutableDictionary *options = [NSMutableDictionary dictionary];
    [options setObject:[NSNumber numberWithInteger:number] forKey:YTOptionsKeyMaxResults];

    NSString *partText = [self textOfChannelPart:part];
    [self addPartText:partText toOptionsList:options];
    
    [self fetchChannelsJsonWithOptions:options completion:completion];
}
+ (void)fetchMaxMineChannelsJsonWithPart:(YTRequestChannelPart)part completion:(void (^)(NSDictionary *, NSError *))completion {
    [self fetchMineChannelsJsonNumber:YTOptionsValueMaxResults withPart:part completion:completion];
}

+ (void)fetchItemsOfPlaylistJsonWithOptions:(NSDictionary *)options completion:(void (^)(NSDictionary *, NSError *))completion {
    dispatch_queue_t connectQueue = dispatch_queue_create([YTQueueFetchPlaylistItem UTF8String], NULL);
    dispatch_async(connectQueue, ^{
        NSError *error = nil;
        NSDictionary *jsonAnswer = [self fetchPlaylistItemsWithOptions:options errorIs:&error];
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(jsonAnswer, error);
        });
    });
}
+ (void)fetchItemsOfPlaylist:(NSString *)playlistId withPart:(YTRequestPlaylistItemsPart)part completion:(void (^)(NSDictionary *, NSError *))completion {
    NSMutableDictionary *options = [NSMutableDictionary dictionary];
    [options setObject:playlistId forKey:YTOptionsKeyplaylistId];

    NSString *partText = [self textOfPlaylistItemsPart:part];
    [self addPartText:partText toOptionsList:options];
    
    [self fetchItemsOfPlaylistJsonWithOptions:options completion:completion];
}
+ (void)fetchItemsNumber:(NSUInteger)number ofPlaylist:(NSString *)playlistId withPart:(YTRequestPlaylistItemsPart)part completion:(void (^)(NSDictionary *, NSError *))completion {
    NSMutableDictionary *options = [NSMutableDictionary dictionary];
    [options setObject:playlistId forKey:YTOptionsKeyplaylistId];
    [options setObject:[NSNumber numberWithInteger:number] forKey:YTOptionsKeyMaxResults];

    NSString *partText = [self textOfPlaylistItemsPart:part];
    [self addPartText:partText toOptionsList:options];
    
    [self fetchItemsOfPlaylistJsonWithOptions:options completion:completion];
}
+ (void)fetchMaxItemsOfPlaylist:(NSString *)playlistId withPart:(YTRequestPlaylistItemsPart)part completion:(void (^)(NSDictionary *, NSError *))completion {
    [self fetchItemsNumber:YTOptionsValueMaxResults ofPlaylist:playlistId withPart:part completion:completion];
}

@end
