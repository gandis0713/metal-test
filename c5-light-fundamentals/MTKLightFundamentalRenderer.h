//
//  MTKLightFundamentalRenderer.hpp
//  model
//
//  Created by gandis on 2023/01/19.
//

#import <MetalKit/MetalKit.h>

@interface MTKLightFundamentalRenderer : NSViewController <MTKViewDelegate> {
  id<MTLDevice> device;
  id<MTLCommandQueue> command_queue;
}

- (id)initWithDevice:(id<MTLDevice>)device;

@end
