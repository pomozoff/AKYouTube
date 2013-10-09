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

@end

@implementation AKTableViewController


}
- (void)connectionEstablished {
    [self.tableView reloadData];
}
- (void)connectionDidFailWithError:(NSError *)error {
    NSLog(@"%@ - Connection failed: %@", NSStringFromClass(self.class), error);
}
- (void)appDidFailAuthorize {
    [YTConnector.sharedInstance authorizeAppWithScopesList:nil inLoginViewController:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
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
