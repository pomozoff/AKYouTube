//
//  AKViewController.m
//  AKYouTubeExample
//
//  Created by Anton Pomozov on 02.10.13.
//  Copyright (c) 2013 Akademon Ltd. All rights reserved.
//

#import "AKiewController.h"

static NSString *const AKDefaultsRefreshToken = @"local.domain.AKYouTubeExample.Defaults.RefreshToken";

@interface AKiewController ()

@property (weak, nonatomic) IBOutlet UILabel *status;

@property (nonatomic, assign) BOOL isConnected;
@property (nonatomic, readonly) NSString *clientId;
@property (nonatomic, readonly) NSString *clientSecret;

@end

@implementation AKiewController

#pragma mark - Actions

- (IBAction)pressedConnect:(UIButton *)sender {
    self.status.enabled = NO;
    
    YTConnector.sharedInstance.delegate = self;
    [YTConnector.sharedInstance connectWithClientId:self.clientId andClientSecret:self.clientSecret];
}

#pragma mark - Properties

- (void)setIsConnected:(BOOL)isConnected {
    _isConnected = isConnected;
    self.status.text = isConnected == YES ? @"Connected" : @"Disconected";
}
- (NSString *)clientId {
    return @"PASTE-YOUR-CLIENT-ID";
}
- (NSString *)clientSecret {
    return @"PASTE-YOUR-CLIENT-SECRET";
}

#pragma mark - Connector Delegate

- (void)presentLoginViewControler:(UIViewController<YTLoginViewControllerInterface> *)loginViewController {
    loginViewController.shouldPresentCloseButton = YES;
    [self presentViewController:loginViewController animated:YES completion:NULL];
}
- (void)connectionEstablished {
    self.isConnected = YES;
}
- (void)connectionDidFailWithError:(NSError *)error {
    NSLog(@"%@ - Connection failed: %@", NSStringFromClass(self.class), error);
}
- (void)appDidFailAuthorize {
    [YTConnector.sharedInstance authorizeAppWithScopesList:nil inLoginViewController:nil];
}

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isConnected = NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end