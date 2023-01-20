///
//  MTK3DTransforms.cpp
//  model
//
//  Created by gandis on 2022/07/31.
//

#import "MTK3DTransforms.h"

@implementation MTK3DTransforms

- (id)initWithDevice:(id<MTLDevice>)_device {
  NSLog(@"MTK3DTransforms initWithDevice");

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
