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
    
    out.position.xy = vertexArray[vertexID].position;
    out.position.z = 0.0;
    out.position.w = 1.0;
    
    out.textureCoordinate = vertexArray[vertexID].textureCoordinate;

    return out;
}

// Fragment function
fragment float4
fragmentMain(RasterizerData in [[stage_in]],
               texture2d<half> colorTexture0 [[ texture(0) ]],
               texture2d<half> colorTexture1 [[ texture(1) ]])
{
//    constexpr sampler textureSampler (mag_filter::linear,
//                                      min_filter::linear);

//    const half4 colorSample0 = colorTexture0.sample(textureSampler, in.textureCoordinate);
//    const half4 colorSample1 = colorTexture1.sample(textureSampler, in.textureCoordinate);
    
    constexpr sampler s(address::clamp_to_edge, filter::linear);
    float y;
    float2 uv;
    y = colorTexture0.sample(s, in.textureCoordinate).r;
    uv = float2(colorTexture1.sample(s, in.textureCoordinate).r, colorTexture1.sample(s, in.textureCoordinate).g) - float2(0.5, 0.5);
    
     // Conversion for YUV to rgb from http://www.fourcc.org/fccyvrgb.php
    float4 out = float4(y + 1.403 * uv.y, y - 0.344 * uv.x - 0.714 * uv.y, y + 1.770 * uv.x, 1.0);


    return float4(out);
}


