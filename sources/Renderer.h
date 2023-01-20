//
//  Renderer.h
//  model
//
//  Created by gandis on 2023/01/19.
//

#import <MetalKit/MetalKit.h>

@interface Renderer : NSViewController <MTKViewDelegate> {
  id<MTLDevice> device;
  id<MTLCommandQueue> command_queue;
  id<MTLRenderPipelineState> render_pipeline_state;
  MTKMesh *mesh;
}

//- (id)initWithDevice:(id<MTLDevice>)device;
- (id)initWithView:(MTKView*)view;

@end
