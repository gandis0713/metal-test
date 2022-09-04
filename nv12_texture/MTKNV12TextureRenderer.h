//
//  MTKCameraTextureRenderer.hpp
//  model
//
//  Created by gandis on 2022/08/28.
//

#import <MetalKit/MetalKit.h>
#import "CameraSession.h"

@interface MTKNV12TextureRenderer : NSViewController<MTKViewDelegate>
{
    id<MTLDevice> device;
    id<MTLCommandQueue> command_queue;
    id<MTLRenderPipelineState> render_pipeline_state;
    id<MTLBuffer> vertices;
    id<MTLTexture> texture0;
    id<MTLTexture> texture1;
    CameraSession* cameraSession;
}

-(id)initWithDevice:(id<MTLDevice>) device;
-(void)buildShaders;
-(void)buildBuffers;
-(void)createTexture;

@end
