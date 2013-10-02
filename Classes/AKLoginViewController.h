//
//  AKLoginViewController.h
//  AKYouTube
//
//  Created by Anton Pomozov on 10.09.13.
//  Copyright (c) 2013 Akademon Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AKLoginDelegate <NSObject>

- (void)didReceiveAuthCode:(NSString *)authCode;

@end

@protocol AKLoginViewControllerInterface <NSObject>

@property (nonatomic, strong) NSURLRequest *loginUrl;
@property (nonatomic, weak, readonly) UIWebView *webView;
@property (nonatomic, weak) id<AKLoginDelegate> loginDelegate;

@end

@interface AKLoginViewController : UIViewController <UIWebViewDelegate, AKLoginViewControllerInterface>

@end
