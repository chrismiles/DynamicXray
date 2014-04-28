//
//  DynamicsXray_Internal.h
//  DynamicsXray
//
//  Created by Chris Miles on 12/11/2013.
//  Copyright (c) 2013-2014 Chris Miles. All rights reserved.
//

#import "DynamicXray.h"
#import "DXRDynamicXrayViewController.h"
@class DXRDynamicsXrayWindowController;


@interface DynamicXray () {
    CGFloat _crossFade;
    BOOL _drawDynamicItemsEnabled;
}

@property (weak, nonatomic) UIView *referenceView;

@property (weak, nonatomic) UIView *previousReferenceView;
@property (weak, nonatomic) UIWindow *previousReferenceViewWindow;
@property (assign, nonatomic) CGRect previousReferenceViewFrame;

@property (strong, nonatomic) DXRDynamicXrayViewController *xrayViewController;
@property (strong, nonatomic) UIWindow *xrayWindow;

@property (strong, nonatomic) NSMutableSet *dynamicItemsToDraw;
@property (strong, nonatomic) NSMapTable *dynamicItemContactLifetimes;
@property (strong, nonatomic) NSMapTable *pathContactLifetimes;
@property (strong, nonatomic) NSMapTable *instantaneousPushBehaviorLifetimes;

- (void)redraw;
- (DXRDynamicsXrayWindowController *)xrayWindowController;
- (DXRDynamicXrayView *)xrayView;

+ (UIColor *)xrayStrokeColor;
+ (UIColor *)xrayFillColor;
+ (UIColor *)xrayContactColor;

@end
