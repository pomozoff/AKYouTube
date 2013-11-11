//
//  AKResponseYouTubeObject.h
//  AKYouTubeExample
//
//  Created by Антон Помозов on 11.11.13.
//  Copyright (c) 2013 Akademon Ltd. All rights reserved.
//

#import "AKBaseYouTubeObject.h"

@interface AKResponseYouTubeObject : AKBaseYouTubeObject

@property (nonatomic, strong) NSArray *items;
@property (nonatomic, assign) NSUInteger totalResults;
@property (nonatomic, assign) NSUInteger resultsPerPage;

@end
