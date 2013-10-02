//
//  YTMappingProvider.h
//  SyncTube
//
//  Created by Антон Помозов on 05.05.13.
//  Copyright (c) 2013 Akademon Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EasyMapping.h"

@interface YTMappingProvider : NSObject

+ (EKObjectMapping *)responsePlaylistsMapping;
+ (EKObjectMapping *)responseChannelsMapping;
+ (EKManagedObjectMapping *)userMapping;

@end
