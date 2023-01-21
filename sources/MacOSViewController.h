//
//  MacOSViewController.h
//  metal-test
//
//  Created by user on 2023/01/21.
//

#import <AppKit/AppKit.h>
#import "Renderer.h"

@interface MacOSViewController : NSViewController {
    Renderer* renderer;
}

-(id)init;
//-(MTKView*)getView;

@end
