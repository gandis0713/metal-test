//
//  main.cpp
//  c2-3d-models
//
//  Created by gandis on 2023/01/15.
//

#import "MTK3DTransforms.h"

int main(int argc, const char *argv[]) {
  @autoreleasepool {
    id<MTLDevice> device = MTLCreateSystemDefaultDevice();

    NSRect viewRect = NSMakeRect(0, 0, 1280, 720);

    MTK3DTransforms *model_renderer =
        [[MTK3DTransforms alloc] initWithDevice:device];

    MTKView *view = [[MTKView alloc] initWithFrame:viewRect];
    view.device = device;
    view.delegate = model_renderer;
    view.colorPixelFormat = MTLPixelFormatBGRA8Unorm_sRGB;
    view.clearColor = MTLClearColorMake(0.0, 0.0, 0.0, 1.0);
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
