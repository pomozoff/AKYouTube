//
//  YTPlaylistObject.h
//  SyncTube
//
//  Created by Антон Помозов on 05.05.13.
//  Copyright (c) 2013 Akademon Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YTCommonObject.h"

@interface YTPlaylistObject : YTCommonObject

@property (nonatomic, copy) NSString *uid;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *descript;
@property (nonatomic, copy) NSString *channelId;
@property (nonatomic, copy) NSString *channelTitle;
@property (nonatomic, strong) NSDate *publishedAt;

@property (nonatomic, copy) NSString *thumbnailUrlDefault;
@property (nonatomic, copy) NSString *thumbnailUrlMedium;
@property (nonatomic, copy) NSString *thumbnailUrlHigh;

@property (nonatomic, strong) UIImage *thumbnailDefault;
@property (nonatomic, strong) UIImage *thumbnailMedium;
@property (nonatomic, strong) UIImage *thumbnailHigh;

@end
