//
//  YTCommonObject.h
//  SyncTube
//
//  Created by Антон Помозов on 23.07.13.
//  Copyright (c) 2013 Akademon Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YTCommonObject : NSObject

@property (nonatomic, copy) NSString *etag;
@property (nonatomic, copy) NSString *kind;

@end
