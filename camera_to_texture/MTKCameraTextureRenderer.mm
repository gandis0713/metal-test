//
//  MTKCameraTextureRenderer.mm
//  model
//
//  Created by gandis on 2022/07/31.
//

#import "MTKCameraTextureRenderer.h"

@implementation MTKCameraTextureRenderer

-(id)initWithDevice:(id<MTLDevice>)_device
{
    NSLog(@"MTKViewRenderer initWithDevice");
    
    self = [super init];

    device = _device;
    
    command_queue = [device newCommandQueue];
    
    cameraSession = [[CameraSession alloc]initWithDevice:device];
    
    return self;
}

-(void) buildShaders
{
    NSError* err = nullptr;
    
    NSString* source = [NSString stringWithString:@R"(
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
                       texture2d<half> colorTexture [[ texture(0) ]])
        {
            constexpr sampler textureSampler (mag_filter::linear,
                                              min_filter::linear);

            const half4 colorSample = colorTexture.sample(textureSampler, in.textureCoordinate);

            return float4(colorSample);
//            return float4(1.0, 0.0, 0.0, 1.0);
        }

    )"];

    NSLog(@"%@", source);

    id<MTLLibrary> library = [device newLibraryWithSource:source
                                                  options:nullptr
                                                    error:&err];

    if(!library)
    {
        NSLog(@"Failed to create library [error : %@]", err);
        assert(false);
    }

    id<MTLFunction> vertex_function = [library newFunctionWithName:@"vertexMain"];
    id<MTLFunction> fragment_function = [library newFunctionWithName:@"fragmentMain"];
    
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
    
    typedef struct
    {
        vector_float2 position;
        vector_float2 textureCoordinate;
    } TextureVertex;
    
    const float position = 0.5;
    
    static const TextureVertex quadVertices[] =
    {
        { {  position,  -position },  { 1.f, 1.f } },
        { { -position,  -position },  { 0.f, 1.f } },
        { { -position,   position },  { 0.f, 0.f } },

        { {  position,  -position },  { 1.f, 1.f } },
        { { -position,   position },  { 0.f, 0.f } },
        { {  position,   position },  { 1.f, 0.f } },
    };
    
    // Create a vertex buffer, and initialize it with the quadVertices array
    vertices = [device newBufferWithBytes:quadVertices
                                     length:sizeof(quadVertices)
                                    options:MTLResourceStorageModeShared];

    // Calculate the number of vertices by dividing the byte length by the size of each vertex
//    _numVertices = sizeof(quadVertices) / sizeof(AAPLVertex);
}

-(void) createTexture
{
    struct SImage
    {
        uint32_t width = 256;
        uint32_t height = 256;
        uint8_t* data = nullptr;
    };

    SImage image;
    image.data = new uint8_t[image.width * 4 * image.height * 4];
//    memset(image.data, 0, 1024 * 1024);

    for(int i = 0; i < image.width * 4 * image.height * 4; i += 4)
    {
        image.data[i + 0] = 0; // blue
        image.data[i + 1] = 255; // green
        image.data[i + 2] = 255; // red
        image.data[i + 3] = 255;
    }

    MTLTextureDescriptor *textureDescriptor = [[MTLTextureDescriptor alloc] init];

    // Indicate that each pixel has a blue, green, red, and alpha channel, where each channel is
    // an 8-bit unsigned normalized value (i.e. 0 maps to 0.0 and 255 maps to 1.0)
    textureDescriptor.pixelFormat = MTLPixelFormatBGRA8Unorm;

    // Set the pixel dimensions of the texture
    textureDescriptor.width = image.width;
    textureDescriptor.height = image.height;

    // Create the texture from the device by using the descriptor
    texture = [device newTextureWithDescriptor:textureDescriptor];
    
    
    // Calculate the number of bytes per row in the image.
    NSUInteger bytesPerRow = 4 * image.width;
    
    MTLRegion region = {
        { 0, 0, 0 },                   // MTLOrigin
        {image.width, image.height, 1} // MTLSize
    };
    
    // Copy the bytes from the data object into the texture
    [texture replaceRegion:region
             mipmapLevel:0
             withBytes:image.data
             bytesPerRow:bytesPerRow];
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
        texture = [cameraSession getMetalTexture];
        
        MTLRenderPassDescriptor* render_pass_descriptor = [view currentRenderPassDescriptor];
        
        id<MTLCommandBuffer> command_buffer = [command_queue commandBuffer];
        id<MTLRenderCommandEncoder> render_command_encoder = [command_buffer renderCommandEncoderWithDescriptor:render_pass_descriptor];
        
        [render_command_encoder setRenderPipelineState:render_pipeline_state];
        [render_command_encoder setVertexBuffer:vertices offset:0 atIndex:0];
        [render_command_encoder setFragmentTexture:texture
                                  atIndex:0];
        [render_command_encoder drawPrimitives:MTLPrimitiveTypeTriangle vertexStart:0 vertexCount:6];
        [render_command_encoder endEncoding];
        
        [command_buffer presentDrawable:view.currentDrawable];
        [command_buffer commit];
    }
}

@end
