DynamicsXray
============

DynamicsXray is a UIKit Dynamics runtime visualisation and introspection library.

Ever wanted to see under the hood of the UIKit Dynamics physics engine?
Now you can! With DynamicsXray you can visualise your dynamic animator live at
runtime, exposing all dynamic behaviours and dynamic items.

DynamicsXray includes a suite of UIKit Dynamics demonstrations in a universal iOS app:
DynamicsUberCatalog. All of the demos allow DynamicsXray introspection to be enabled.



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
screen. The configuration panel provides access to some options at runtime. The configuration panel
can be presented by calling -presentConfigurationViewController.

For example:

    DynamicsXray *xray = [[DynamicsXray alloc] init];
    [self.dynamicAnimator addBehavior:xray];
    [xray presentConfigurationViewController];


DynamicsUberCatalog
===================

The included project DynamicsUberCatalog is a universal iOS app containing a suite
of various UIKit Dynamics demonstrations. The demos include DynamicsXray pre-loaded
so introspection can be enabled on any demo to see the inner workings.

The demos in DynamicsUberCatalog were created by various authors and all are open
source.

Submit a pull request if you would like to contribute a demo to DynamicsUberCatalog.
Please make sure that your demo includes an option to enable DynamicsXray.



License
=======

DynamicsXray is Copyright (c) Chris Miles 2013-2014.

