//
//  main.cpp
//  3d_model
//
//  Created by gandis on 2022/08/28.
//

#import "MTKNV12TextureRenderer.h"
#import "CameraSession.h"

int main(int argc, const char * argv[])
{
    @autoreleasepool
    {
        id<MTLDevice> device = MTLCreateSystemDefaultDevice();

        NSRect viewRect = NSMakeRect(0, 0, 1280, 720);
        
        MTKNV12TextureRenderer* nv12_texture_renderer = [[MTKNV12TextureRenderer alloc]initWithDevice:device];
        [nv12_texture_renderer createTexture];
        [nv12_texture_renderer buildBuffers];
        [nv12_texture_renderer buildShaders];
        
        MTKView* view = [[MTKView alloc] initWithFrame:viewRect];
        view.device = device;
        view.delegate = nv12_texture_renderer;
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
        [NSApp run];
    }
    return 0;
}
