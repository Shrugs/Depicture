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

static int yOffset = 100;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {

        // START LOADING USERS
        [[DPDataManager sharedDataManager] getUserFriendsWithBlock:^(NSArray *friends, NSError *error) {
            [self.tableView reloadData];
        }];

        // REFRESH CONTROL
        UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
        [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
        [self setRefreshControl:refreshControl];
        
        // LOAD USER
        thisUser = [[DPDataManager sharedDataManager] thisUser];
        
        // CONFIGURE CELL
        [self.tableView registerClass:[DPFriendCell class] forCellReuseIdentifier:cellIdentifier];
        
        // ADD FRAME OFFSET
        self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, [UIScreen mainScreen].bounds.size.height-yOffset);
    }
    return self;
}

-(void)refresh:(id)sender
{
    [self.tableView reloadData];
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
    return [thisUser.friends count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DPFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = [(DPUser *)[thisUser.friends objectAtIndex:indexPath.row] username];
    
    return cell;
}



/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/



@end
