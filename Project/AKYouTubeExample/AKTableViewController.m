//
//  AKTableViewController.m
//  AKYouTubeExample
//
//  Created by Anton Pomozov on 08.10.13.
//  Copyright (c) 2013 Akademon Ltd. All rights reserved.
//

#import "AKTableViewController.h"
#import "AKConstants.h"
#import "YTFetcher.h"
#import "YTCommonConnection.h"
#import "YTPlaylistObject.h"

@interface AKTableViewController ()

@property (nonatomic, strong) NSArray *playlists;
@property (nonatomic, assign) BOOL isConnected;
@property (nonatomic, assign) BOOL isFirstAppear;

@end

@implementation AKTableViewController

#pragma mark - Private methods

- (void)refreshTable {
    if (self.isConnected) {
        // TODO: fetch playlists
        [YTFetcher fetchMinePlaylistObjectsWithPart:REQUEST_PART_SNIPPET completion:^(NSArray *playlists, NSError *error) {
            self.playlists = playlists;
            [self.refreshControl endRefreshing];
        }];
    } else {
        [YTConnector.sharedInstance connectWithClientId:AKClientId andClientSecret:AKClientSecret];
        [self.refreshControl endRefreshing];
    }
}

#pragma mark - Properties

- (void)setPlaylists:(NSArray *)playlists {
    _playlists = playlists;
    [self.tableView reloadData];
}

#pragma mark - Actions

- (IBAction)cancelPressed:(UIBarButtonItem *)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"YouTube Login Segue"]) {
        UIViewController<YTLoginViewControllerInterface> *loginController = (UIViewController<YTLoginViewControllerInterface> *)segue.destinationViewController;
        loginController.connector = YTConnector.sharedInstance;
    }
}

#pragma mark - Connector Delegate

- (void)connectionEstablished {
    NSLog(@"Connection established");

    [self.navigationController popViewControllerAnimated:YES];
    [YTConnector.sharedInstance freeLoginViewController];
    
    self.isConnected = YES;
    [self refreshTable];
}
- (void)connectionDidFailWithError:(NSError *)error {
    [YTConnector.sharedInstance freeLoginViewController];
    NSLog(@"%@ - Connection failed: %@", NSStringFromClass(self.class), error);
}
- (void)appDidFailAuthorize {
    NSLog(@"App did fail authorize, push login view controller ...");
    
    [self performSegueWithIdentifier:AKYoutubeSegue sender:self];
}
- (void)userRejectedApp {
    NSLog(@"User rejected app");

    [self.navigationController popViewControllerAnimated:YES];
    [YTConnector.sharedInstance freeLoginViewController];
    
    self.playlists = @[];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.playlists.count == 0 ? 0 : 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.playlists.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Playlist Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    YTPlaylistObject *playlist = self.playlists[indexPath.row];
    cell.textLabel.text = playlist.title;
    cell.detailTextLabel.text = playlist.itemDescription;
    
    return cell;
}

#pragma mark - Lifecycle

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.isFirstAppear) {
        [self refreshTable];
    }

    self.isFirstAppear = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    YTConnector.sharedInstance.delegate = self;

    self.isFirstAppear = YES;
    self.isConnected = NO;
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
