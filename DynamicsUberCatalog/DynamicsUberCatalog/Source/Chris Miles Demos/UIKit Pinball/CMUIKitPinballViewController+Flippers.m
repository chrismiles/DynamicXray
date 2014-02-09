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
    CGSize flipperSize = self.flipperSize;

    UIDynamicItemBehavior *flipperItemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[]];
    flipperItemBehavior.density = 2.0f;
    flipperItemBehavior.elasticity = 0.4f;
    [self.dynamicAnimator addBehavior:flipperItemBehavior];

    {
        // Left Flipper
        UIView *flipper = [[UIView alloc] initWithFrame:CGRectMake(0, 0, flipperSize.width, flipperSize.height)];
        flipper.backgroundColor = [UIColor purpleColor];
        [self.view addSubview:flipper];

        [self.collisionBehavior addItem:flipper];
        [flipperItemBehavior addItem:flipper];

        UIOffset attachmentOffset = UIOffsetMake(flipperSize.height/2.0f - flipperSize.width/2.0f, 0);
        UIAttachmentBehavior *flipperRotationAttachment = [[UIAttachmentBehavior alloc] initWithItem:flipper offsetFromCenter:attachmentOffset attachedToAnchor:CGPointZero];
        [self.dynamicAnimator addBehavior:flipperRotationAttachment];
        self.leftFlipperRotationAttachment = flipperRotationAttachment;

        attachmentOffset = UIOffsetMake(flipperSize.width/2.0f, flipperSize.height/2.0f); // anchored bottom/right corner of view
        UIAttachmentBehavior *flipperAnchorAttachment = [[UIAttachmentBehavior alloc] initWithItem:flipper offsetFromCenter:attachmentOffset attachedToAnchor:CGPointZero];
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

    CGRect leftFlipperFrame = CGRectMake(10.0f, height - flipperSize.height*2.0f, flipperSize.width, flipperSize.height);
    self.leftFlipper.frame = leftFlipperFrame;
    [self.dynamicAnimator updateItemUsingCurrentState:self.leftFlipper];

    self.leftFlipperRotationAttachment.anchorPoint = CGPointMake(leftFlipperFrame.origin.x + flipperSize.height/2.0f, leftFlipperFrame.origin.y + flipperSize.height/2.0f);
    self.leftFlipperRotationAttachment.length = 0;

    CGFloat flipperAngle = 30.0f * M_PI / 180.0f;
    self.leftFlipperAnchorAttachment.anchorPoint = CGPointMake(leftFlipperFrame.origin.x + flipperSize.width * cosf(flipperAngle), leftFlipperFrame.origin.y + flipperSize.height * sinf(flipperAngle));
    self.leftFlipperAnchorAttachment.length = 0;
}

@end
