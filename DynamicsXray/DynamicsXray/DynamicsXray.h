//
//  DynamicsXray
//
//  Copyright (c) 2013-2014 Chris Miles. All rights reserved.
//

/*
    DynamicsXray
    ============

    DynamicsXray is a UIKit Dynamics runtime visualisation and introspection library.

    Ever wanted to see under the hood of the UIKit Dynamics physics engine?
    Now you can! With DynamicsXray you can visualise your dynamic animator live at
    runtime, exposing all dynamic behaviours and dynamic items.


    Quick Start
    ===========

    Open DynamicsXray.xcworkspace, select the Framework scheme, build the framework.

    Add DynamicsXray.framework to your iOS project.

    In your code, import the header and add an instance of DynamicsXray to your dynamic animator.

        #import <DynamicsXray/DynamicsXray.h>
        ...
        DynamicsXray *xray = [[DynamicsXray alloc] init];
        [self.dynamicAnimator addBehavior:xray];


    Overview
    ========

    DynamicsXray is built as a UIDynamicBehavior. This means it can be simply added to any
    UIDynamicAnimator to enable the introspection overlay. By default, all behaviours added
    to the animator will be visualised.

    For more control, the DynamicsXray behaviour exposes options such as temporarily disabling
    the overlay, adjusting the cross fade between app and overlay, whether to draw dynamic
    item outlines, and more. Refer to the DynamicsXray header.

    DynamicsXray includes a built-in configuration panel that slides up from the bottom of the
    screen. The configuration panel provides access to some options at runtime. The configuration
    panel can be presented by calling -presentConfigurationViewController.

    For example:

        DynamicsXray *xray = [[DynamicsXray alloc] init];
        [self.dynamicAnimator addBehavior:xray];
        [xray presentConfigurationViewController];

 */


@import UIKit;

extern NSString *const DynamicsXrayVersion;


/** DynamicsXray provides real time UIKit Dynamics introspection and visualisation.
 
    DynamicsXray is a UIDynamicBehavior. Add an instance of DynamicsXray to
    a UIDynamicAnimator to enable the introspection overlay.
 */
@interface DynamicsXray : UIDynamicBehavior

/** Toggles whether DynamicsXray is active.
 
    Set to NO to temporarily disable overlay drawing.
 */
@property (assign, nonatomic, getter = isActive) BOOL active;

@end


@interface DynamicsXray (XrayUserInterface)

/** Present the DynamicsXray configuration panel.
 
    The configuration panel allows for options to be changed at
    run-time.
 */
- (void)presentConfigurationViewController;

@end


@interface DynamicsXray (XrayVisualStyle)

/** Controls the opacity of both the Xray overlay and the application windows.
 
    CrossFade takes a value between -1.0 and 1.0. Negative values specify the
    level of transparency of the Xray overlay window. Positive values specify
    the level of transparency of the app window.

    At -1.0, the app window is visible while the Xray overlay window is not.
    At 1.0, the Xray overlay window is visible while the app window is not.
    At 0, both the app window and the XRay overlay windows are fully visible.

    * -1.0: App window opacity: 1.0; Xray overlay window opacity: 0
    *    0: App window opacity: 1.0; Xray overlay window opacity: 1.0
    *  1.0: App window opacity:   0; Xray overlay window opacity: 1.0
 */
@property (assign, nonatomic) CGFloat crossFade;


/** Offset the Xray view drawing.
 
    Specify an offset to adjust the position of the Xray overlay drawing.
 */
@property (assign, nonatomic) UIOffset viewOffset;


/** Toggles whether dynamic items in the scene are drawn.
 
    If set to NO, dynamic items are not drawn (behaviours will
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
