//
//  DPFriendCell.h
//  Depicture
//
//  Created by Matt Condon on 7/11/14.
//  Copyright (c) 2014 Shrugs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPDepictureViewController.h"
#import <POP/POP.h>
#import "DPAppDelegate.h"

@interface DPFriendCell : UITableViewCell <UIGestureRecognizerDelegate>

@property(nonatomic, strong) UIView *slideView;
@property(nonatomic, strong) NSString *username;

@end
