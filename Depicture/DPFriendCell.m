//
//  DPFriendCell.m
//  ;
//
//  Created by Matt Condon on 7/11/14.
//  Copyright (c) 2014 Shrugs. All rights reserved.
//

#import "DPFriendCell.h"

@implementation DPFriendCell

@synthesize slideView, username;

static DPDepictureViewController *depictureViewController = nil;
static CGRect slideViewHome;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code

        depictureViewController = [DPDepictureViewController sharedDepictureViewController];

        // create panRecognizer and tap/doubletap recognizers
        // create views for sending a direct Depicture
        // in panrecognizer, grab reference to the DPDepictureView singleton and instantiate with data
        // also control animations

        UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        [self addGestureRecognizer:panRecognizer];

        UITapGestureRecognizer *singleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        singleTapRecognizer.numberOfTapsRequired = 1;
        [self addGestureRecognizer:singleTapRecognizer];

        UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        doubleTapRecognizer.numberOfTapsRequired = 2;
        [self addGestureRecognizer:doubleTapRecognizer];

        [singleTapRecognizer requireGestureRecognizerToFail:doubleTapRecognizer];

        slideView = [[UIView alloc] initWithFrame:self.frame];
        slideViewHome = CGRectMake(-1*slideView.frame.size.width,
                                     slideView.frame.origin.y,
                                     slideView.frame.size.width,
                                     slideView.frame.size.height);
        slideView.frame = slideViewHome;
        slideView.backgroundColor = [UIColor purpleColor];

        UILabel *sendDepictureLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, slideView.frame.size.width, slideView.frame.size.height)];
        sendDepictureLabel.text = @"Send Depicture >";
        sendDepictureLabel.textAlignment = NSTextAlignmentRight;
        [slideView addSubview:sendDepictureLabel];

        [self addSubview:slideView];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    // empty to prevent default highlighting, which is ugly af
}

#pragma handlers

-(void)handlePan:(UIPanGestureRecognizer *)recognizer
{
    static float originalX;
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        originalX = [recognizer locationInView:recognizer.view].x;
    }

    CGFloat translation = [recognizer translationInView:self].x;
    
    // animate as you swipe
    [depictureViewController setTranslation:translation];
    [self setSlideViewTranslation:translation];

    //reset translation
    [recognizer setTranslation:CGPointMake(0, 0) inView:self];

    if (recognizer.state == UIGestureRecognizerStateEnded) {
        CGFloat velocity = [recognizer velocityInView:recognizer.view].x;
        CGFloat currX = [recognizer locationInView:recognizer.view].x;
        if (velocity < -1000 || (originalX - currX) > 100) {
            // is swiping left
            // enough of a swipe left to animate depicture view
            [depictureViewController moveDepictureViewToMiddleAnimated:YES];
        } else if (velocity > 1000 || (currX - originalX) > 100) {
            [self triggerDirectDepicture];
        } else if ((originalX - currX) > 0) {
            //reset depicture view animated
            [depictureViewController moveDepictureViewToRightAnimated:YES];
        } else {
            [depictureViewController moveDepictureViewToRightAnimated:NO];
        }
        // reset the slideView regardless
        [self animateSlideViewToLeft];
    }
}

-(void)handleSingleTap:(UITapGestureRecognizer *)recognizer
{
    [depictureViewController moveDepictureViewToMiddleAnimated:YES];
}

-(void)handleDoubleTap:(UITapGestureRecognizer *)recognizer
{
    [self triggerDirectDepicture];
}

-(void)setSlideViewTranslation:(CGFloat)translation
{
    slideView.frame = CGRectMake(slideView.frame.origin.x + translation,
                                 slideView.frame.origin.y,
                                 slideView.frame.size.width,
                                 slideView.frame.size.height);
}

-(void)animateSlideViewToLeft
{
    POPSpringAnimation *anim = [slideView pop_animationForKey:@"animateSlideView"];
    if (!anim) {
        anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
    }
    anim.toValue = [NSValue valueWithCGRect:slideViewHome];
    anim.name = @"animateSlideViewToLeft";
    [slideView pop_addAnimation:anim forKey:@"animateSlideView"];
    // @TODO: trigger direct depicture taking
}

-(void)triggerDirectDepicture
{
    [(DPAppDelegate *)[[UIApplication sharedApplication] delegate] directDepictureToUsername:username];
}

#pragma UIGestureRecognizerDelegate methods
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return NO;
}

@end

















