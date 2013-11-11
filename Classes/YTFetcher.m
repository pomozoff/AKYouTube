//
//  YTFetcher.m
//  AKYouTubeExample
//
//  Created by Anton Pomozov on 14.10.13.
//  Copyright (c) 2013 Akademon Ltd. All rights reserved.
//

#import "YTFetcher.h"
#import "YTCommonConnection.h"
#import "YTConnector.h"
#import "YTPlaylistObject.h"

#import "EasyMapping.h"
#import "YTResponsePlaylistObject.h"
#import "YTMappingProvider.h"

static NSString *const YTOptionsKeyMine = @"mine";
static NSString *const YTOptionsKeyPart = @"part";
static NSString *const YTOptionsKeyMaxResults = @"maxResults";

@implementation YTFetcher

#pragma mark - Private methods

+ (NSString *)textOfPart:(YTRequestPart)part {
    NSString *partText;
    switch (part) {
        case REQUEST_PART_ID:
            partText = @"id";
            break;
        case REQUEST_PART_STATUS:
            partText = @"status";
            break;
        case REQUEST_PART_SNIPPET:
            partText = @"snippet";
            break;
            
        default:
            break;
    }
    
    return partText;
}
+ (void)addPart:(YTRequestPart)part toOptionsList:(NSMutableDictionary *)options {
    NSString *partText = [self textOfPart:part];
    if (partText) {
        [options setObject:partText forKey:YTOptionsKeyPart];
    }
}
+ (NSArray *)makeArrayOfPlaylistsFromJSON:(NSDictionary *)jsonPlaylists {
    YTResponsePlaylistObject *responseObject = [EKMapper objectFromExternalRepresentation:jsonPlaylists
                                                                              withMapping:[YTMappingProvider responsePlaylistMapping]];
    
    return responseObject.items;
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
    
    NSString *optionsList = [YTCommonConnection makeOptionsListFromOptions:resultOptions];
    NSString *url = [NSString stringWithFormat:@"%@?%@", YTAPIListPlaylistsURL, optionsList];
    
    NSString *accessToken = YTConnector.sharedInstance.accessToken;
    NSString *urlWithToken = [url stringByAppendingString:[NSString stringWithFormat:@"&access_token=%@", accessToken]];
    
    NSHTTPURLResponse *response;
    NSDictionary *jsonAnswer = [YTCommonConnection jsonAnswerForRequestMethod:REST_METHOD_GET
                                                                withUrlString:urlWithToken
                                                               withParameters:nil
                                                                   responseIs:&response
                                                                      errorIs:error];
    
    return jsonAnswer;
}

#pragma mark - Public interface

+ (void)fetchPlaylistObjectsWithOptions:(NSDictionary *)options completion:(void (^)(NSArray *, NSError *))completion {
    dispatch_queue_t connectQueue = dispatch_queue_create("YouTube fetch playlists as objects", NULL);
    dispatch_async(connectQueue, ^{
        NSError *error = nil;
        NSDictionary *jsonAnswer = [self fetchPlaylistsWithOptions:options errorIs:&error];
        dispatch_async(dispatch_get_main_queue(), ^{
            completion([self makeArrayOfPlaylistsFromJSON:jsonAnswer], error);
        });
    });
}
+ (void)fetchMinePlaylistObjectsWithPart:(YTRequestPart)part completion:(void (^)(NSArray *, NSError *))completion {
    NSMutableDictionary *options = [NSMutableDictionary dictionary];
    [self addPart:part toOptionsList:options];

    [self fetchPlaylistObjectsWithOptions:options completion:completion];
}
+ (void)fetchMinePlaylistObjectsNumber:(NSUInteger)count withPart:(YTRequestPart)part completion:(void (^)(NSArray *, NSError *))completion {
    NSMutableDictionary *options = [NSMutableDictionary dictionary];
    [options setObject:[NSNumber numberWithInteger:count] forKey:YTOptionsKeyMaxResults];
    [self addPart:part toOptionsList:options];

    [self fetchPlaylistObjectsWithOptions:options completion:completion];
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
+ (void)fetchMinePlaylistsJsonWithPart:(YTRequestPart)part completion:(void (^)(NSDictionary *, NSError *))completion {
    NSMutableDictionary *options = [NSMutableDictionary dictionary];
    [self addPart:part toOptionsList:options];
    
    [self fetchPlaylistsJsonWithOptions:options completion:completion];
}
+ (void)fetchMinePlaylistsJsonNumber:(NSUInteger)count withPart:(YTRequestPart)part completion:(void (^)(NSDictionary *, NSError *))completion {
    NSMutableDictionary *options = [NSMutableDictionary dictionary];
    [options setObject:[NSNumber numberWithInteger:count] forKey:YTOptionsKeyMaxResults];
    [self addPart:part toOptionsList:options];
    
    [self fetchPlaylistsJsonWithOptions:options completion:completion];
}

@end
