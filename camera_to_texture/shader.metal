//
//  shader.metal
//  camera_to_texture
//
//  Created by gandis on 2022/08/31.
//

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

// vertex shader
vertex RasterizerData
vertexMain(uint vertexID [[ vertex_id ]],
             constant TextureVertex *vertexArray [[ buffer(0) ]])

{

    RasterizerData out;
    
    out.position = vector_float4(vertexArray[vertexID].position, 0.0, 1.0);
    // out.position.xy = vertexArray[vertexID].position.xy;
    out.textureCoordinate = vertexArray[vertexID].textureCoordinate;

    return out;
}

// Fragment function
fragment float4
fragmentMain(RasterizerData in [[stage_in]],
               texture2d<half> colorTexture0 [[ texture(0) ]],
               texture2d<half> colorTexture1 [[ texture(1) ]])
{
    constexpr sampler textureSampler (mag_filter::linear,
                                      min_filter::linear);

    const half4 colorSample0 = colorTexture0.sample(textureSampler, in.textureCoordinate);
    const half4 colorSample1 = colorTexture1.sample(textureSampler, in.textureCoordinate);

    return float4(colorSample0);
}


