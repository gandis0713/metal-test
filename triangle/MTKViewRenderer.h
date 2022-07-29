//
//  MTKViewRenderer.hpp
//  clear_color
//
//  Created by gandis on 2022/07/29.
//

//#pragma once

#import <MetalKit/MetalKit.h>

@interface MTKViewRenderer : NSViewController<MTKViewDelegate>
{
    id<MTLDevice> device;
    id<MTLCommandQueue> command_queue;
    id<MTLRenderPipelineState> render_pipeline_state;
    id<MTLBuffer> vertex_position_buffer;
    id<MTLBuffer> vertex_color_buffer;
}

-(id)initWithDevice:(id<MTLDevice>) device;
-(void)buildShaders;
-(void)buildBuffers;

@end
