//
//  YTFetcher.h
//  AKYouTubeExample
//
//  Created by Anton Pomozov on 14.10.13.
//  Copyright (c) 2013 Akademon Ltd. All rights reserved.
//

@import Foundation;

typedef enum {
    REQUEST_PART_ID,
    REQUEST_PART_STATUS,
    REQUEST_PART_SNIPPET
} YTRequestPart;

@interface YTFetcher : NSObject

+ (void)fetchPlaylistObjectsWithOptions:(NSDictionary *)options completion:(void (^)(NSArray *, NSError *))completion;
+ (void)fetchMinePlaylistObjectsWithPart:(YTRequestPart)part completion:(void (^)(NSArray *, NSError *))completion;
+ (void)fetchMinePlaylistObjectsNumber:(NSUInteger)count withPart:(YTRequestPart)part completion:(void (^)(NSArray *, NSError *))completion;

+ (void)fetchPlaylistsJsonWithOptions:(NSDictionary *)options completion:(void (^)(NSDictionary *, NSError *))completion;
+ (void)fetchMinePlaylistsJsonWithPart:(YTRequestPart)part completion:(void (^)(NSDictionary *, NSError *))completion;
+ (void)fetchMinePlaylistsJsonNumber:(NSUInteger)count withPart:(YTRequestPart)part completion:(void (^)(NSDictionary *, NSError *))completion;

@end
