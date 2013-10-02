//
//  NSData+AKRest.h
//  AKYouTube
//
//  Created by Anton Pomozov on 10.09.13.
//  Copyright (c) 2013 Akademon Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

#define TIMEOUT_INTERVAL 30.0f

@interface NSData (AKRest)

+ (NSData *)dataUseMethodGetWithStringUrl:(NSString *)stringUrl
                             httpResponse:(NSHTTPURLResponse **)response
                                    error:(NSError **)error;
+ (NSData *)dataUseMethodGetWithURL:(NSURL *)url
                       httpResponse:(NSHTTPURLResponse **)response
                              error:(NSError **)error;

+ (NSData *)dataUseMethod:(NSString *)method
            withStringUrl:(NSString *)stringUrl
           withParameters:(NSDictionary *)parameters
             httpResponse:(NSHTTPURLResponse **)response
                    error:(NSError **)error;
+ (NSData *)dataUseMethod:(NSString *)method
                  withURL:(NSURL *)url
           withParameters:(NSDictionary *)parameters
             httpResponse:(NSHTTPURLResponse **)response
                    error:(NSError **)error;

@end
