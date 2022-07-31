//
//  MTKModelRenderer.hpp
//  model
//
//  Created by gandis on 2022/07/31.
//

#import <MetalKit/MetalKit.h>

@interface MTKModelRenderer : NSViewController<MTKViewDelegate>
{
    id<MTLDevice> device;
    id<MTLCommandQueue> command_queue;
    id<MTLRenderPipelineState> render_pipeline_state;
//    id<MTLBuffer> vertex_position_buffer;
//    id<MTLBuffer> vertex_color_buffer;
    MTKMesh* mesh;
}

-(id)initWithDevice:(id<MTLDevice>) device;
-(void)buildShaders;
-(void)buildBuffers;

@end
