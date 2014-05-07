//
//  CMUIKitPinballViewController_Private.h
//  DynamicXrayCatalog
//
//  Created by Chris Miles on 7/02/2014.
//  Copyright (c) 2014 Chris Miles. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "CMUIKitPinballViewController.h"
#import "CMUIKitPinballEdgesView.h"

@interface CMUIKitPinballViewController () <UICollisionBehaviorDelegate>

@property (strong, nonatomic) UIDynamicAnimator *dynamicAnimator;

@property (strong, nonatomic) UIGravityBehavior *gravityBehavior;
@property (strong, nonatomic) UICollisionBehavior *collisionBehavior;

@property (strong, nonatomic) NSMutableArray *ballsInPlay;
@property (strong, nonatomic) UIView *ballReadyForLaunch;

@property (assign, nonatomic) CGFloat launcherWidth;
@property (assign, nonatomic) CGSize launcherWallSize;
@property (assign, nonatomic) CGFloat launchSpringHeight;
@property (assign, nonatomic) CGFloat launchButtonHeight;

@property (strong, nonatomic) UIView *launchButton;
@property (strong, nonatomic) UIDynamicItemBehavior *launchSpringItemBehavior;

@property (assign, nonatomic) CGFloat flipperAngle;
@property (assign, nonatomic) CGSize flipperSize;
@property (strong, nonatomic) UIView *leftFlipper;
@property (strong, nonatomic) UIView *rightFlipper;
@property (strong, nonatomic) UIAttachmentBehavior *leftFlipperRotationAttachment;
@property (strong, nonatomic) UIAttachmentBehavior *leftFlipperAnchorAttachment;
@property (strong, nonatomic) UIAttachmentBehavior *rightFlipperRotationAttachment;
@property (strong, nonatomic) UIAttachmentBehavior *rightFlipperAnchorAttachment;

@property (strong, nonatomic) UIView *flapView;
@property (strong, nonatomic) UIAttachmentBehavior *flapPivotAttachment;
@property (strong, nonatomic) UICollisionBehavior *flapCollisionBehavior;

@property (strong, nonatomic) CMUIKitPinballEdgesView *edgesView;

@property (strong, nonatomic) NSMutableArray *bumperViews;
@property (strong, nonatomic) NSMutableDictionary *bumperPushBehaviors;

@property (assign, nonatomic) CGSize lastBoundsSize;

@property (strong, nonatomic) DynamicXray *dynamicXray;

- (UIColor *)wallColour;

@end
