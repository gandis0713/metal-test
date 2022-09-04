//
//  MTKRGBTextureRenderer.h
//  rgb_texture
//
//  Created by gandis on 2022/09/04.
//

#ifndef MTKRGBTextureRenderer_h
#define MTKRGBTextureRenderer_h

#import <MetalKit/MetalKit.h>

@interface MTKRGBTextureRenderer : NSViewController<MTKViewDelegate>
{
    id<MTLDevice> device;
    id<MTLCommandQueue> command_queue;
    id<MTLRenderPipelineState> render_pipeline_state;
    id<MTLBuffer> vertices;
    id<MTLTexture> rgb_texture;
}

-(id)initWithDevice:(id<MTLDevice>) device;

@end

#endif /* MTKRGBTextureRenderer_h */
