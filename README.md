DynamicXray
===========

DynamicXray is a UIKit Dynamics runtime visualisation and introspection library.

Ever wanted to see under the hood of the UIKit Dynamics physics engine?
Now you can! With DynamicXray you can visualise your dynamic animator live at
runtime, exposing all dynamic behaviours and dynamic items.

The DynamicXray project includes a catalog of open source UIKit Dynamics demonstrations, all with DynamicXray already integrated. See <a href="#dynamicxraycatalog">DynamicXrayCatalog</a>.

<img src="https://lh4.googleusercontent.com/-dxUVFNprkmw/U2n8jHTS1jI/AAAAAAAAAiU/isgqsFLkv7g/s512/DynamicXrayUIKitPinball1.png" alt="DynamicXray + UIKit Pinball" height="480" />
<img src="https://lh3.googleusercontent.com/-YHqpnhXBKgE/U2n8u21qlQI/AAAAAAAAAic/X_Zm3_1CFMw/s512/DynamicXrayUIKitPinball2.png" alt="DynamicXray + UIKit Pinball" height="480" />
<img src="https://lh4.googleusercontent.com/-Ju24n7OG-14/U2n8xR5pvhI/AAAAAAAAAik/lRt_udRsD2U/s512/DynamicXrayUIKitPinball4.png" alt="DynamicXray + UIKit Pinball" height="480" />
<img src="https://lh5.googleusercontent.com/-dPCksSQFVv4/U2n8iYHel1I/AAAAAAAAAiM/o2lexHYurEw/s512/DynamicXrayLoadingPatty1.png" alt="DynamicXray + UIKit Pinball" height="480" />
<img src="https://lh6.googleusercontent.com/-Fgl4e0wa4ww/U2n8glJWs0I/AAAAAAAAAiE/7nuaM9hjL3o/s512/DynamicXrayCollisionsGravitySpring1.png" alt="DynamicXray + UIKit Pinball" height="480" />


Quick Start
===========

Open `DynamicXray.xcworkspace`, select the Framework scheme, build the framework.

If successful, a Finder window should open at the location of the DynamicXray.framework.

Add DynamicXray.framework to your iOS project.

In your code, import the header and add an instance of DynamicXray to your dynamic animator.

    #import <DynamicXray/DynamicXray.h>
    ...
    DynamicXray *xray = [[DynamicXray alloc] init];
    [self.dynamicAnimator addBehavior:xray];


Overview
========

DynamicXray is implemented as a UIDynamicBehavior. This means it can simply be added to any
UIDynamicAnimator to enable the introspection overlay. By default, all behaviours owned
by the animator will be visualised.

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


Features
========

* Easy and controllable integration. Simply add the DynamicXray behavior to your dynamic animator.

* All UIKit Dynamic behaviours are visualised, including collision boundaries.

* All dynamic item bodies in the scene are visualised.

* Any contacts between dynamic items and other items or collision boundaries are visualised by an orange flash.

* Configurable overlay cross fade control, between all of the application visible throught to only the DynamicXray overlay visible.

* Built-in configuration panel for user to control run-time options.


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
