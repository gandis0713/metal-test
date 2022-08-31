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

@interface CameraSession: NSObject<AVCaptureVideoDataOutputSampleBufferDelegate>
{
    AVCaptureSession* captureSession;
    AVCaptureDevice* captureDevice;
    AVCaptureDeviceInput* captureDeviceInput;
    AVCaptureVideoDataOutput* captureVideoDataOutput;
    dispatch_queue_t videoDataOutputQueue;
    AVCaptureConnection *videoConnection;
    CVMetalTextureCacheRef cvMetalTextureCacheRef;
    CVMetalTextureRef cvMetalTextureRef;
    id<MTLDevice> device;
    id<MTLTexture> texture0;
    id<MTLTexture> texture1;
}


-(id)initWithDevice:(id<MTLDevice>) device;
-(id)getMetalTexture0;
-(id)getMetalTexture1;

@end

#endif /* CameraSession_h */
