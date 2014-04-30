DynamicXray
===========

DynamicXray is a UIKit Dynamics runtime visualisation and introspection library.

Ever wanted to see under the hood of the UIKit Dynamics physics engine?
Now you can! With DynamicXray you can visualise your dynamic animator live at
runtime, exposing all dynamic behaviours and dynamic items.

DynamicXray includes a suite of UIKit Dynamics demonstrations in a universal iOS app:
DynamicXrayCatalog. All of the demos allow DynamicXray introspection to be enabled.



Quick Start
===========

Open DynamicXray.xcworkspace, select the Framework scheme, build the framework.

If successful, a Finder window should open at the location of the DynamicXray.framework.

Add DynamicXray.framework to your iOS project.

In your code, import the header and add an instance of DynamicXray to your dynamic animator.

    #import <DynamicXray/DynamicXray.h>
    ...
    DynamicXray *xray = [[DynamicXray alloc] init];
    [self.dynamicAnimator addBehavior:xray];


Overview
========

DynamicXray is built as a UIDynamicBehavior. This means it can be simply added to any
UIDynamicAnimator to enable the introspection overlay. By default, all behaviours added
to the animator will be visualised.

For more control, the DynamicXray behaviour exposes options such as temporarily disabling
the overlay, adjusting the cross fade between app and overlay, whether to draw dynamic
item outlines, and more. Refer to the DynamicXray header.

DynamicXray includes a built-in configuration panel that slides up from the bottom of the
screen. The configuration panel provides access to some options at runtime. The configuration panel
can be presented by calling -presentConfigurationViewController.

For example:

    DynamicXray *xray = [[DynamicXray alloc] init];
    [self.dynamicAnimator addBehavior:xray];
    [xray presentConfigurationViewController];


DynamicXrayCatalog
==================

The included project DynamicXrayCatalog is a universal iOS app containing a suite
of various UIKit Dynamics demonstrations. The demos include DynamicXray pre-loaded
so introspection can be enabled on any demo to see the inner workings.

The demos in DynamicXrayCatalog were created by various authors and all are open
source.

Submit a pull request if you would like to contribute a demo to DynamicXrayCatalog.
Please make sure that your demo includes an option to enable DynamicXray.



License
=======

DynamicXray is Copyright (c) Chris Miles 2013-2014 and available for use under a GPL-3.0 license.

The DynamicXray icon and any other included artwork is Copyright (c) Chris Miles 2013-2014 and available for use under a Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License only when used along with the DynamicXray library.

DynamicXrayCatalog is Copyright (c) Chris Miles 2013-2014 and others. DynamicXrayCatalog contains source code copyrighted by others and included within the terms of the respective licenses. See the source code for more details.

DynamicXrayCatalog is available for use under a BSD (2-Clause) License, except for where included source code specifies alternative license details, then that code remains available under the original license terms. Refer to the source code for more details.

See LICENSE.txt for more details.
