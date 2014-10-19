//
//  YTFetcher.h
//  AKYouTubeExample
//
//  Created by Anton Pomozov on 14.10.13.
//  Copyright (c) 2013 Akademon Ltd. All rights reserved.
//

@import Foundation;

typedef NS_ENUM(NSInteger, YTRequestPlaylistsList) {
    YT_REQUEST_PLAYLISTS_LIST_ID,
    YT_REQUEST_PLAYLISTS_LIST_SNIPPET,
    YT_REQUEST_PLAYLISTS_LIST_STATUS
};

typedef NS_ENUM(NSInteger, YTRequestChannelsList) {
    YT_REQUEST_CHANNELS_LIST_ID,
    YT_REQUEST_CHANNELS_LIST_SNIPPET,
    YT_REQUEST_CHANNELS_LIST_AUDIT_DETAILS,
    YT_REQUEST_CHANNELS_LIST_BRANDING_SETTINGS,
    YT_REQUEST_CHANNELS_LIST_CONTENT_DETAILS,
    YT_REQUEST_CHANNELS_LIST_INVIDEO_PROMOTION,
    YT_REQUEST_CHANNELS_LIST_STATISTICS,
    YT_REQUEST_CHANNELS_LIST_TOPIC_DETAILS
};

typedef NS_ENUM(NSInteger, YTRequestPlaylistItemsList) {
    YT_REQUEST_PLAYLIST_ITEMS_LIST_ID,
    YT_REQUEST_PLAYLIST_ITEMS_LIST_SNIPPET,
    YT_REQUEST_PLAYLIST_ITEMS_LIST_CONTENT_DETAILS,
    YT_REQUEST_PLAYLIST_ITEMS_LIST_STATUS
};

typedef NS_ENUM(NSInteger, YTRequestVideosList) {
    YT_REQUEST_VIDEOS_LIST_ID,
    YT_REQUEST_VIDEOS_LIST_SNIPPET,
    YT_REQUEST_VIDEOS_LIST_CONTENT_DETAILS,
    YT_REQUEST_VIDEOS_LIST_FILE_DETAILS,
    YT_REQUEST_VIDEOS_LIST_LIVE_STREAMING_DETAILS,
    YT_REQUEST_VIDEOS_LIST_PLAYER,
    YT_REQUEST_VIDEOS_LIST_PROCESSING_DETAILS,
    YT_REQUEST_VIDEOS_LIST_RECORDING_DETAILS,
    YT_REQUEST_VIDEOS_LIST_STATISTICS,
    YT_REQUEST_VIDEOS_LIST_STATUS,
    YT_REQUEST_VIDEOS_LIST_SUGGESTIONS,
    YT_REQUEST_VIDEOS_LIST_TOPIC_DETAILS
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
