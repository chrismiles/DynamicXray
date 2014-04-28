//
//  DXRDynamicXrayWindowController.h
//  DynamicsXray
//
//  Created by Chris Miles on 14/10/13.
//  Copyright (c) 2013 Chris Miles. All rights reserved.
//

@import UIKit;
@class DynamicXray;
@class DXRDynamicXrayViewController;


@interface DXRDynamicXrayWindowController : UIViewController

/** Returns a weak references UIWindow.
 
    The caller must keep a strong reference to the window
    to keep it alive. After the last strong reference is
    dropped, the window will be dealloc'd. On the next
    call a new window will be created and returned.
 */
@property (weak, nonatomic, readonly) UIWindow *xrayWindow;


/** Adds a DXRDynamicsXrayViewController's view to the window and makes it visible.
 
    Note that dynamics Xray views are always added below any configuration view.
 */
- (void)presentDynamicsXrayViewController:(DXRDynamicXrayViewController *)dynamicsXrayViewController;

/** Removes a DXRDynamicsXrayViewController's view from the window.
 */
- (void)dismissDynamicsXrayViewController:(DXRDynamicXrayViewController *)xrayViewController;


/** Adds a DXRDynamicsXrayConfigurationViewController's view to the window.
 
    Only one configuration view can be visible at a time. Attempts to present another
    configuration view when one is already present will be ignored.
    
    Note that configuration views will always be added on top of dynamics xray views.
 */
- (void)presentConfigViewControllerWithDynamicsXray:(DynamicXray *)dynamicsXray animated:(BOOL)animated;

/** Dismiss the DXRDynamicsXrayConfigurationViewController's view if one is visible.
 */
- (void)dismissConfigViewController;

@end
