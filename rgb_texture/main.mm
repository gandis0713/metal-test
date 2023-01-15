//
//  main.m
//  texture
//
//  Created by gandis on 2022/09/04.
//

#import <AppKit/AppKit.h>
#import <MetalKit/MetalKit.h>
#import "MTKRGBTextureRenderer.h"

int main(int argc, const char * argv[])
{
    @autoreleasepool
    {
        
        id<MTLDevice> device = MTLCreateSystemDefaultDevice();

        NSRect viewRect = NSMakeRect(0, 0, 1280, 720);
        
        MTKRGBTextureRenderer* rgb_texture_renderer = [[MTKRGBTextureRenderer alloc]initWithDevice:device];
//        [rgb_texture_renderer buildBuffers];
//        [rgb_texture_renderer buildShaders];
        
        MTKView* view = [[MTKView alloc] initWithFrame:viewRect];
        view.device = device;
        view.delegate = rgb_texture_renderer;
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
        
//        [window.contentView addSubview:view];
        [window center];
        [window orderFrontRegardless];
        
        [NSApp setActivationPolicy:NSApplicationActivationPolicyRegular];
        [NSApp run];
    }
    return 0;
}
