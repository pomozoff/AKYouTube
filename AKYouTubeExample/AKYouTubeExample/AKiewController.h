//
//  AKViewController.h
//  AKYouTubeExample
//
//  Created by Anton Pomozov on 02.10.13.
//  Copyright (c) 2013 Akademon Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTConnector.h"

static NSString *const AKClientId     = @"PASTE-YOUR-CLIENT-ID";
static NSString *const AKClientSecret = @"PASTE-YOUR-CLIENT-SECRET";

@interface AKiewController : UIViewController <YTConnectorDelegate>

@end
