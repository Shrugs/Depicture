//
//  DPDepictureViewController.m
//  Depicture
//
//  Created by Matt Condon on 7/12/14.
//  Copyright (c) 2014 Shrugs. All rights reserved.
//

#import "DPDepictureViewController.h"

@interface DPDepictureViewController ()

@end

@implementation DPDepictureViewController

@synthesize translation = _translation;
@synthesize viewLocation;

static DPDepictureViewController *_depictureViewController = nil;
static CGFloat originalX;
static CGRect originalFrame;


+(DPDepictureViewController *)sharedDepictureViewController
{
    if (!_depictureViewController) {
        _depictureViewController = [[DPDepictureViewController alloc] initWithNibName:nil bundle:nil];
    }
    return _depictureViewController;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        // start position should be off screen right
        originalX = screenSize.width;
        originalFrame = CGRectMake(screenSize.width,
                                     self.view.frame.origin.y,
                                     screenSize.width,
                                     screenSize.height);
        self.view.frame = originalFrame;
        [self.view setBackgroundColor:[UIColor blueColor]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    panRecognizer.delegate = self;
    [self.view addGestureRecognizer:panRecognizer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma animation

-(void)setTranslation:(CGFloat)translation
{
    _translation = translation;
    // Update view frame based on translation delta from original x coord
    self.view.frame = CGRectMake(self.view.frame.origin.x + translation,
                                 self.view.frame.origin.y,
                                 self.view.frame.size.width,
                                 self.view.frame.size.height);
}


-(void)moveDepictureViewToRightAnimated:(BOOL)animated
{
    if (!animated) {
        self.view.frame = originalFrame;
        return;
    }
    POPSpringAnimation *anim = [self.view pop_animationForKey:@"animateDepictureView"];
    if (!anim) {
        anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
    }
    anim.toValue = [NSValue valueWithCGRect:originalFrame];
    anim.delegate = self;
    anim.name = @"animateDepictureViewToRight";
    [self.view pop_addAnimation:anim forKey:@"animateDepictureView"];
}

-(void)moveDepictureViewToMiddleAnimated:(BOOL)animated
{
    POPSpringAnimation *anim = [self.view pop_animationForKey:@"animateDepictureView"];
    if (!anim) {
        anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
    }
    anim.toValue = [NSValue valueWithCGRect:CGRectMake(0,
                                                       self.view.frame.origin.y,
                                                       self.view.frame.size.width,
                                                       self.view.frame.size.height)];
    anim.delegate = self;
    anim.name = @"animateDepictureViewToMiddle";
    [self.view pop_addAnimation:anim forKey:@"animateDepictureView"];
}

- (void)pop_animationDidStop:(POPAnimation *)anim finished:(BOOL)finished
{
    if ([anim.name isEqualToString:@"animateDepictureViewToRight"]) {
        // @TODO: PAUSE
        NSLog(@"WOULD PAUSE DPExplodeView");
        viewLocation = kDPDepictureViewLocationRight;
    } else if ([anim.name isEqualToString:@"animateDepictureViewToMiddle"]) {
        // @TODO: ANIMATE IN
        NSLog(@"WOULD PRESENT DEPICTURE");
        viewLocation = kDPDepictureViewLocationMiddle;
    }
}

-(void)handlePan:(UIPanGestureRecognizer *)recognizer
{
    CGFloat translation = [recognizer translationInView:self.view].x;

    // animate as you swipe
    [self setTranslation:translation];

    [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];

    if (recognizer.state == UIGestureRecognizerStateEnded) {
        CGFloat velocity = [recognizer velocityInView:self.view].x;
        if (velocity < 0) {
            [self moveDepictureViewToMiddleAnimated:YES];
        } else {
            [self moveDepictureViewToRightAnimated:YES];
        }
    }
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch locationInView:self.view].x < 15) {
        return YES;
    }
    return NO;
}

@end









