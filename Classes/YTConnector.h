//
//  YTConnector.h
//  AKYouTube
//
//  Created by Anton Pomozov on 10.09.13.
//  Copyright (c) 2013 Akademon Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YTConnector;

@protocol YTLoginViewControllerInterface <NSObject>

@property (nonatomic, strong, readonly) UIWebView *webView;
@property (nonatomic, assign) BOOL shouldPresentCloseButton;
@property (nonatomic, strong) UIImage *closeButtonImageName;

@end

@protocol YTConnectorDelegate <NSObject>

- (void)presentLoginViewControler:(UIViewController<YTLoginViewControllerInterface> *)loginViewController;
- (void)connectionEstablished;
- (void)connectionDidFailWithError:(NSError *)error;
- (void)appDidFailAuthorize;
- (void)userRejectedApp;

@end

@interface YTConnector : NSObject

@property (nonatomic, weak) id<YTConnectorDelegate> delegate;

+ (YTConnector *)sharedInstance;
- (void)connectWithClientId:(NSString *)clientId andClientSecret:(NSString *)clientSecret;
- (void)authorizeAppWithScopesList:(NSString *)scopesList
             inLoginViewController:(UIViewController<YTLoginViewControllerInterface> *)loginViewController;

@end
