//
//  AKTableViewController.m
//  AKYouTubeExample
//
//  Created by Anton Pomozov on 08.10.13.
//  Copyright (c) 2013 Akademon Ltd. All rights reserved.
//

#import "AKTableViewController.h"
#import "AKConstants.h"

@interface AKTableViewController ()

@property (nonatomic, strong) NSArray *playlists;

@end

@implementation AKTableViewController

#pragma mark - Connector Delegate

}

#pragma mark - Actions

- (IBAction)cancelPressed:(UIBarButtonItem *)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Connector Delegate

- (void)connectionEstablished {
    [self.tableView reloadData];
    NSLog(@"Connection established");
}
- (void)connectionDidFailWithError:(NSError *)error {
    NSLog(@"%@ - Connection failed: %@", NSStringFromClass(self.class), error);
}
- (void)appDidFailAuthorize {
    NSLog(@"App did fail authorize, calling login view controller ...");
    
    [self performSegueWithIdentifier:AKYoutubeSegue sender:self];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.playlists.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSDictionary *sectionObject = [self.playlists objectAtIndex:section];
    NSArray *rows = [sectionObject objectForKey:@"rows"];
    
    return rows.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
