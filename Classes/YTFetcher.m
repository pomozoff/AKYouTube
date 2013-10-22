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
+ (NSArray *)makeArrayOfPlaylistsFromJSON:(NSDictionary *)jsonPlaylists {
    return nil;
}
+ (void)fetchPlaylistsWithOptions:(NSDictionary *)options blockCompletion:(void (^)(NSArray *, NSError *))completion {
    NSDictionary *resultOptions;
    if ([options objectForKey:YTOptionsKeyMine]) {
        resultOptions = options;
    } else {
        NSMutableDictionary *mutableOptions = [options mutableCopy];
        [mutableOptions addEntriesFromDictionary:@{YTOptionsKeyMine : @"true"}];
        
        resultOptions = mutableOptions;
    }
    
    NSString *optionsList = [YTCommon makeOptionsListFromOptions:resultOptions];
    NSString *url = [NSString stringWithFormat:@"%@?%@", YTAPIListPlaylistsURL, optionsList];
    
    NSString *accessToken = YTConnector.sharedInstance.accessToken;
    NSString *urlWithToken = [url stringByAppendingString:[NSString stringWithFormat:@"&access_token=%@", accessToken]];
    
    NSHTTPURLResponse *response;
    NSError *error = nil;
    
    NSDictionary *jsonAnswer = [YTCommon jsonAnswerForRequestMethod:REST_METHOD_GET
                                                      withUrlString:urlWithToken
                                                     withParameters:nil
                                                         responseIs:&response
                                                            errorIs:&error];
    
    completion([self makeArrayOfPlaylistsFromJSON:jsonAnswer], error);
}
+ (void)fetchMinePlaylistsWithPart:(YTRequestPart)part blockCompletion:(void (^)(NSArray *, NSError *))completion {
    NSMutableDictionary *options = [NSMutableDictionary dictionary];

    NSString *partText = [self textOfPart:part];
    if (partText) {
        [options setObject:partText forKey:YTOptionsKeyPart];
    }

    [self fetchPlaylistsWithOptions:options blockCompletion:completion];
}
+ (void)fetchMinePlaylistsNumber:(NSInteger)count withPart:(YTRequestPart)part blockCompletion:(void (^)(NSArray *, NSError *))completion {
    NSMutableDictionary *options = [NSMutableDictionary dictionary];
    [options setObject:[NSNumber numberWithInteger:count] forKey:YTOptionsKeyMaxResults];

    NSString *partText = [self textOfPart:part];
    if (partText) {
        [options setObject:partText forKey:YTOptionsKeyPart];
    }

    [self fetchPlaylistsWithOptions:options blockCompletion:completion];
}

@end
