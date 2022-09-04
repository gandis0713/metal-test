//
//  shader1.h
//  nv12_texture
//
//  Created by gandis on 2022/09/04.
//

#ifndef shader_h
#define shader_h

#include <metal_stdlib>
using namespace metal;

struct RasterizerData
{
    float4 position [[position]];
    float2 textureCoordinate;
};

typedef struct
{
    vector_float2 position;
    vector_float2 textureCoordinate;
} TextureVertex;



#endif /* shader1_h */
