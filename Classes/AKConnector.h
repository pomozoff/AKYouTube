//
//  AKYouTube.h
//  AKYouTube
//
//  Created by Anton Pomozov on 10.09.13.
//  Copyright (c) 2013 Akademon Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AKLoginViewController.h"

@class AKConnector;

@protocol AKConnectorDelegate <NSObject>

- (BOOL)shouldPresentThisLoginViewController:(UIViewController<AKLoginViewControllerInterface> *)loginController;

@optional

- (void)didUpdateAccessToken;
- (void)didUpdateRefreshToken:(NSString *)refreshToken;
- (void)connectionFailedWithError:(NSError *)error;

@end

@interface AKConnector : NSObject <AKLoginDelegate>

@property (nonatomic, weak) id<AKConnectorDelegate> delegate;

+ (AKConnector *)sharedInstance;

- (void)useCustomLoginViewController:(UIViewController *)loginViewController;

- (void)connectWithClientId:(NSString *)clientId
               clientSecret:(NSString *)clientSecret
                 scopesList:(NSString *)scopesList
               refreshToken:(NSString *)refreshToken;
- (void)fetchChannelsWithRefreshToken:(NSString *)refreshToken;

@end
