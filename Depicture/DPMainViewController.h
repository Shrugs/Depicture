//
//  DPMainViewController.h
//  Depicture
//
//  Created by Matt Condon on 7/11/14.
//  Copyright (c) 2014 Shrugs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPFriendsTableViewController.h"
#import "DPSettingsTableViewController.h"
#import <POP/POP.h>
#import "DPDepictureViewController.h"
#import "DPDepicturePreviewView.h"
#import <AVFoundation/AVFoundation.h>

@interface DPMainViewController : UIViewController <UIGestureRecognizerDelegate, POPAnimationDelegate>

typedef enum {
    kDPCameraViewLocationTop,
    kDPCameraViewLocationMiddle,
    kDPCameraViewLocationBottom,
} DPCameraViewLocation;

@property(nonatomic, strong) DPDepicturePreviewView *cameraOutputView;
@property (nonatomic, strong) AVCaptureStillImageOutput *cameraOutput;

@property (nonatomic, strong) DPFriendsTableViewController *friendsTableViewController;
@property (nonatomic, strong) UIView *cameraView;
@property (nonatomic, strong) DPSettingsTableViewController *settingsTableViewController;

-(void)animateCameraViewToTop;
-(void)animateCameraViewToMiddle;
-(void)animateCameraViewToBottom;

-(void)captureImage;
-(void)startCamera;
@end
