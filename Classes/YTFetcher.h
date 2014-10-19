//
//  YTFetcher.h
//  AKYouTubeExample
//
//  Created by Anton Pomozov on 14.10.13.
//  Copyright (c) 2013 Akademon Ltd. All rights reserved.
//

@import Foundation;

typedef NS_ENUM(NSInteger, YTRequestPlaylistsList) {
    AKYouTubeRequestPlaylistsListId,
    AKYouTubeRequestPlaylistsListSnippet,
    AKYouTubeRequestPlaylistsListStatus
};

typedef NS_ENUM(NSInteger, YTRequestChannelsList) {
    AKYouTubeRequestChannelsListId,
    AKYouTubeRequestChannelsListSnippet,
    AKYouTubeRequestChannelsListAuditDetails,
    AKYouTubeRequestChannelsListBrandingSettings,
    AKYouTubeRequestChannelsListContentDetails,
    AKYouTubeRequestChannelsListInvideoPromotion,
    AKYouTubeRequestChannelsListStatistics,
    AKYouTubeRequestChannelsListTopicDetails
};

typedef NS_ENUM(NSInteger, YTRequestPlaylistItemsList) {
    AKYouTubeRequestPlaylistItemsListId,
    AKYouTubeRequestPlaylistItemsListSnippet,
    AKYouTubeRequestPlaylistItemsListContentDetails,
    AKYouTubeRequestPlaylistItemsListStatus
};

typedef NS_ENUM(NSInteger, YTRequestVideosList) {
    AKYouTubeRequestVideosListId,
    AKYouTubeRequestVideosListSnippet,
    AKYouTubeRequestVideosListContentDetails,
    AKYouTubeRequestVideosListFileDetails,
    AKYouTubeRequestVideosListLiveStreamingDetails,
    AKYouTubeRequestVideosListPlayer,
    AKYouTubeRequestVideosListProcessingDetails,
    AKYouTubeRequestVideosListRecordingDetails,
    AKYouTubeRequestVideosListStatistics,
    AKYouTubeRequestVideosListStatus,
    AKYouTubeRequestVideosListSuggestions,
    AKYouTubeRequestVideosListTopicDetails
};

@interface YTFetcher : NSObject

+ (void)fetchUserInfoCompletion:(void(^)(NSDictionary *, NSError *))completion;

+ (void)fetchPlaylistsJsonWithOptions:(NSDictionary *)options completion:(void (^)(NSDictionary *, NSError *))completion;
+ (void)fetchMinePlaylistsJsonWithPart:(YTRequestPlaylistsList)part completion:(void (^)(NSDictionary *, NSError *))completion;
+ (void)fetchMinePlaylistsJsonNumber:(NSUInteger)number withPart:(YTRequestPlaylistsList)part completion:(void (^)(NSDictionary *, NSError *))completion;
+ (void)fetchMaxMinePlaylistsJsonWithPart:(YTRequestPlaylistsList)part completion:(void (^)(NSDictionary *, NSError *))completion;

+ (void)fetchChannelsJsonWithOptions:(NSDictionary *)options completion:(void (^)(NSDictionary *, NSError *))completion;
+ (void)fetchMineChannelsJsonWithPart:(YTRequestChannelsList)part completion:(void (^)(NSDictionary *, NSError *))completion;
+ (void)fetchMineChannelsJsonNumber:(NSUInteger)number withPart:(YTRequestChannelsList)part completion:(void (^)(NSDictionary *, NSError *))completion;
+ (void)fetchMaxMineChannelsJsonWithPart:(YTRequestChannelsList)part completion:(void (^)(NSDictionary *, NSError *))completion;

+ (void)fetchItemsOfPlaylistJsonWithOptions:(NSDictionary *)options completion:(void (^)(NSDictionary *, NSError *))completion;
+ (void)fetchItemsOfPlaylist:(NSString *)playlistId withPart:(YTRequestPlaylistItemsList)part completion:(void (^)(NSDictionary *, NSError *))completion;
+ (void)fetchItemsNumber:(NSUInteger)number ofPlaylist:(NSString *)playlistId withPart:(YTRequestPlaylistItemsList)part completion:(void (^)(NSDictionary *, NSError *))completion;
+ (void)fetchMaxItemsOfPlaylist:(NSString *)playlistId withPart:(YTRequestPlaylistItemsList)part completion:(void (^)(NSDictionary *, NSError *))completion;

+ (void)fetchVideosListJsonWithOptions:(NSDictionary *)options completion:(void (^)(NSDictionary *, NSError *))completion;
+ (void)fetchVideosListContentDetailForArrayOfVideoIds:(NSArray *)arrayOfIds completion:(void (^)(NSDictionary *, NSError *))completion;

@end
