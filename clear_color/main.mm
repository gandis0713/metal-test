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
    
    @autoreleasepool {
        
        NSRect windowRect = NSMakeRect(0, 0, 1280, 720);
        
        // NSWindow (AppKit Framework)
        NSWindow* window = [[NSWindow alloc]
                            initWithContentRect:windowRect
                            styleMask:(NSWindowStyleMaskTitled | NSWindowStyleMaskClosable | NSWindowStyleMaskResizable)
                            backing:NSBackingStoreBuffered
                            defer:NO];
        
        NSRect viewRect = NSMakeRect(0, 0, 1280, 720);
        
        // MTKView (MetalKit Framework)
        MTKView* view = [[MTKView alloc] initWithFrame:viewRect];
        
        // MTLDevice (Metal Framework)
        id<MTLDevice> device = MTLCreateSystemDefaultDevice();
        MTKViewRenderer* viewRenderer = [[MTKViewRenderer alloc] init];
        view.device = device;
        view.delegate = viewRenderer;
        view.colorPixelFormat = MTLPixelFormatBGRA8Unorm_sRGB;
        view.clearColor = MTLClearColorMake(1.0, 0.0, 0.0, 1.0);
        view.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
        
        [window.contentView addSubview:view];
        [window center];
        [window orderFrontRegardless];
        
        [NSApp setActivationPolicy:NSApplicationActivationPolicyRegular];
        [NSApp run];
    }

    return 0;
}
