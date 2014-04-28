//
//  CMUIKitPinballViewController+Configuration.h
//  DynamicsUberCatalog
//
//  Created by Chris Miles on 19/02/2014.
//  Copyright (c) 2014 Chris Miles. All rights reserved.
//

#import "CMUIKitPinballViewController.h"

extern CGFloat             const CMUIKitPinballBumperRadiusPhone;
extern CGFloat             const CMUIKitPinballBumperRadiusPad;


extern CGFloat             const CMUIKitPinballLaunchMagnitudePhone;
extern CGFloat             const CMUIKitPinballLaunchMagnitudePad;


extern CGSize              const CMUIKitPinballFlipperSizePhone;
extern CGSize              const CMUIKitPinballFlipperSizePadPortrait;
extern CGSize              const CMUIKitPinballFlipperSizePadLandscape;


extern CGFloat             const CMUIKitPinballFlipperAnglePhone;
extern CGFloat             const CMUIKitPinballFlipperAnglePad;

extern CGFloat             const CMUIKitPinballTopEdgeCornerRadiusPhone;
extern CGFloat             const CMUIKitPinballTopEdgeCornerRadiusPad;


#define ConfigValueForIdiom(padIdiomValue, phoneIdiomValue) ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad ? padIdiomValue : phoneIdiomValue)

