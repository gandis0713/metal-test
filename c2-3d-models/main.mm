//
//  main.cpp
//  c2-3d-models
//
//  Created by gandis on 2023/01/15.
//

#import "MTK3DModelRenderer.h"

int main(int argc, const char *argv[])
{
    @autoreleasepool {

        NSRect viewRect = NSMakeRect(0, 0, 1280, 720);
        MTKView *view = [[MTKView alloc] initWithFrame:viewRect];

        MTK3DModelRenderer *renderer =
            [[MTK3DModelRenderer alloc] initWithView:view];
        [renderer buildBuffers];
        [renderer buildShaders];
        
        view.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;

        NSRect windowRect = NSMakeRect(0, 0, 1280, 720);

        // NSWindow (AppKit Framework)
        NSWindow *window =
        [[NSWindow alloc] initWithContentRect:windowRect
                                    styleMask:(NSWindowStyleMaskTitled |
                                               NSWindowStyleMaskClosable |
                                               NSWindowStyleMaskResizable)
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
