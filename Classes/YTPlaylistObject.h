//
//  YTPlaylist.h
//  AKYouTubeExample
//
//  Created by Anton Pomozov on 15.10.13.
//  Copyright (c) 2013 Akademon Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YTCommonObject.h"

@interface YTPlaylistObject : YTCommonObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *channelId;
@property (nonatomic, copy) NSString *itemDescription;
@property (nonatomic, copy) NSString *channelTitle;
@property (nonatomic, copy) NSString *defaultUrl;
@property (nonatomic, copy) NSString *mediumUrl;
@property (nonatomic, copy) NSString *highUrl;
@property (nonatomic, copy) NSString *itemId;
@property (nonatomic, strong) NSDate *publishedAt;

@end
