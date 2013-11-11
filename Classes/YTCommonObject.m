//
//  YTCommonObject.m
//  SyncTube
//
//  Created by Антон Помозов on 23.07.13.
//  Copyright (c) 2013 Akademon Ltd. All rights reserved.
//

#import "YTCommonObject.h"

@implementation YTCommonObject

- (NSString *)description {
    return [NSString stringWithFormat:@"Object kind is: %@, etag: %@", self.kind, self.etag];
}

@end
