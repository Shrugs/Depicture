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

@synthesize friendsTableViewController, cameraView, cameraOutput, cameraOutputView;

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
    
    // FRIENDS TABLE VIEW CONTROLLER
    self.friendsTableViewController = [[DPFriendsTableViewController alloc] init];
    [self.view addSubview:self.friendsTableViewController.view];
    
    // CAMERA VIEW
    self.cameraView = [[DPCameraView alloc]initWithFrame:self.view.frame];
    self.cameraView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.cameraView];
    
    self.cameraOutputView = [[UIImageView alloc] initWithFrame:self.cameraView.frame];
    
    [self startCamera];
    
    // TAP GESTURE RECOGNIZER
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userDidTapWithGesture:)];
    tapRecognizer.numberOfTapsRequired = 1;
    [self.cameraView addGestureRecognizer:tapRecognizer];
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

-(void)userDidTapWithGesture:(UITapGestureRecognizer *)sender
{
    NSLog(@"USER DID TAP");
    [self captureImage];
}

@end
