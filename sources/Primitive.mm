//
//  Primitive.m
//  metal-test
//
//  Created by user on 2023/01/20.
//

#import "Primitive.h"

@implementation Primitive

+(MDLMesh*)makeCube:(id<MTLDevice>)device viewSize:(float)size
{
    vector_float3 extent = {size, size, size};
    vector_uint3 segments = {100, 100, 100};
    
    MTKMeshBufferAllocator* mesh_buffer_allocator = [[MTKMeshBufferAllocator alloc] initWithDevice:device];
    MDLMesh* mdl_mesh = [[MDLMesh alloc] initBoxWithExtent:extent
                                                  segments:segments
                                             inwardNormals:false
                                              geometryType:MDLGeometryTypeTriangles
                                                 allocator:mesh_buffer_allocator];
    
    if(mdl_mesh == nil)
    {
        NSLog(@"Failed to create MDL Mesh.");
    }
    
    return mdl_mesh;
}

@end
