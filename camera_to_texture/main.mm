//
//  main.cpp
//  3d_model
//
//  Created by gandis on 2022/08/28.
//

#import "MTKCameraTextureRenderer.h"
#import "CameraSession.h"

int main(int argc, const char * argv[])
{
    @autoreleasepool
    {
        id<MTLDevice> device = MTLCreateSystemDefaultDevice();

        NSRect viewRect = NSMakeRect(0, 0, 1280, 720);
        
        MTKCameraTextureRenderer* camera_texture_renderer = [[MTKCameraTextureRenderer alloc]initWithDevice:device];
//        [camera_texture_renderer createTexture];
        [camera_texture_renderer buildBuffers];
        [camera_texture_renderer buildShaders];
        
        MTKView* view = [[MTKView alloc] initWithFrame:viewRect];
        view.device = device;
        view.delegate = camera_texture_renderer;
        view.colorPixelFormat = MTLPixelFormatBGRA8Unorm_sRGB;
        view.clearColor = MTLClearColorMake(0.0, 0.0, 0.0, 1.0);
        view.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
        
        NSRect windowRect = NSMakeRect(0, 0, 1280, 720);
        
        // NSWindow (AppKit Framework)
        NSWindow* window = [[NSWindow alloc]
                            initWithContentRect:windowRect
                            styleMask:(NSWindowStyleMaskTitled | NSWindowStyleMaskClosable | NSWindowStyleMaskResizable)
                            backing:NSBackingStoreBuffered
                            defer:NO];
        
        [window.contentView addSubview:view];
        [window center];
        [window orderFrontRegardless];
        
        [NSApp setActivationPolicy:NSApplicationActivationPolicyRegular];
        
        
//        CameraSession* cameraSession = [[CameraSession alloc]initWithDevice:device];
//        id<MTLTexture> texture = [cameraSession getMetalTexture];
        
        [NSApp run];
    }
    return 0;
}
