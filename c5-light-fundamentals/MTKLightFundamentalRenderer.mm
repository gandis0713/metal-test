///
//  MTKLightFundamentalRenderer.cpp
//  model
//
//  Created by gandis on 2022/07/31.
//

#import "MTKLightFundamentalRenderer.h"

@implementation MTKLightFundamentalRenderer

- (id)initWithDevice:(id<MTLDevice>)_device {
  NSLog(@"MTKLightFundamentalRenderer initWithDevice");

  self = [super init];

  device = _device;

  command_queue = [device newCommandQueue];

  return self;
}

- (void)mtkView:(nonnull MTKView *)view drawableSizeWillChange:(CGSize)size {
  //    NSLog(@"mtkView");
}

- (void)drawInMTKView:(nonnull MTKView *)view {
  //    NSLog(@"drawInMTKView");
}
@end
