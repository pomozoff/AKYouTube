//
//  NSData+AKRest.m
//  AKYouTube
//
//  Created by Anton Pomozov on 10.09.13.
//  Copyright (c) 2013 Akademon Ltd. All rights reserved.
//

#import "NSData+AKRest.h"

@implementation NSData (AKRest)

+ (NSData *)dataUseMethodGetWithStringUrl:(NSString *)stringUrl
                             httpResponse:(NSHTTPURLResponse **)response
                                    error:(NSError **)error {
	return [self dataUseMethodGetWithURL:[NSURL URLWithString:stringUrl]
                            httpResponse:response
                                   error:error];
}
+ (NSData *)dataUseMethodGetWithURL:(NSURL *)url
                       httpResponse:(NSHTTPURLResponse **)response
                              error:(NSError **)error {
	return [self dataUseMethod:@"GET"
                       withURL:url
                withParameters:nil
                  httpResponse:response
                         error:error];
}

+ (NSData *)dataUseMethod:(NSString *)method
            withStringUrl:(NSString *)stringUrl
           withParameters:(NSDictionary *)parameters
             httpResponse:(NSHTTPURLResponse **)response
                    error:(NSError **)error {
	return [self dataUseMethod:method
                       withURL:[NSURL URLWithString:stringUrl]
                withParameters:parameters
                  httpResponse:response
                         error:error];
}

+ (NSData *)dataUseMethod:(NSString *)method
                  withURL:(NSURL *)url
           withParameters:(NSDictionary *)parameters
             httpResponse:(NSHTTPURLResponse **)response
                    error:(NSError **)error {
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url
                                                                cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                            timeoutInterval:TIMEOUT_INTERVAL];
	request.HTTPMethod = method;
    
    if ( parameters != nil ) {
        NSMutableString *httpBody = [NSMutableString new];
        
        for ( NSString *key in parameters )
            [httpBody appendFormat:@"%@=%@&", key, parameters[key]];
        
        if ( [method isEqualToString:@"POST"] )
            request.HTTPBody = [httpBody dataUsingEncoding:NSUTF8StringEncoding];
        else {
            NSString *fullUrlString = [NSString stringWithFormat:@"%@?%@",url.absoluteString, httpBody];
            [request setURL:[NSURL URLWithString:fullUrlString]];
        }
    }

	NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&*response error:error];

	return data;
}

@end
