//
//  CameraSession.mm
//  camera_to_texture
//
//  Created by gandis on 2022/08/31.
//

#import "CameraSession.h"
#import <dispatch/dispatch.h>
#import <CoreFoundation/CoreFoundation.h>
#import <Metal/Metal.h>
//#import <CoreVideo/CoreVideoCVPixelBuffer.h>

@implementation CameraSession

-(id)initWithDevice:(id<MTLDevice>) devices
{
    self = [super init];
    
    device = devices;
    
//    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
//        if (granted) {
//            //self.microphoneConsentState = PrivacyConsentStateGranted;
//        }
//        else {
//            //self.microphoneConsentState = PrivacyConsentStateDenied;
//        }
//    }];
    
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
    
    videoDataOutputQueue = dispatch_queue_create("com.charles.camera", DISPATCH_QUEUE_SERIAL);

    dispatch_set_target_queue(videoDataOutputQueue, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0));

//    videoConnection = [captureVideoDataOutput connectionWithMediaType:AVMediaTypeVideo];
    
    [captureVideoDataOutput setAlwaysDiscardsLateVideoFrames:(BOOL)true];
    
    // https://stackoverflow.com/questions/46549906/cvmetaltexturecachecreatetexturefromimage-returns-6660-on-macos-10-13
    captureVideoDataOutput.videoSettings = @{
        (NSString *)kCVPixelBufferMetalCompatibilityKey: @YES
    };
    
    [captureVideoDataOutput setSampleBufferDelegate:self queue:videoDataOutputQueue];
    
    if([captureSession canAddOutput:captureVideoDataOutput])
    {
        [captureSession addOutput:captureVideoDataOutput];
    }

    [captureSession commitConfiguration];
    [captureSession startRunning];
    

    return self;
}

- (void)captureOutput:(AVCaptureOutput *)output
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
       fromConnection:(AVCaptureConnection *)connection
{
//    NSLog(@"didOutputSampleBuffer");

    CVReturn result = CVMetalTextureCacheCreate(kCFAllocatorDefault, nil, device, nil, &cvMetalTextureCacheRef);
    if(result != kCVReturnSuccess)
    {
        NSLog(@"CVMetalTextureCacheCreate result : %d", result);
    }

    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);

    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    size_t planeCount = CVPixelBufferGetPlaneCount(imageBuffer);
//    NSLog(@"CVImageBufferRef: ");
//    NSLog(@"    planeCount: %ld", planeCount);
    
//    MTLPixelFormat pixelFormat = MTLPixelFormatBGRA8Unorm_sRGB;
    MTLPixelFormat pixelFormat = MTLPixelFormatR8Unorm_sRGB;
//    MTLPixelFormat pixelFormat = MTLPixelFormatRG8Unorm_sRGB;
//    MTLPixelFormat pixelFormat = MTLPixelFormatRGBA8Unorm_sRGB;
//    MTLPixelFormat pixelFormat = MTLPixelFormatBGRG422;
//    MTLPixelFormat pixelFormat = MTLPixelFormatGBGR422;
    
    result = CVMetalTextureCacheCreateTextureFromImage(kCFAllocatorDefault, cvMetalTextureCacheRef, imageBuffer, nil, MTLPixelFormatR8Unorm_sRGB, width, height, 0, &cvMetalTextureRef);
    if(result != kCVReturnSuccess)
    {
        NSLog(@"CVMetalTextureCacheCreateTextureFromImage 0 result : %d", result);
    }
    texture0 = CVMetalTextureGetTexture(cvMetalTextureRef);
    
    result = CVMetalTextureCacheCreateTextureFromImage(kCFAllocatorDefault, cvMetalTextureCacheRef, imageBuffer, nil, MTLPixelFormatRG8Unorm_sRGB, width, height, 1, &cvMetalTextureRef);
    if(result != kCVReturnSuccess)
    {
        NSLog(@"CVMetalTextureCacheCreateTextureFromImage 1 result : %d", result);
    }
    texture1 = CVMetalTextureGetTexture(cvMetalTextureRef);
    
    // memory leak
    CFRelease(cvMetalTextureCacheRef);
    CVBufferRelease( cvMetalTextureRef );
    
//    NSLog(@"texture: ");
//    NSLog(@"    width: %ld", [texture width]);
//    NSLog(@"    height: %ld", [texture height]);
//    NSLog(@"    depth: %ld", [texture depth]);
//    NSLog(@"    pixelFormat: %ld", [texture pixelFormat]);
}

-(id) getMetalTexture0
{
    return texture0;
}

-(id) getMetalTexture1
{
    return texture1;
}
@end
