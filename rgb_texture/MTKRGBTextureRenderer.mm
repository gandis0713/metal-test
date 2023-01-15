//
//  MTKRGBTextureRenderer.mm
//  rgb_texture
//
//  Created by gandis on 2022/09/04.
//

#import "MTKRGBTextureRenderer.h"


@implementation MTKRGBTextureRenderer

-(id)initWithDevice:(id<MTLDevice>)_device
{
    self = [super init];
    
    device = _device;
    
    command_queue = [device newCommandQueue];
    
    return self;
}

- (void)drawInMTKView:(nonnull MTKView *)view {
    
}

- (void)mtkView:(nonnull MTKView *)view drawableSizeWillChange:(CGSize)size {
    
}



@end
