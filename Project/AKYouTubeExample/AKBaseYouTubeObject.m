//
//  AKBaseYouTubeObject.m
//  AKYouTubeExample
//
//  Created by Антон Помозов on 11.11.13.
//  Copyright (c) 2013 Akademon Ltd. All rights reserved.
//

#import "AKBaseYouTubeObject.h"

@implementation AKBaseYouTubeObject

- (NSString *)description {
    return [NSString stringWithFormat:@"Object kind is: %@, etag: %@", self.kind, self.etag];
}

@end
