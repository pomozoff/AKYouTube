//
//  AKViewController.m
//  AKYouTubeExample
//
//  Created by Anton Pomozov on 02.10.13.
//  Copyright (c) 2013 Akademon Ltd. All rights reserved.
//

#import "AKiewController.h"
#import "AKConstants.h"

static NSString *const AKDefaultsRefreshToken = @"local.domain.AKYouTubeExample.Defaults.RefreshToken";

@interface AKiewController ()

@property (weak, nonatomic) IBOutlet UILabel *status;

@property (nonatomic, assign) BOOL isConnected;

@end

@implementation AKiewController

#pragma mark - Actions

- (IBAction)pressedConnect:(UIButton *)sender {
    self.status.enabled = NO;
    self.status.text = @"Connecting ...";
    
    YTConnector.sharedInstance.delegate = self;
    [YTConnector.sharedInstance connectWithClientId:AKClientId andClientSecret:AKClientSecret];
}

#pragma mark - Properties

#pragma mark - Connector Delegate

- (void)presentLoginViewControler:(UIViewController<YTLoginViewControllerInterface> *)loginViewController {
    loginViewController.shouldPresentCloseButton = YES;
    [self presentViewController:loginViewController animated:YES completion:NULL];
}
- (void)connectionEstablished {
    self.isConnected = YES;
    self.status.text = @"Connected";
}
- (void)connectionDidFailWithError:(NSError *)error {
    self.status.text = @"Connection error";
    NSLog(@"%@ - Connection failed: %@", NSStringFromClass(self.class), error);
}
- (void)appDidFailAuthorize {
    self.status.text = @"Authorizing ...";
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
