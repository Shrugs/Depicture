//
//  DPFriendsTableViewController.h
//  Depicture
//
//  Created by Matt Condon on 7/11/14.
//  Copyright (c) 2014 Shrugs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPUser.h"
#import "DPFriendCell.h"
#import "DPDataManager.h"

@interface DPFriendsTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) DPUser *thisUser;

@end
