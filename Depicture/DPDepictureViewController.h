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

+(DPDepictureViewController *)sharedDepictureViewController;
-(void)animateDepictureViewToRight;
-(void)animateDepictureviewToMiddle;

@property (nonatomic, assign) CGFloat translation;

@end
