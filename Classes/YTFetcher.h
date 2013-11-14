//
//  YTFetcher.h
//  AKYouTubeExample
//
//  Created by Anton Pomozov on 14.10.13.
//  Copyright (c) 2013 Akademon Ltd. All rights reserved.
//

@import Foundation;

typedef enum {
    YOUTUBE_REQUEST_PLAYLIST_PART_ID,
    YOUTUBE_REQUEST_PLAYLIST_PART_SNIPPET,
    YOUTUBE_REQUEST_PLAYLIST_PART_STATUS
} YTRequestPlaylistPart;

typedef enum {
    YOUTUBE_REQUEST_CHANNEL_PART_ID,
    YOUTUBE_REQUEST_CHANNEL_PART_SNIPPET,
    YOUTUBE_REQUEST_CHANNEL_PART_AUDIT_DETAILS,
    YOUTUBE_REQUEST_CHANNEL_PART_BRANDING_SETTINGS,
    YOUTUBE_REQUEST_CHANNEL_PART_CONTENT_DETAILS,
    YOUTUBE_REQUEST_CHANNEL_PART_INVIDEO_PROMOTION,
    YOUTUBE_REQUEST_CHANNEL_PART_STATISTICS,
    YOUTUBE_REQUEST_CHANNEL_PART_TOPIC_DETAILS
} YTRequestChannelPart;

typedef enum {
    YOUTUBE_REQUEST_PLAYLIST_ITEMS_PART_ID,
    YOUTUBE_REQUEST_PLAYLIST_ITEMS_PART_SNIPPET,
    YOUTUBE_REQUEST_PLAYLIST_ITEMS_PART_CONTENT_DETAILS,
    YOUTUBE_REQUEST_PLAYLIST_ITEMS_PART_STATUS
} YTRequestPlaylistItemsPart;

@interface YTFetcher : NSObject

+ (void)getUserInfoCompletion:(void(^)(NSDictionary *, NSError *))completion;

+ (void)fetchPlaylistsJsonWithOptions:(NSDictionary *)options completion:(void (^)(NSDictionary *, NSError *))completion;
+ (void)fetchMinePlaylistsJsonWithPart:(YTRequestPlaylistPart)part completion:(void (^)(NSDictionary *, NSError *))completion;
+ (void)fetchMinePlaylistsJsonNumber:(NSUInteger)number withPart:(YTRequestPlaylistPart)part completion:(void (^)(NSDictionary *, NSError *))completion;

+ (void)fetchChannelsJsonWithOptions:(NSDictionary *)options completion:(void (^)(NSDictionary *, NSError *))completion;
+ (void)fetchMineChannelsJsonWithPart:(YTRequestChannelPart)part completion:(void (^)(NSDictionary *, NSError *))completion;
+ (void)fetchMineChannelsJsonNumber:(NSUInteger)number withPart:(YTRequestChannelPart)part completion:(void (^)(NSDictionary *, NSError *))completion;

+ (void)fetchItemsOfPlaylist:(NSString *)playlistId withPart:(YTRequestPlaylistItemsPart)part completion:(void (^)(NSDictionary *, NSError *))completion;

@end
