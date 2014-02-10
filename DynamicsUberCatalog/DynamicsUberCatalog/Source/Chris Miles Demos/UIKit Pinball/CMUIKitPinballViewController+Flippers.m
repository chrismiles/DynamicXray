//
//  CMUIKitPinballViewController+Flippers.m
//  DynamicsUberCatalog
//
//  Created by Chris Miles on 10/02/2014.
//  Copyright (c) 2014 Chris Miles. All rights reserved.
//

#import "CMUIKitPinballViewController+Flippers.h"
#import "CMUIKitPinballViewController_Private.h"

@implementation CMUIKitPinballViewController (Flippers)

- (void)setupFlippers
{
    CGRect bounds = self.view.bounds;
    CGFloat height = CGRectGetHeight(bounds);
    CGSize flipperSize = self.flipperSize;

    UIDynamicItemBehavior *flipperItemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[]];
    flipperItemBehavior.density = 2.0f;
    flipperItemBehavior.elasticity = 0.4f;
    [self.dynamicAnimator addBehavior:flipperItemBehavior];

    {
        // Left Flipper
        CGRect leftFlipperFrame = CGRectMake(10.0f, height - flipperSize.height*2.0f, flipperSize.width, flipperSize.height);
        UIView *flipper = [[UIView alloc] initWithFrame:leftFlipperFrame];
        flipper.backgroundColor = [UIColor purpleColor];
        [self.view addSubview:flipper];

        [self.collisionBehavior addItem:flipper];
        [flipperItemBehavior addItem:flipper];

        UIOffset attachmentOffset = UIOffsetMake(flipperSize.height/2.0f - flipperSize.width/2.0f, 0);
        UIAttachmentBehavior *flipperRotationAttachment = [[UIAttachmentBehavior alloc] initWithItem:flipper offsetFromCenter:attachmentOffset attachedToAnchor:CGPointZero];
        flipperRotationAttachment.length = 0;
        [self.dynamicAnimator addBehavior:flipperRotationAttachment];
        self.leftFlipperRotationAttachment = flipperRotationAttachment;

        attachmentOffset = UIOffsetMake(flipperSize.width/2.0f, 0); // anchored right side of view
        UIAttachmentBehavior *flipperAnchorAttachment = [[UIAttachmentBehavior alloc] initWithItem:flipper offsetFromCenter:attachmentOffset attachedToAnchor:CGPointZero];
        flipperAnchorAttachment.length = 0;
        flipperAnchorAttachment.damping = 1.0f;
        flipperAnchorAttachment.frequency = 20.0f;
        [self.dynamicAnimator addBehavior:flipperAnchorAttachment];
        self.leftFlipperAnchorAttachment = flipperAnchorAttachment;

        self.leftFlipper = flipper;
    }

    [self layoutFlippers];
}

- (void)layoutFlippers
{
    CGRect bounds = self.view.bounds;
    CGFloat height = CGRectGetHeight(bounds);
    CGSize flipperSize = self.flipperSize;
    CGFloat flipperAngle = self.flipperAngle;

    CGRect leftFlipperFrame = CGRectMake(8.0f, height - flipperSize.height*3.0f, flipperSize.width, flipperSize.height);

    CGPoint rotationAnchorPoint = CGPointMake(leftFlipperFrame.origin.x + flipperSize.height/2.0f, leftFlipperFrame.origin.y + flipperSize.height/2.0f);
    self.leftFlipperRotationAttachment.anchorPoint = rotationAnchorPoint;
    self.leftFlipperRotationAttachment.length = 0;

    CGFloat calcLength = flipperSize.width - flipperSize.height/2.0f;
    self.leftFlipperAnchorAttachment.anchorPoint = CGPointMake(rotationAnchorPoint.x + calcLength * cosf(flipperAngle), rotationAnchorPoint.y + calcLength * sinf(flipperAngle));
    self.leftFlipperAnchorAttachment.length = 0;
}

- (void)setupFlipperButtons
{
    CGRect bounds = self.view.bounds;
    CGFloat height = CGRectGetHeight(bounds);
    CGSize buttonSize = CGSizeMake(50.0f, 50.0f);

    CGRect frame = CGRectMake(0, height - buttonSize.height, buttonSize.width, buttonSize.height);
    UIView *leftFlipperButton = [[UIView alloc] initWithFrame:frame];
    leftFlipperButton.autoresizingMask = (UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin);
    leftFlipperButton.backgroundColor = [[UIColor yellowColor] colorWithAlphaComponent:0.1f]; // DEBUG
    [self.view addSubview:leftFlipperButton];

    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(leftFlipperTapGesture:)];
    [leftFlipperButton addGestureRecognizer:tapGestureRecognizer];
}

- (void)leftFlipperTapGesture:(__unused UITapGestureRecognizer *)tapGestureRecognizer
{
    [self fireLeftFlipper];
}

- (void)fireLeftFlipper
{
    CGSize flipperSize = self.flipperSize;
    CGPoint rotationPoint = self.leftFlipperRotationAttachment.anchorPoint;

    [self.dynamicAnimator removeBehavior:self.leftFlipperAnchorAttachment];

    UIOffset attachmentOffset = UIOffsetMake(flipperSize.width/2.0f, 0); // anchored right side of view
    CGPoint anchorPoint = self.leftFlipperAnchorAttachment.anchorPoint;
    anchorPoint.y = rotationPoint.y - (anchorPoint.y - rotationPoint.y);

    UIAttachmentBehavior *springAttachment = [[UIAttachmentBehavior alloc] initWithItem:self.leftFlipper offsetFromCenter:attachmentOffset attachedToAnchor:anchorPoint];
    springAttachment.length = 0;
    springAttachment.damping = 0.8f;
    springAttachment.frequency = 10.0f;
    [self.dynamicAnimator addBehavior:springAttachment];

    __weak CMUIKitPinballViewController *weakSelf = self;
    __weak UIAttachmentBehavior *weakSpringAttachment = springAttachment;

    springAttachment.action = ^{
        __strong CMUIKitPinballViewController *strongSelf = weakSelf;

        CGFloat angle = [[strongSelf.leftFlipper.layer valueForKeyPath:@"transform.rotation.z"] floatValue];

        if (angle < -strongSelf.flipperAngle) {
            [strongSelf.dynamicAnimator removeBehavior:weakSpringAttachment];
            [strongSelf.dynamicAnimator addBehavior:self.leftFlipperAnchorAttachment];
        }
    };
}

@end
