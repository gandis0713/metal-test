///
//  MTK3DTransformRenderer.cpp
//  model
//
//  Created by gandis on 2022/07/31.
//

#import "MTK3DTransformRenderer.h"

@implementation MTK3DTransformRenderer

- (void)mtkView:(nonnull MTKView *)view drawableSizeWillChange:(CGSize)size {
      NSLog(@"MTK3DTransformRenderer mtkView");
}

- (void)drawInMTKView:(nonnull MTKView *)view {
      NSLog(@"MTK3DTransformRenderer drawInMTKView");
}
@end
