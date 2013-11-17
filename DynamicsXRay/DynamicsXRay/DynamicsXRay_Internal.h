//
//  DynamicsXRay_Internal.h
//  DynamicsXRay
//
//  Created by Chris Miles on 12/11/2013.
//  Copyright (c) 2013 Chris Miles. All rights reserved.
//

#import <DynamicsXRay/DynamicsXRay.h>
#import "DXRDynamicsXRayViewController.h"

@interface DynamicsXRay () {
    CGFloat _crossFade;
    BOOL _drawDynamicItemsEnabled;
}

@property (weak, nonatomic) UIView *referenceView;
@property (strong, nonatomic) DXRDynamicsXRayViewController *xrayViewController;
@property (strong, nonatomic) UIWindow *xrayWindow;

@property (strong, nonatomic) NSMutableSet *dynamicItemsToDraw;

- (void)redraw;

@end

