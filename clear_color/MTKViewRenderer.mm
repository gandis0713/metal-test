//
//  MTKViewRenderer.cpp
//  clear_color
//
//  Created by gandis on 2022/07/29.
//

#include "MTKViewRenderer.h"

@implementation MTKViewRenderer
-(void) mtkView:(nonnull MTKView *)view drawableSizeWillChange:(CGSize)size
{
//    NSLog(@"mtkView");
}

-(void) drawInMTKView:(nonnull MTKView *)view
{
//    NSLog(@"drawInMTKView");
    @autoreleasepool
    {
        id<MTLCommandQueue> commandQueue = [view.device newCommandQueue];
        id<MTLCommandBuffer> commandBuffer = [commandQueue commandBuffer];
        MTLRenderPassDescriptor* renderPassDescriptor = [view currentRenderPassDescriptor];
        id<MTLCommandEncoder> commandEncoder = [commandBuffer renderCommandEncoderWithDescriptor:renderPassDescriptor];
        
        [commandEncoder endEncoding];
        [commandBuffer presentDrawable:view.currentDrawable];
        [commandBuffer commit];
    }
}
@end
