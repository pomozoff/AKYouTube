//
//  AKYoutubeObjectsMapper.m
//  AKYouTubeExample
//
//  Created by Антон Помозов on 11.11.13.
//  Copyright (c) 2013 Akademon Ltd. All rights reserved.
//

#import "AKYoutubeObjectsMapper.h"
#import "AKPlaylistYouTubeObject.h"
#import "AKResponseYouTubeObject.h"

@implementation AKYoutubeObjectsMapper

#pragma mark - Private methods

+ (void)addHeaderMapping:(EKObjectMapping *)mapping {
    [mapping mapFieldsFromArray:@[@"etag", @"kind"]];
}

#pragma mark - Public interface

+ (EKObjectMapping *)playlistMapping {
    return [EKObjectMapping mappingForClass:[AKPlaylistYouTubeObject class] withBlock:^(EKObjectMapping *mapping) {
        [self addHeaderMapping:mapping];
        [mapping mapFieldsFromDictionary:@{
            @"id" : @"itemId"
        }];
        
        [mapping mapKey:@"snippet.publishedAt" toField:@"publishedAt" withDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
        [mapping mapKey:@"snippet.channelId" toField:@"channelId"];
        [mapping mapKey:@"snippet.title" toField:@"title"];
        [mapping mapKey:@"snippet.channelTitle" toField:@"channelTitle"];
        [mapping mapKey:@"snippet.description" toField:@"itemDescription"];
        [mapping mapKey:@"snippet.thumbnails.default.url" toField:@"defaultUrl"];
        [mapping mapKey:@"snippet.thumbnails.medium.url" toField:@"mediumUrl"];
        [mapping mapKey:@"snippet.thumbnails.high.url" toField:@"highUrl"];
    }];
}
+ (EKObjectMapping *)responsePlaylistMapping
{
    return [EKObjectMapping mappingForClass:[AKResponseYouTubeObject class] withBlock:^(EKObjectMapping *mapping) {
        [self addHeaderMapping:mapping];
        [mapping mapKey:@"pageInfo.totalResults" toField:@"totalResults"];
        [mapping mapKey:@"pageInfo.resultsPerPage" toField:@"resultsPerPage"];
        [mapping hasManyMapping:[self playlistMapping] forKey:@"items"];
    }];
}

@end
