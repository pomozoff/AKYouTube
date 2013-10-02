//
//  YTPlaylistObject.m
//  SyncTube
//
//  Created by Антон Помозов on 05.05.13.
//  Copyright (c) 2013 Akademon Ltd. All rights reserved.
//

#import "YTPlaylistObject.h"

@implementation YTPlaylistObject

- (NSString *)description {
    return [NSString stringWithFormat:@"Playlist with title: %@", self.title];
}

@end
