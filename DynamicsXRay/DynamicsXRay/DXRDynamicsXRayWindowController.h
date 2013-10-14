//
//  DXRDynamicsXRayWindowController.h
//  DynamicsXRay
//
//  Created by Chris Miles on 14/10/13.
//  Copyright (c) 2013 Chris Miles. All rights reserved.
//

@import UIKit;

@interface DXRDynamicsXRayWindowController : NSObject

/** Returns a weak references UIWindow.
 
    The caller must keep a strong reference to the window
    to keep it alive. After the last strong reference is
    dropped, the window will be dealloc'd. On the next
    call a new window will be created and returned.
 */
@property (weak, nonatomic, readonly) UIWindow *xrayWindow;

@end
