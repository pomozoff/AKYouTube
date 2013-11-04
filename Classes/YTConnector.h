//
//  YTConnector.h
//  AKYouTube
//
//  Created by Anton Pomozov on 10.09.13.
//  Copyright (c) 2013 Akademon Ltd. All rights reserved.
//

@import Foundation;
@import UIKit;

@class YTConnector;

@protocol YTLoginViewControllerInterface <NSObject>

@property (nonatomic, strong, readonly) UIWebView *webView;
@property (nonatomic, weak) YTConnector *connector;

@optional

@property (nonatomic, assign) BOOL shouldPresentCloseButton;
@property (nonatomic, strong) UIImage *closeButtonImage;

@end

@protocol YTConnectorDelegate <NSObject>

@optional

- (void)connectionEstablished;
- (void)connectionDidFailWithError:(NSError *)error;
- (void)appDidFailAuthorize;
- (void)presentLoginViewControler:(UIViewController<YTLoginViewControllerInterface> *)loginViewController;
- (void)userRejectedApp;

@end

@interface YTConnector : NSObject

@property (nonatomic, weak) id<YTConnectorDelegate> delegate;
@property (nonatomic, copy, readonly) NSString *accessToken;

+ (instancetype)sharedInstance;
- (void)connectWithClientId:(NSString *)clientId andClientSecret:(NSString *)clientSecret;
- (void)authorizeAppWithScopesList:(NSString *)scopesList
             inLoginViewController:(UIViewController<YTLoginViewControllerInterface> *)loginViewController;
- (void)freeLoginViewController;
- (void)fetchPlaylistsCompletion:(void (^)(NSArray *playlists, NSError *error))completion;
- (void)fetchChannelsCompletion:(void (^)(NSArray *channels, NSError *error))completion;

@end
