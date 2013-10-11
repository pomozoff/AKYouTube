//
//  AKViewController.m
//  AKYouTubeExample
//
//  Created by Anton Pomozov on 02.10.13.
//  Copyright (c) 2013 Akademon Ltd. All rights reserved.
//

#import "AKViewController.h"
#import "AKConstants.h"

static NSString *const AKDefaultsRefreshToken = @"local.domain.AKYouTubeExample.Defaults.RefreshToken";

@interface AKViewController ()

@property (weak, nonatomic) IBOutlet UILabel *status;
@property (nonatomic, assign) BOOL isConnected;

@end

@implementation AKViewController

#pragma mark - Actions

- (IBAction)pressedConnect:(UIButton *)sender {
    self.status.enabled = NO;
    self.status.text = @"Connecting ...";
    
    YTConnector.sharedInstance.delegate = self;
    [YTConnector.sharedInstance connectWithClientId:AKClientId andClientSecret:AKClientSecret];
}

#pragma mark - Connector Delegate

- (void)presentLoginViewControler:(UIViewController<YTLoginViewControllerInterface> *)loginViewController {
    NSLog(@"Presenting default login view controller ...");
    
    loginViewController.shouldPresentCloseButton = YES;
    [self presentViewController:loginViewController animated:YES completion:NULL];
}
- (void)connectionEstablished {
    NSLog(@"Connection established");
    
    self.isConnected = YES;
    self.status.text = @"Connected";
}
- (void)connectionDidFailWithError:(NSError *)error {
    self.status.text = @"Connection error";
    NSLog(@"%@ - Connection failed: %@", NSStringFromClass(self.class), error);
}
- (void)appDidFailAuthorize {
    NSLog(@"App did fail authorize, calling default login view controller ...");
    
    self.status.text = @"Authorizing ...";
    [YTConnector.sharedInstance authorizeAppWithScopesList:nil inLoginViewController:nil];
}
- (void)userRejectedApp {
    [self dismissViewControllerAnimated:YES completion:^{
        self.isConnected = NO;
        self.status.text = @"Rejected";
        
        NSLog(@"User rejected app");
    }];
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
