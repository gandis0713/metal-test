//
//  Primitive.h
//  metal-test
//
//  Created by user on 2023/01/20.
//

#import <MetalKit/MetalKit.h>

@interface Primitive: NSObject

+(MDLMesh*)makeCube:(id<MTLDevice>)device viewSize:(float)size;

@end
