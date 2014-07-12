//
//  DPMainViewController.m
//  Depicture
//
//  Created by Matt Condon on 7/11/14.
//  Copyright (c) 2014 Shrugs. All rights reserved.
//

#import "DPMainViewController.h"

@interface DPMainViewController ()

@end

@implementation DPMainViewController

@synthesize friendsTableViewController, cameraView, cameraOutput, cameraOutputView, settingsTableViewController;

static int yOffset = 100;
static BOOL friendsInView = YES;
static DPCameraViewLocation cameraViewLocation = kDPCameraViewLocationMiddle;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    // SETTINGS VIEW CONTROLLER
    // -> Added before to avoid a call to bringSubviewToFront
    self.settingsTableViewController = [[DPSettingsTableViewController alloc] init];
    [self.view addSubview:self.settingsTableViewController.view];
    
    // FRIENDS TABLE VIEW CONTROLLER
    self.friendsTableViewController = [[DPFriendsTableViewController alloc] init];
    [self.view addSubview:self.friendsTableViewController.view];
    
    // CAMERA VIEW
    self.cameraView = [[DPCameraView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:self.cameraView];
    
    self.cameraOutputView = [[UIImageView alloc] initWithFrame:self.cameraView.frame];
    
    [self startCamera];

    // DEPICTURE VIEW
    DPDepictureViewController *dpvc = [DPDepictureViewController sharedDepictureViewController];
    [self.view addSubview:dpvc.view];
    
    // TAP GESTURE RECOGNIZER
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userDidTapWithGesture:)];
    tapRecognizer.numberOfTapsRequired = 1;
    [self.cameraView addGestureRecognizer:tapRecognizer];
    
    // PAN GESTURE RECOGNIZER
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self.cameraView addGestureRecognizer:panRecognizer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma camera
-(void)startCamera
{
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
	session.sessionPreset = AVCaptureSessionPresetHigh;
	
	AVCaptureVideoPreviewLayer *captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
	
	captureVideoPreviewLayer.frame = self.cameraView.frame;
	[self.cameraView.layer addSublayer:captureVideoPreviewLayer];
	
	AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
	
	NSError *error = nil;
	AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
	if (!input) {
		// Handle the error appropriately.
		NSLog(@"ERROR: trying to open camera: %@", error);
	}
	[session addInput:input];
    
    self.cameraOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys: AVVideoCodecJPEG, AVVideoCodecKey, nil];
    [self.cameraOutput setOutputSettings:outputSettings];
    
    [session addOutput:self.cameraOutput];
	
	[session startRunning];
}

-(void)captureImage
{
    AVCaptureConnection *videoConnection = nil;
	for (AVCaptureConnection *connection in cameraOutput.connections) {
		for (AVCaptureInputPort *port in [connection inputPorts]) {
			if ([[port mediaType] isEqual:AVMediaTypeVideo] ) {
				videoConnection = connection;
				break;
			}
		}
		if (videoConnection) {
            break;
        }
	}
	
	[cameraOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler: ^(CMSampleBufferRef imageSampleBuffer, NSError *error)
     {
//		 CFDictionaryRef exifAttachments = CMGetAttachment( imageSampleBuffer, kCGImagePropertyExifDictionary, NULL);
//		 if (exifAttachments)
//		 {
//             // Do something with the attachments.
//             NSLog(@"attachements: %@", exifAttachments);
//		 }
//         else
//             NSLog(@"no attachments");
         
         NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
         UIImage *image = [[UIImage alloc] initWithData:imageData];
         
         self.cameraOutputView.image = image;
         [self.cameraView addSubview:self.cameraOutputView];
         [self.view bringSubviewToFront:self.cameraOutputView];
	 }];
}

#pragma display stack

-(void)bringFriendsToFront
{
    // @TODO: Fade and Scale in view
    [self.view insertSubview:self.friendsTableViewController.view aboveSubview:self.settingsTableViewController.view];\
    friendsInView = NO;
}

-(void)bringSettingsToFront
{
    // @TODO: Fade and Scale in view
    [self.view insertSubview:self.settingsTableViewController.view aboveSubview:self.friendsTableViewController.view];
    friendsInView = YES;
}

#pragma gestures

-(void)userDidTapWithGesture:(UITapGestureRecognizer *)sender
{
    switch (cameraViewLocation) {
        case kDPCameraViewLocationTop:
        case kDPCameraViewLocationBottom:
            [self animateCameraViewToMiddle];
            break;
        case kDPCameraViewLocationMiddle:
        default:
            [self captureImage];
    }
}

- (void)handlePan:(UIPanGestureRecognizer *)recognizer {
    static int originalY = 0;
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        originalY = self.cameraView.frame.origin.y;
    }

    // @TODO: determine if self.view or self.cameraView (i.e., does the translation change if the target layer moves with the translation?)
    CGPoint translation = [recognizer translationInView:self.view];
    recognizer.view.center = CGPointMake(recognizer.view.center.x,
                                         recognizer.view.center.y + translation.y);
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
    
    // UPDATE SUBVIEWS BELOW CAMERA VIEW
    
    if (friendsInView && recognizer.view.frame.origin.y < self.view.frame.origin.y) {
        [self bringFriendsToFront];
    } else if (!friendsInView && recognizer.view.frame.origin.y > self.view.frame.origin.y) {
        [self bringSettingsToFront];
    }

    if (recognizer.state == UIGestureRecognizerStateEnded) {
        if (originalY == 0) {
            CGFloat velocity = [recognizer velocityInView:self.view].y;
            if (velocity < 0) {
                // is negative, up
                [self animateCameraViewToTop];
            } else {
                [self animateCameraViewToBottom];
            }
        } else {
            [self animateCameraViewToMiddle];
        }
    }
    
}

#pragma animations

-(void)animateCameraViewToTop
{
    [self bringSettingsToFront];
    POPSpringAnimation *anim = [self.cameraView pop_animationForKey:@"animateCameraView"];
    if (!anim) {
        anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
    }
    anim.toValue = [NSValue valueWithCGRect:CGRectMake(self.cameraView.frame.origin.x,
                                -1.*(self.cameraView.frame.size.height-yOffset),
                                self.cameraView.frame.size.width,
                                self.cameraView.frame.size.height)];
    anim.delegate = self;
    anim.name = @"animateCameraViewToTop";
    [self.cameraView pop_addAnimation:anim forKey:@"animateCameraView"];
}

-(void)animateCameraViewToMiddle
{
    POPSpringAnimation *anim = [self.cameraView pop_animationForKey:@"animateCameraView"];
    if (!anim) {
        anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
    }
    anim.toValue = [NSValue valueWithCGRect:CGRectMake(self.cameraView.frame.origin.x,
                                                       0,
                                                       self.cameraView.frame.size.width,
                                                       self.cameraView.frame.size.height)];
    anim.delegate = self;
    anim.name = @"animateCameraViewToMiddle";
    [self.cameraView pop_addAnimation:anim forKey:@"animateCameraView"];
}

-(void)animateCameraViewToBottom
{
    [self bringFriendsToFront];
    POPSpringAnimation *anim = [self.cameraView pop_animationForKey:@"animateCameraView"];
    if (!anim) {
        anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
    }
    anim.toValue = [NSValue valueWithCGRect:CGRectMake(self.cameraView.frame.origin.x,
                                                       self.cameraView.frame.size.height - yOffset,
                                                       self.cameraView.frame.size.width,
                                                       self.cameraView.frame.size.height)];
    anim.delegate = self;
    anim.name = @"animateCameraViewToBottom";
    [self.cameraView pop_addAnimation:anim forKey:@"animateCameraView"];
}

- (void)pop_animationDidStop:(POPAnimation *)anim finished:(BOOL)finished
{
    if ([anim.name isEqualToString:@"animateCameraViewToTop"]) {
        cameraViewLocation = kDPCameraViewLocationTop;
    } else if ([anim.name isEqualToString:@"animateCameraViewToMiddle"]) {
        cameraViewLocation = kDPCameraViewLocationMiddle;
    } else if ([anim.name isEqualToString:@"animateCameraViewToBottom"]) {
        cameraViewLocation = kDPCameraViewLocationBottom;
    }
}

@end












