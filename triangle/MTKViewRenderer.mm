//
//  MTKViewRenderer.cpp
//  clear_color
//
//  Created by gandis on 2022/07/29.
//

#import "MTKViewRenderer.h"

@implementation MTKViewRenderer

-(id)initWithDevice:(id<MTLDevice>)_device
{
    NSLog(@"MTKViewRenderer initWithDevice");
    
    self = [super init];

    device = _device;
    
    command_queue = [device newCommandQueue];
    
    return self;
}

-(void) buildShaders
{
    NSError* err = nullptr;
    
//    NSString* source = [NSString stringWithString:@R"(
//        #include <metal_stdlib>
//        using namespace metal;
//
//        struct v2f
//        {
//            float4 position [[position]];
//            half3 color;
//        };
//
//        v2f vertex vertexMain( uint vertexId [[vertex_id]],
//                               device const float3* positions [[buffer(0)]],
//                               device const float3* colors [[buffer(1)]] )
//        {
//            v2f o;
//            o.position = float4( positions[ vertexId ], 1.0 );
//            o.color = half3 ( colors[ vertexId ] );
//            return o;
//        }
//
//        half4 fragment fragmentMain( v2f in [[stage_in]] )
//        {
//            return half4( in.color, 1.0 );
//        }
//    )"];
//
//    NSLog(@"%@", source);
//
//    id<MTLLibrary> library = [device newLibraryWithSource:source
//                                                  options:nullptr
//                                                    error:&err];
//
//    if(!library)
//    {
//        NSLog(@"Failed to create library [error : %@]", err);
//        assert(false);
//    }
//
//    id<MTLFunction> vertex_function = [library newFunctionWithName:@"vertexMain"];
//    id<MTLFunction> fragment_function = [library newFunctionWithName:@"fragmentMain"];
  
    
    NSString* vertex_source = @R"(
        #include <metal_stdlib>
        using namespace metal;
    
        struct v2f
        {
            float4 position [[position]];
            half3 color;
        };
    
        vertex v2f vertex_main( uint vertexId [[vertex_id]],
                               device const float3* positions [[buffer(0)]],
                               device const float3* colors [[buffer(1)]] )
        {
            v2f o;
            o.position = float4( positions[ vertexId ], 1.0 );
            o.color = half3 ( colors[ vertexId ] );
            return o;
        }
    )";
    
    NSString* fragment_source = @R"(
        #include <metal_stdlib>
        using namespace metal;
    
        struct v2f
        {
            float4 position [[position]];
            half3 color;
        };
    
        fragment half4 fragment_main( v2f in [[stage_in]] )
        {
            return half4( in.color, 1.0 );
        }
    )";
    
    NSLog(@"vertex shader : %@", vertex_source);
    NSLog(@"fragment shader : %@", fragment_source);
    
    id<MTLLibrary> vertex_library = [device newLibraryWithSource:vertex_source
                                                  options:nullptr
                                                    error:&err];
    
    if(!vertex_library)
    {
        NSLog(@"Failed to create library \n[error : %@]", err);
        assert(false);
    }
    
    
    
    id<MTLLibrary> fragment_library = [device newLibraryWithSource:fragment_source
                                                  options:nullptr
                                                    error:&err];
    
    if(!fragment_library)
    {
        NSLog(@"Failed to create library [error : %@]", err);
        assert(false);
    }
    
    id<MTLFunction> vertex_function = [vertex_library newFunctionWithName:@"vertex_main"];
    id<MTLFunction> fragment_function = [fragment_library newFunctionWithName:@"fragment_main"];
    
    MTLRenderPipelineDescriptor* render_pipeline_descriptor = [[MTLRenderPipelineDescriptor alloc]init];
    [render_pipeline_descriptor setVertexFunction:vertex_function];
    [render_pipeline_descriptor setFragmentFunction:fragment_function];
    MTLRenderPipelineColorAttachmentDescriptorArray* render_pipeline_color_attachment_descriptor_array = [render_pipeline_descriptor colorAttachments];
    [render_pipeline_color_attachment_descriptor_array[0] setPixelFormat:MTLPixelFormatBGRA8Unorm_sRGB];
    
    render_pipeline_state = [device newRenderPipelineStateWithDescriptor:render_pipeline_descriptor error:&err];
    if(!render_pipeline_state)
    {
        NSLog(@"Failed to create render pipeline state [error : %@]", err);
        assert(false);
    }
}

-(void)buildBuffers
{
    const size_t NumVertices = 6;

    simd::float3 positions[6] =
    {
        { -0.5f,  0.5f, 0.0f },
        { -0.5f, -0.5f, 0.0f },
        { +0.5f,  0.5f, 0.0f },
        
        { +0.5f,  0.5f, 0.0f },
        { -0.5f, -0.5f, 0.0f },
        { +0.5f, -0.5f, 0.0f }
    };

    simd::float3 colors[NumVertices] =
    {
        {  1.0f, 0.0f, 0.0f },
        {  1.0f, 1.0f, 0.0f },
        {  0.0f, 1.0f, 0.0f },
        
        {  0.0f, 0.0f, 1.0f },
        {  0.0f, 0.0f, 1.0f },
        {  0.0f, 0.0f, 1.0f }
    };
    
//    const size_t position_size = NumVertices * sizeof( simd::float3 );
//    const size_t color_size = NumVertices * sizeof( simd::float3 );
    const size_t position_size = sizeof( positions );
    const size_t color_size = sizeof( colors );
    
    vertex_position_buffer = [device newBufferWithLength:position_size options:MTLResourceStorageModeManaged];
    vertex_color_buffer = [device newBufferWithLength:color_size options:MTLResourceStorageModeManaged];
    
    void* vert_pos_buf_ptr = [vertex_position_buffer contents];
    void* vert_col_buf_ptr = [vertex_color_buffer contents];
    
    memcpy(vert_pos_buf_ptr, positions, position_size);
    memcpy(vert_col_buf_ptr, colors, color_size);
    
    [vertex_position_buffer didModifyRange:NSMakeRange(0, [vertex_position_buffer length])];
    [vertex_color_buffer didModifyRange:NSMakeRange(0, [vertex_color_buffer length])];
}

-(void) mtkView:(nonnull MTKView *)view drawableSizeWillChange:(CGSize)size
{
    NSLog(@"mtkView");
}

-(void) drawInMTKView:(nonnull MTKView *)view
{
//    NSLog(@"drawInMTKView");
    @autoreleasepool
    {
        MTLRenderPassDescriptor* render_pass_descriptor = [view currentRenderPassDescriptor];
        
        id<MTLCommandBuffer> command_buffer = [command_queue commandBuffer];
        id<MTLRenderCommandEncoder> render_command_encoder = [command_buffer renderCommandEncoderWithDescriptor:render_pass_descriptor];
        
        [render_command_encoder setRenderPipelineState:render_pipeline_state];
        [render_command_encoder setVertexBuffer:vertex_position_buffer offset:0 atIndex:0];
        [render_command_encoder setVertexBuffer:vertex_color_buffer offset:0 atIndex:1];
        [render_command_encoder drawPrimitives:MTLPrimitiveTypeTriangle vertexStart:0 vertexCount:6];
        [render_command_encoder endEncoding];
        
        [command_buffer presentDrawable:view.currentDrawable];
        [command_buffer commit];
    }
}
@end
