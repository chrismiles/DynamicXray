//
//  DynamicsXRay
//
//  Copyright (c) 2013 Chris Miles. All rights reserved.
//

@import UIKit;

@interface DynamicsXRay : UIDynamicBehavior

@end


@interface DynamicsXRay (XRayUserInterface)

- (void)presentConfigurationViewController;

@end


@interface DynamicsXRay (XRayVisualStyle)

/** Controls the opacity of both the XRay overlay and the application windows.
 
    CrossFade takes a value between -1.0 and 1.0. Negative values specify the
    level of transparency of the XRay overlay window. Positive values specify
    the level of transparency of the app window.

    At -1.0, the app window is visible while the XRay overlay window is not.
    At 1.0, the XRay overlay window is visible while the app window is not.
    At 0, both the app window and the XRay overlay windows are fully visible.

    * -1.0: App window opacity: 1.0; XRay overlay window opacity: 0
    *    0: App window opacity: 1.0; XRay overlay window opacity: 1.0
    *  1.0: App window opacity:   0; XRay overlay window opacity: 1.0
 */
@property (nonatomic, assign) CGFloat crossFade;

@end
