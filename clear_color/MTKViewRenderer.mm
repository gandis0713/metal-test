//
//  MTKViewRenderer.cpp
//  clear_color
//
//  Created by gandis on 2022/07/29.
//

#import "MTKViewRenderer.h"

@implementation MTKViewRenderer

-(id)init
{
    NSLog(@"MTKViewRenderer init");
    
    self = [super init];
    
    return self;
}

-(id)initWithDevice:(id<MTLDevice>)device
{
    NSLog(@"MTKViewRenderer initWithDevice");
    
    self = [super init];

    device = device;
    
    commandQueue = [device newCommandQueue];
    
    return self;
}

-(void)dealloc
{
    NSLog(@"MTKViewRenderer dealloc");
//    [super dealloc];
}

-(void) mtkView:(nonnull MTKView *)view drawableSizeWillChange:(CGSize)size
{
    NSLog(@"mtkView");
}

-(void) drawInMTKView:(nonnull MTKView *)view
{
//    NSLog(@"drawInMTKView");
    @autoreleasepool
    {
        id<MTLCommandBuffer> commandBuffer = [commandQueue commandBuffer];
        MTLRenderPassDescriptor* renderPassDescriptor = [view currentRenderPassDescriptor];
        id<MTLCommandEncoder> commandEncoder = [commandBuffer renderCommandEncoderWithDescriptor:renderPassDescriptor];
        
        [commandEncoder endEncoding];
        [commandBuffer presentDrawable:view.currentDrawable];
        [commandBuffer commit];
    }
}
@end
