//
//  CameraSession.mm
//  camera_to_texture
//
//  Created by gandis on 2022/08/31.
//

#import "CameraSession.h"
#import <dispatch/dispatch.h>

@implementation CameraSession

-(id)initWithDevice:(id<MTLDevice>) device
{
    self = [super init];
    
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        if (granted) {
            //self.microphoneConsentState = PrivacyConsentStateGranted;
        }
        else {
            //self.microphoneConsentState = PrivacyConsentStateDenied;
        }
    }];
    
    captureSession = [[AVCaptureSession alloc] init];
    captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    [captureSession beginConfiguration];
    
    NSError *error;
    captureDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:captureDevice error:&error];
    if(error)
    {
        NSLog(@"Capture Device Input Error : %@" , [error localizedDescription]);
    }
    
    captureVideoDataOutput = [[AVCaptureVideoDataOutput alloc]init];
    
    
    if([captureSession canAddInput:captureDeviceInput])
    {
        [captureSession addInput:captureDeviceInput];
    }
    
    videoSampleBufferDelegate = [[VideoSampleBufferDelegate alloc]init];
    videoSampleBufferDelegate.videoDataOutputQueue = dispatch_queue_create("com.charles.camera", DISPATCH_QUEUE_SERIAL);

    dispatch_set_target_queue(videoSampleBufferDelegate.videoDataOutputQueue, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0));

    videoSampleBufferDelegate.videoConnection = [captureVideoDataOutput connectionWithMediaType:AVMediaTypeVideo];
    
    [captureVideoDataOutput setAlwaysDiscardsLateVideoFrames:(BOOL)true];
    [captureVideoDataOutput setSampleBufferDelegate:videoSampleBufferDelegate queue:videoSampleBufferDelegate.videoDataOutputQueue];
    
    
    if([captureSession canAddOutput:captureVideoDataOutput])
    {
        [captureSession addOutput:captureVideoDataOutput];
    }

    [captureSession commitConfiguration];
    [captureSession startRunning];
    
    CVMetalTextureCacheRef* metalTextureCache = nil;
    CVMetalTextureCacheCreate(kCFAllocatorDefault, nil, device, nil, metalTextureCache);
    
    return self;
}

@end
