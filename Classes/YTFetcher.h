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

+ (void)fetchPlaylistsWithOptions:(NSDictionary *)options blockCompletion:(void (^)(NSArray *, NSError *))completion;
+ (void)fetchMinePlaylistsWithPart:(YTRequestPart)part blockCompletion:(void (^)(NSArray *, NSError *))completion;
+ (void)fetchMinePlaylistsNumber:(NSInteger)count withPart:(YTRequestPart)part blockCompletion:(void (^)(NSArray *, NSError *))completion;

@end
