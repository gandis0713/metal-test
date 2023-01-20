///
//  Renderer.cpp
//  model
//
//  Created by gandis on 2023/01/19.
//

#import "Renderer.h"

@implementation Renderer

//- (id)initWithDevice:(id<MTLDevice>)_device {
//  NSLog(@"Renderer initWithDevice");
//
//  self = [super init];
//
//  device = _device;
//
//  command_queue = [device newCommandQueue];
//
//  return self;
//}

- (id)initWithView:(MTKView*)_view {
    NSLog(@"Renderer initWithDevice");

    self = [super init];

    device = MTLCreateSystemDefaultDevice();

    command_queue = [device newCommandQueue];
    
    _view.device = device;
    _view.delegate = self;
    _view.colorPixelFormat = MTLPixelFormatBGRA8Unorm_sRGB;
    _view.clearColor = MTLClearColorMake(0.0, 0.0, 0.0, 1.0);

    return self;
}

- (void)mtkView:(nonnull MTKView *)view drawableSizeWillChange:(CGSize)size {
      NSLog(@"Renderer mtkView");
}

- (void)drawInMTKView:(nonnull MTKView *)view {
      NSLog(@"Renderer drawInMTKView");
}
@end

