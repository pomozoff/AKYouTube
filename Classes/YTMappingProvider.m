//
//  YTMappingProvider.m
//  SyncTube
//
//  Created by Антон Помозов on 05.05.13.
//  Copyright (c) 2013 Akademon Ltd. All rights reserved.
//

#import "YTMappingProvider.h"
#import "YTResponseObject.h"
#import "YTPlaylistObject.h"
#import "YTChannelsObject.h"

@implementation YTMappingProvider

+ (void)headerMappingWithMapping:(EKObjectMapping *)mapping {
    [mapping mapFieldsFromArray:@[@"etag", @"kind"]];
}

+ (EKObjectMapping *)playlistMapping {
    return [EKObjectMapping mappingForClass:[YTPlaylistObject class] withBlock:^(EKObjectMapping *mapping) {
        [YTMappingProvider headerMappingWithMapping:mapping];
        [mapping mapFieldsFromDictionary:@{
            @"id" : @"uid"
        }];
        
        [mapping mapKey:@"snippet" toField:@"title" withValueBlock:^id(NSString *key, id value) {
            NSDictionary *dictionary = (NSDictionary *)value;
            return dictionary[@"title"];
        }];
        [mapping mapKey:@"snippet" toField:@"descript" withValueBlock:^id(NSString *key, id value) {
            NSDictionary *dictionary = (NSDictionary *)value;
            return dictionary[@"description"];
        }];
        [mapping mapKey:@"snippet" toField:@"channelTitle" withValueBlock:^id(NSString *key, id value) {
            NSDictionary *dictionary = (NSDictionary *)value;
            return dictionary[@"channelTitle"];
        }];
        [mapping mapKey:@"snippet" toField:@"channelId" withValueBlock:^id(NSString *key, id value) {
            NSDictionary *dictionary = (NSDictionary *)value;
            return dictionary[@"channelId"];
        }];
        [mapping mapKey:@"snippet" toField:@"publishedAt" withValueBlock:^id(NSString *key, id value) {
            NSDictionary *dictionary = (NSDictionary *)value;
            NSString *dateString = dictionary[@"publishedAt"];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
            dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
            
            NSDate *date = [dateFormatter dateFromString:dateString];
            
            return date;
        }];
        
        //[mapping mapKey:@"snippet" toFieldsFromArray:@[@"title", @"channelTitle", @"channelId"]];
        //[mapping mapKey:@"snippet" toFieldsFromDictionary:@{@"description" : @"descript"}];
        
    }];
}
+ (EKObjectMapping *)responsePlaylistsMapping {
    return [EKObjectMapping mappingForClass:[YTResponseObject class] withBlock:^(EKObjectMapping *mapping) {
        [YTMappingProvider headerMappingWithMapping:mapping];
        [mapping hasManyMapping:[YTMappingProvider playlistMapping] forKey:@"items"];
    }];
}

+ (EKObjectMapping *)channelsMapping {
    return [EKObjectMapping mappingForClass:[YTChannelsObject class] withBlock:^(EKObjectMapping *mapping) {
        [YTMappingProvider headerMappingWithMapping:mapping];
        [mapping mapFieldsFromDictionary:@{
            @"id" : @"uid"
        }];
        
        [mapping mapKey:@"contentDetails" toField:@"likesId" withValueBlock:^id(NSString *key, id value) {
            NSDictionary *dictionary = (NSDictionary *)value[@"relatedPlaylists"];
            return dictionary[@"likes"];
        }];
        [mapping mapKey:@"contentDetails" toField:@"favoritesId" withValueBlock:^id(NSString *key, id value) {
            NSDictionary *dictionary = (NSDictionary *)value[@"relatedPlaylists"];
            return dictionary[@"favorites"];
        }];
        [mapping mapKey:@"contentDetails" toField:@"uploadsId" withValueBlock:^id(NSString *key, id value) {
            NSDictionary *dictionary = (NSDictionary *)value[@"relatedPlaylists"];
            return dictionary[@"uploads"];
        }];
        [mapping mapKey:@"contentDetails" toField:@"watchHistoryId" withValueBlock:^id(NSString *key, id value) {
            NSDictionary *dictionary = (NSDictionary *)value[@"relatedPlaylists"];
            return dictionary[@"watchHistory"];
        }];
        [mapping mapKey:@"contentDetails" toField:@"watchLaterId" withValueBlock:^id(NSString *key, id value) {
            NSDictionary *dictionary = (NSDictionary *)value[@"relatedPlaylists"];
            return dictionary[@"watchLater"];
        }];
    }];
}
+ (EKObjectMapping *)responseChannelsMapping {
    return [EKObjectMapping mappingForClass:[YTResponseObject class] withBlock:^(EKObjectMapping *mapping) {
        [YTMappingProvider headerMappingWithMapping:mapping];
        [mapping hasManyMapping:[YTMappingProvider channelsMapping] forKey:@"items"];
    }];
}

+ (EKManagedObjectMapping *)userMapping {
    return [EKManagedObjectMapping mappingForEntityName:@"User" withBlock:^(EKManagedObjectMapping *mapping) {
        [mapping mapFieldsFromArray:@[@"id", @"email", @"verified_email", @"name", @"given_name", @"family_name", @"link", @"picture", @"gender", @"locale"]];
        mapping.primaryKey = @"email";
    }];
}

@end
