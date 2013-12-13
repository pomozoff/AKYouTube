//
//  YTCommon.m
//  AKYouTubeExample
//
//  Created by Anton Pomozov on 14.10.13.
//  Copyright (c) 2013 Akademon Ltd. All rights reserved.
//

#import "YTCommon.h"
#import "NSData+AKRest.h"

@implementation YTCommon

+ (NSString *)makeOptionsListFromOptions:(NSDictionary *)options {
    __block NSMutableArray *optionsArray = [NSMutableArray array];
    
    [options enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [optionsArray addObject:[NSString stringWithFormat:@"%@=%@", key, obj]];
    }];
    
    return [optionsArray componentsJoinedByString:@"&"];
}
+ (NSDictionary *)jsonAnswerForRequestMethod:(YTRestMethod)method
                               withUrlString:(NSString *)urlString
                              withParameters:(NSDictionary *)parameters
                                  responseIs:(NSHTTPURLResponse **)response
                                     errorIs:(NSError **)error {
    NSString *methodString;
    switch (method) {
        case YT_REST_METHOD_GET:
            methodString = @"GET";
            break;
        case YT_REST_METHOD_POST:
            methodString = @"POST";
            break;
            
        default:
            break;
    }
    
    NSData *data = [NSData dataUseMethod:methodString
                           withStringUrl:urlString
                          withParameters:parameters
                            httpResponse:response
                                   error:error];
    
    NSDictionary *jsonAnswer;
    if ( !(*error) ) {
        jsonAnswer = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:error];

        //NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        //NSLog(@"Response is:\n%@", jsonString);
    }
    
    return jsonAnswer;
}

@end
