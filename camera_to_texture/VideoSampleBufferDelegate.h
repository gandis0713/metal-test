//
//  VideoSampleBufferDelegate.h
//  camera_to_texture
//
//  Created by gandis on 2022/08/31.
//

#ifndef VideoSampleBufferDelegate_h
#define VideoSampleBufferDelegate_h

#import <CoreVideo/CVMetalTextureCache.h>
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVCaptureInput.h>
#import <AVFoundation/AVCaptureSession.h>
#import <AVFoundation/AVCaptureVideoDataOutput.h>

@interface VideoSampleBufferDelegate: NSObject<AVCaptureVideoDataOutputSampleBufferDelegate>

@property (nonatomic, strong) dispatch_queue_t videoDataOutputQueue;

@property (nonatomic, strong) AVCaptureVideoDataOutput *videoDataOutput;

@property (nonatomic, strong) AVCaptureConnection *videoConnection;

@end

#endif /* VideoSampleBufferDelegate_h */
