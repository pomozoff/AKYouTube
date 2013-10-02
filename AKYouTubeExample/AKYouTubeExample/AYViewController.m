//
//  AYViewController.m
//  AKYouTubeExample
//
//  Created by Anton Pomozov on 02.10.13.
//  Copyright (c) 2013 Akademon Ltd. All rights reserved.
//

#import "AYViewController.h"

static NSString *const AYDefaultsRefreshToken = @"local.domain.AKYouTubeExample.Defaults.RefreshToken";

@interface AYViewController ()

@property (weak, nonatomic) IBOutlet UILabel *status;

@property (nonatomic, assign) BOOL isConnected;
@property (nonatomic, readonly) NSString *clientId;
@property (nonatomic, readonly) NSString *clientSecret;
@property (nonatomic, readonly) NSString *scopesList;
@property (nonatomic, copy) NSString *refreshToken;

@end

@implementation AYViewController

#pragma mark - Synthesize

@synthesize refreshToken = _refreshToken;

#pragma mark - Actions

- (IBAction)pressedConnect:(UIButton *)sender {
    self.status.enabled = NO;
    
    [AKConnector.sharedInstance connectWithClientId:self.clientId
                                       clientSecret:self.clientSecret
                                         scopesList:self.scopesList
                                       refreshToken:self.refreshToken];
}

#pragma mark - Properties

- (void)setIsConnected:(BOOL)isConnected {
    _isConnected = isConnected;
    self.status.text = isConnected == YES ? @"Connected" : @"Disconected";
}
- (NSString *)clientId {
    return @"PASTE-YOUR-CLIENT_ID";
}
- (NSString *)clientSecret {
    return @"PASTE-YOUR-CLIENT-SECRET";
}
- (NSString *)scopesList {
    return @"https://www.googleapis.com/auth/youtube\
 https://www.googleapis.com/auth/userinfo.profile\
 https://www.googleapis.com/auth/userinfo.email";
}
- (NSString *)refreshToken {
    if (!_refreshToken) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults synchronize];
        
        _refreshToken = [defaults objectForKey:AYDefaultsRefreshToken];
    }
    
    return _refreshToken;
}
- (void)setRefreshToken:(NSString *)refreshToken {
    _refreshToken = refreshToken;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:refreshToken forKey:AYDefaultsRefreshToken];
    [defaults synchronize];
}

#pragma mark - Connector Delegate

- (BOOL)shouldPresentThisLoginViewController:(UIViewController<AKLoginViewControllerInterface> *)loginController {
    return YES;
}
- (void)didUpdateRefreshToken:(NSString *)refreshToken {
    
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
