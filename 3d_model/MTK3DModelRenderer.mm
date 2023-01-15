//
//  MTK3DModelRenderer.cpp
//  model
//
//  Created by gandis on 2022/07/31.
//

#import "MTK3DModelRenderer.h"

@implementation MTK3DModelRenderer

-(id)initWithDevice:(id<MTLDevice>)_device
{
    NSLog(@"MTK3DModelRenderer initWithDevice");
    
    self = [super init];

    device = _device;
    
    command_queue = [device newCommandQueue];
    
    return self;
}

-(void) buildShaders
{
    NSError* err = nullptr;
    
    NSString* source = @R"(
        #include <metal_stdlib>
        using namespace metal;
        struct VertexIn {
         float4 position [[ attribute(0) ]];
        };
        vertex float4 vertex_main(const VertexIn vertex_in
        [[ stage_in ]]) {
         return vertex_in.position;
        }
        fragment float4 fragment_main() {
         return float4(1, 1, 0, 1);
        }
    )";

    NSLog(@"%@", source);

    id<MTLLibrary> library = [device newLibraryWithSource:source
                                                  options:nullptr
                                                    error:&err];
    /* swift codce
     let library = try device.makeLibrary(source: shader, options: nil)
     */
    

    if(!library)
    {
        NSLog(@"Failed to create library [error : %@]", err);
        assert(false);
    }
    
    id<MTLFunction> vertex_function = [library newFunctionWithName:@"vertex_main"];
    // swift code: let vertex_function = library.makeFunction(name: "vertex_main")
    id<MTLFunction> fragment_function = [library newFunctionWithName:@"fragment_main"];
    // swift code: let framgment_function = library.makeFunction(name: "fragment_main")
    
    MTLRenderPipelineDescriptor* render_pipeline_descriptor = [[MTLRenderPipelineDescriptor alloc]init];
    [render_pipeline_descriptor setVertexFunction:vertex_function];
    [render_pipeline_descriptor setFragmentFunction:fragment_function];
    MTLRenderPipelineColorAttachmentDescriptorArray* render_pipeline_color_attachment_descriptor_array = [render_pipeline_descriptor colorAttachments];
    [render_pipeline_color_attachment_descriptor_array[0] setPixelFormat:MTLPixelFormatBGRA8Unorm_sRGB];
    MTLVertexDescriptor* mtl_vertex_descriptor = MTKMetalVertexDescriptorFromModelIO(mesh.vertexDescriptor);
    [render_pipeline_descriptor setVertexDescriptor:mtl_vertex_descriptor];
    
    render_pipeline_state = [device newRenderPipelineStateWithDescriptor:render_pipeline_descriptor error:&err];
    if(!render_pipeline_state)
    {
        NSLog(@"Failed to create render pipeline state [error : %@]", err);
        assert(false);
    }
}

-(void)buildBuffers
{
    MTKMeshBufferAllocator* mesh_buffer_allocator = [[MTKMeshBufferAllocator alloc] initWithDevice:device];
    
    vector_float3 cone_extent = {1, 1, 1};
    vector_uint2 segments = {100, 100};
    
    MDLMesh* mdl_mesh = [[MDLMesh alloc] initConeWithExtent:cone_extent
                                                   segments:segments
                                              inwardNormals:false
                                            cap: true
                                            geometryType:MDLGeometryTypeTriangles
                                              allocator:mesh_buffer_allocator];
    
    NSError* err = nullptr;
    
    mesh = [[MTKMesh alloc] initWithMesh:mdl_mesh device:device error:&err];
    if(!mesh)
    {
        NSLog(@"Failed to create mesh \n[error : %@]", err);
        assert(false);
    }
}

-(void) mtkView:(nonnull MTKView *)view drawableSizeWillChange:(CGSize)size
{
//    NSLog(@"mtkView");
}

-(void) drawInMTKView:(nonnull MTKView *)view
{
//    NSLog(@"drawInMTKView");
    @autoreleasepool
    {
        // to get render command encoder from MTLRenderPassDescriptor, we call the currentRenderPassDescriptor on view.
        MTLRenderPassDescriptor* render_pass_descriptor = [view currentRenderPassDescriptor];
        
        // get a command buffer from the command queue.
        // do not create the command queue every frame.
        // use the command buffer that was created when the app started.
        id<MTLCommandBuffer> command_buffer = [command_queue commandBuffer];
        
        // create a render command encoder
        // https://developer.apple.com/documentation/metal/mtlcommandbuffer/1442999-rendercommandencoderwithdescript
        id<MTLRenderCommandEncoder> render_command_encoder = [command_buffer renderCommandEncoderWithDescriptor:render_pass_descriptor];
        
        // set render pipeline state.
        // do not create the render pipeline state every frame.
        [render_command_encoder setRenderPipelineState:render_pipeline_state];
        id<MTLBuffer> mesh_buffer = [mesh.vertexBuffers[0] buffer];
        [render_command_encoder setVertexBuffer:mesh_buffer offset:0 atIndex:0];
        
        MTKSubmesh* sub_mesh = mesh.submeshes.firstObject;
        [render_command_encoder drawIndexedPrimitives:MTLPrimitiveTypeLine
                                        indexCount:sub_mesh.indexCount
                                        indexType:sub_mesh.indexType
                                        indexBuffer:sub_mesh.indexBuffer.buffer
                                        indexBufferOffset:0];
        
        [render_command_encoder endEncoding];
        
        [command_buffer presentDrawable:view.currentDrawable];
        [command_buffer commit];
    }
}
@end
