//
//  YTFetcher.h
//  AKYouTubeExample
//
//  Created by Anton Pomozov on 14.10.13.
//  Copyright (c) 2013 Akademon Ltd. All rights reserved.
//

@import Foundation;

typedef enum {
    REQUEST_PLAYLIST_PART_ID,
    REQUEST_PLAYLIST_PART_SNIPPET,
    REQUEST_PLAYLIST_PART_STATUS
} YTRequestPlaylistPart;

typedef enum {
    REQUEST_CHANNEL_PART_ID,
    REQUEST_CHANNEL_PART_SNIPPET,
    REQUEST_CHANNEL_PART_AUDIT_DETAILS,
    REQUEST_CHANNEL_PART_BRANDING_SETTINGS,
    REQUEST_CHANNEL_PART_CONTENT_DETAILS,
    REQUEST_CHANNEL_PART_INVIDEO_PROMOTION,
    REQUEST_CHANNEL_PART_STATISTICS,
    REQUEST_CHANNEL_PART_TOPIC_DETAILS
} YTRequestChannelPart;

typedef enum {
    PLAYLIST_ITEMS_PART_ID,
    PLAYLIST_ITEMS_PART_SNIPPET,
    PLAYLIST_ITEMS_PART_CONTENT_DETAILS,
    PLAYLIST_ITEMS_PART_STATUS
} YTPlaylistItemsPart;

@interface YTFetcher : NSObject

+ (void)getUserInfoCompletion:(void(^)(NSDictionary *, NSError *))completion;

+ (void)fetchPlaylistsJsonWithOptions:(NSDictionary *)options completion:(void (^)(NSDictionary *, NSError *))completion;
+ (void)fetchMinePlaylistsJsonWithPart:(YTRequestPlaylistPart)part completion:(void (^)(NSDictionary *, NSError *))completion;
+ (void)fetchMinePlaylistsJsonNumber:(NSUInteger)count withPart:(YTRequestPlaylistPart)part completion:(void (^)(NSDictionary *, NSError *))completion;

+ (void)fetchChannelsJsonWithOptions:(NSDictionary *)options completion:(void (^)(NSDictionary *, NSError *))completion;
+ (void)fetchMineChannelsJsonWithPart:(YTRequestChannelPart)part completion:(void (^)(NSDictionary *, NSError *))completion;
+ (void)fetchMineChannelsJsonNumber:(NSUInteger)count withPart:(YTRequestChannelPart)part completion:(void (^)(NSDictionary *, NSError *))completion;

+ (void)fetchItemsOfPlaylist:(NSString *)playlistId withPart:(YTPlaylistItemsPart)part completion:(void (^)(NSDictionary *, NSError *))completion;

@end
