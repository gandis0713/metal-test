//
//  VideoSampleBufferDelegate.m
//  camera_to_texture
//
//  Created by gandis on 2022/08/31.
//

#import "VideoSampleBufferDelegate.h"
#import <dispatch/dispatch.h>

@implementation VideoSampleBufferDelegate

- (void)captureOutput:(AVCaptureOutput *)output
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
       fromConnection:(AVCaptureConnection *)connection
{
    NSLog(@"didOutputSampleBuffer");
}
@end
