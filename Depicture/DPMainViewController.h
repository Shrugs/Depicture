//
//  DPMainViewController.h
//  Depicture
//
//  Created by Matt Condon on 7/11/14.
//  Copyright (c) 2014 Shrugs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPFriendsTableViewController.h"
#import "DPCameraView.h"
#import <AVFoundation/AVFoundation.h>

@interface DPMainViewController : UIViewController <UIGestureRecognizerDelegate>

@property (nonatomic, strong) DPFriendsTableViewController *friendsTableViewController;
@property (nonatomic, strong) DPCameraView *cameraView;
@property (nonatomic, strong) AVCaptureStillImageOutput *cameraOutput;
@property(nonatomic, strong) UIImageView *cameraOutputView;

@end
