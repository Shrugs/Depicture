//
//  DPDepictureViewController.h
//  Depicture
//
//  Created by Matt Condon on 7/12/14.
//  Copyright (c) 2014 Shrugs. All rights reserved.
//

#import "DPExplodedViewController.h"
#import <POP/POP.h>

@interface DPDepictureViewController : DPExplodedViewController
<POPAnimationDelegate, UIGestureRecognizerDelegate>

typedef enum {
    kDPDepictureViewLocationRight,
    kDPDepictureViewLocationMiddle,
} DPDepictureViewLocation;

+(DPDepictureViewController *)sharedDepictureViewController;
-(void)moveDepictureViewToRightAnimated:(BOOL)animated;
-(void)moveDepictureViewToMiddleAnimated:(BOOL)animated;

@property (nonatomic, assign) CGFloat translation;
@property (nonatomic, assign) DPDepictureViewLocation viewLocation;

@end
