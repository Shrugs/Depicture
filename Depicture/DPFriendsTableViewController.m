//
//  DPFriendsTableViewController.m
//  Depicture
//
//  Created by Matt Condon on 7/11/14.
//  Copyright (c) 2014 Shrugs. All rights reserved.
//

#import "DPFriendsTableViewController.h"

@interface DPFriendsTableViewController ()

@end

@implementation DPFriendsTableViewController

@synthesize thisUser;

static NSString *cellIdentifier = @"friendCell";

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // REFRESH CONTROL
        UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
        [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
        [self setRefreshControl:refreshControl];
        
        // LOAD USER
        self.thisUser = [DPUser thisUser];
        
        // CONFIGURE CELL
        [self.tableView registerClass:[DPFriendCell class] forCellReuseIdentifier:cellIdentifier];
    }
    return self;
}

-(void)refresh:(id)sender
{
    NSLog(@"SHOULD REFRESH");
    // End Refreshing
    [(UIRefreshControl *)sender endRefreshing];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // only one section for now
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // return number of friends
    return [self.thisUser.friends count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DPFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = [self.thisUser.friends objectAtIndex:indexPath.row];
    
    return cell;
}




/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/



@end
