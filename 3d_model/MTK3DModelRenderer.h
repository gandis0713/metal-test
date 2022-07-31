//
//  MTK3DModelRenderer.hpp
//  model
//
//  Created by gandis on 2022/07/31.
//

#import <MetalKit/MetalKit.h>

@interface MTK3DModelRenderer : NSViewController<MTKViewDelegate>
{
    id<MTLDevice> device;
    id<MTLCommandQueue> command_queue;
    id<MTLRenderPipelineState> render_pipeline_state;
    MTKMesh* mesh;
}

-(id)initWithDevice:(id<MTLDevice>) device;
-(void)buildShaders;
-(void)buildBuffers;

@end
