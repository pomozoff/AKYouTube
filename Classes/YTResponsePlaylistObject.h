//
//  YTResponseObject.h
//  SyncTube
//
//  Created by Антон Помозов on 05.05.13.
//  Copyright (c) 2013 Akademon Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YTCommonObject.h"

@interface YTResponsePlaylistObject : YTCommonObject

@property (nonatomic, strong) NSArray *items;
@property (nonatomic, assign) NSUInteger totalResults;
@property (nonatomic, assign) NSUInteger resultsPerPage;

@end
