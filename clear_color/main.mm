//
//  main.cpp
//  metal-test
//
//  Created by gandis on 2022/07/29.
//

#include <iostream>

#import "MTKViewRenderer.h"

int main(int argc, const char * argv[])
{
    
    @autoreleasepool
    {
        // MTLDevice (Metal Framework)
        id<MTLDevice> device = MTLCreateSystemDefaultDevice();
        
        // NSViewController[MTKViewDelegate] (MetalKit Framework)
//        MTKViewRenderer* viewRenderer = [[MTKViewRenderer alloc] init];
        MTKViewRenderer* viewRenderer = [[MTKViewRenderer alloc]initWithDevice:device];
        
        NSRect viewRect = NSMakeRect(320, 0, 640, 720);
        
        // MTKView (MetalKit Framework)
        MTKView* view = [[MTKView alloc] initWithFrame:viewRect];
        view.device = device;
        view.delegate = viewRenderer;
        view.colorPixelFormat = MTLPixelFormatBGRA8Unorm_sRGB;
        view.clearColor = MTLClearColorMake(1.0, 0.0, 0.0, 1.0);
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
