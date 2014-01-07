//
//  DynamicsXRay
//
//  Copyright (c) 2013 Chris Miles. All rights reserved.
//

@import UIKit;

@interface DynamicsXRay : UIDynamicBehavior

@property (assign, nonatomic, getter = isActive) BOOL active;

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
@property (assign, nonatomic) CGFloat crossFade;


/** Offset the Xray view drawing.
 
    Specify an offset to adjust the position of the Xray overlay view.
 */
@property (assign, nonatomic) UIOffset viewOffset;


/** Toggles whether dynamic items in the scene are drawn.
 
    If set to NO, then dynamic items are not drawn (behaviors will
    still be drawn).
 
    Defaults to YES.
 */
@property (assign, nonatomic) BOOL drawDynamicItemsEnabled;


/** Toggles whether antialiasing is allowed when drawing.
 
    Set to NO to improve drawing performance.
 
    Defaults to YES.
 */
@property (assign, nonatomic) BOOL allowsAntialiasing;

@end
