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
    
    command_queue = [device newCommandQueue];
    
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
        id<MTLCommandBuffer> command_buffer = [command_queue commandBuffer];
        MTLRenderPassDescriptor* render_pass_descriptor = [view currentRenderPassDescriptor];
        id<MTLCommandEncoder> command_encoder = [command_buffer renderCommandEncoderWithDescriptor:render_pass_descriptor];
        
        [command_encoder endEncoding];
        [command_buffer presentDrawable:view.currentDrawable];
        [command_buffer commit];
    }
}
@end
