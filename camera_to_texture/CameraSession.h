//
//  CameraSession.h
//  camera_to_texture
//
//  Created by gandis on 2022/08/31.
//

#ifndef CameraSession_h
#define CameraSession_h

#import <MetalKit/MetalKit.h>
#import <CoreVideo/CVMetalTextureCache.h>
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVCaptureInput.h>
#import <AVFoundation/AVCaptureSession.h>
#import <AVFoundation/AVCaptureVideoDataOutput.h>
#import "VideoSampleBufferDelegate.h"

@interface CameraSession: NSObject
{
    VideoSampleBufferDelegate* videoSampleBufferDelegate;
    AVCaptureSession* captureSession;
    AVCaptureDevice* captureDevice;
    AVCaptureDeviceInput* captureDeviceInput;
    AVCaptureVideoDataOutput* captureVideoDataOutput;
}


-(id)initWithDevice:(id<MTLDevice>) device;

@end

#endif /* CameraSession_h */
