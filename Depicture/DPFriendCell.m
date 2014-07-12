//
//  DPFriendCell.m
//  ;
//
//  Created by Matt Condon on 7/11/14.
//  Copyright (c) 2014 Shrugs. All rights reserved.
//

#import "DPFriendCell.h"

@implementation DPFriendCell

static DPDepictureViewController *depictureViewController = nil;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code

        // create panRecognizer and tap/doubletap recognizers
        // create views for sending a direct Depicture
        // in panrecognizer, grab reference to the DPDepictureView singleton and instantiate with data
        // also control animations

        UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        [self addGestureRecognizer:panRecognizer];

        
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    // Configure the view for the selected state
}

-(void)handlePan:(UIPanGestureRecognizer *)recognizer
{
    depictureViewController = [DPDepictureViewController sharedDepictureViewController];
    CGFloat translation = [recognizer translationInView:self].x;
    
    // animate as you swipe
    [depictureViewController setTranslation:translation];

    //reset translation
    [recognizer setTranslation:CGPointMake(0, 0) inView:self];

    if (recognizer.state == UIGestureRecognizerStateEnded) {
        CGFloat velocity = [recognizer velocityInView:self].x;
        if (velocity < 0 || translation < -100) {
            [depictureViewController animateDepictureviewToMiddle];
        } else {
            [depictureViewController animateDepictureViewToRight];
        }
    }
}

@end
