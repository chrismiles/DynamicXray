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
        CGRect flipperFrame = CGRectMake(0, 0, flipperSize.width, flipperSize.height);
        UIView *flipper = [[UIView alloc] initWithFrame:flipperFrame];
        flipper.backgroundColor = [UIColor purpleColor];
        flipper.layer.cornerRadius = flipperSize.height / 2.0f;
        flipper.layer.masksToBounds = YES;
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

    {
        // Right Flipper
        CGRect flipperFrame = CGRectMake(0, 0, flipperSize.width, flipperSize.height);
        UIView *flipper = [[UIView alloc] initWithFrame:flipperFrame];
        flipper.backgroundColor = [UIColor purpleColor];
        flipper.layer.cornerRadius = flipperSize.height / 2.0f;
        flipper.layer.masksToBounds = YES;
        [self.view addSubview:flipper];

        [self.collisionBehavior addItem:flipper];
        [flipperItemBehavior addItem:flipper];

        UIOffset attachmentOffset = UIOffsetMake(flipperSize.width/2.0f - flipperSize.height/2.0f, 0);
        UIAttachmentBehavior *flipperRotationAttachment = [[UIAttachmentBehavior alloc] initWithItem:flipper offsetFromCenter:attachmentOffset attachedToAnchor:CGPointZero];
        flipperRotationAttachment.length = 0;
        [self.dynamicAnimator addBehavior:flipperRotationAttachment];
        self.rightFlipperRotationAttachment = flipperRotationAttachment;

        attachmentOffset = UIOffsetMake(-flipperSize.width/2.0f, 0); // anchored left side of view
        UIAttachmentBehavior *flipperAnchorAttachment = [[UIAttachmentBehavior alloc] initWithItem:flipper offsetFromCenter:attachmentOffset attachedToAnchor:CGPointZero];
        flipperAnchorAttachment.length = 0;
        flipperAnchorAttachment.damping = 1.0f;
        flipperAnchorAttachment.frequency = 20.0f;
        [self.dynamicAnimator addBehavior:flipperAnchorAttachment];
        self.rightFlipperAnchorAttachment = flipperAnchorAttachment;

        self.rightFlipper = flipper;
    }
    
    [self layoutFlippers];
}

- (void)layoutFlippers
{
    CGRect bounds = self.view.bounds;
    CGFloat width = CGRectGetWidth(bounds);
    CGFloat height = CGRectGetHeight(bounds);
    CGSize flipperSize = self.flipperSize;
    CGFloat flipperAngle = self.flipperAngle;
    CGFloat sideMargin = 8.0f;

    {
        // Layout left flipper
        CGRect flipperFrame = CGRectMake(sideMargin,
                                         height - flipperSize.height*3.0f,
                                         flipperSize.width,
                                         flipperSize.height);

        CGPoint rotationAnchorPoint = CGPointMake(flipperFrame.origin.x + flipperSize.height/2.0f,
                                                  flipperFrame.origin.y + flipperSize.height/2.0f);
        self.leftFlipperRotationAttachment.anchorPoint = rotationAnchorPoint;
        self.leftFlipperRotationAttachment.length = 0;

        CGFloat calcLength = flipperSize.width - flipperSize.height/2.0f;
        self.leftFlipperAnchorAttachment.anchorPoint = CGPointMake(rotationAnchorPoint.x + calcLength * cosf(flipperAngle),
                                                                   rotationAnchorPoint.y + calcLength * sinf(flipperAngle));
        self.leftFlipperAnchorAttachment.length = 0;
    }

    {
        // Layout right flipper
        CGRect flipperFrame = CGRectMake(width - self.launcherWidth - self.launcherWallSize.width - sideMargin - flipperSize.width,
                                         height - flipperSize.height*3.0f,
                                         flipperSize.width,
                                         flipperSize.height);

        CGPoint rotationAnchorPoint = CGPointMake(CGRectGetMaxX(flipperFrame) - flipperSize.height/2.0f,
                                                  flipperFrame.origin.y + flipperSize.height/2.0f);
        self.rightFlipperRotationAttachment.anchorPoint = rotationAnchorPoint;
        self.rightFlipperRotationAttachment.length = 0;

        CGFloat calcLength = flipperSize.width - flipperSize.height/2.0f;
        self.rightFlipperAnchorAttachment.anchorPoint = CGPointMake(rotationAnchorPoint.x + calcLength * cosf(M_PI - flipperAngle),
                                                                    rotationAnchorPoint.y + calcLength * sinf(M_PI - flipperAngle));
        self.rightFlipperAnchorAttachment.length = 0;
    }
}

- (void)setupFlipperButtons
{
    CGRect bounds = self.view.bounds;
    CGFloat width = CGRectGetWidth(bounds);
    CGFloat height = CGRectGetHeight(bounds);
    CGFloat playAreaWidth = width - self.launcherWidth;
    CGSize buttonSize = CGSizeMake(playAreaWidth/2.0f, height);

    {
        // Lift flipper button
        CGRect frame = CGRectMake(0, height - buttonSize.height, buttonSize.width, buttonSize.height);
        UIView *leftFlipperButton = [[UIView alloc] initWithFrame:frame];
        leftFlipperButton.autoresizingMask = (UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin);
        //leftFlipperButton.backgroundColor = [[UIColor yellowColor] colorWithAlphaComponent:0.1f]; // DEBUG
        [self.view addSubview:leftFlipperButton];

        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(leftFlipperTapGesture:)];
        [leftFlipperButton addGestureRecognizer:tapGestureRecognizer];
    }

    {
        // Right flipper button
        CGRect frame = CGRectMake(playAreaWidth - buttonSize.width, height - buttonSize.height, buttonSize.width, buttonSize.height);
        UIView *rightFlipperButton = [[UIView alloc] initWithFrame:frame];
        rightFlipperButton.autoresizingMask = (UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin);
        //rightFlipperButton.backgroundColor = [[UIColor orangeColor] colorWithAlphaComponent:0.1f]; // DEBUG
        [self.view addSubview:rightFlipperButton];

        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rightFlipperTapGesture:)];
        [rightFlipperButton addGestureRecognizer:tapGestureRecognizer];
    }
}

- (void)leftFlipperTapGesture:(__unused UITapGestureRecognizer *)tapGestureRecognizer
{
    [self   fireFlipper:self.leftFlipper
 withRotationAttachment:self.leftFlipperRotationAttachment
       anchorAttachment:self.leftFlipperAnchorAttachment
 springAttachmentOffset:UIOffsetMake(self.flipperSize.width/2.0f, 0)
         toFlipperAngle:-self.flipperAngle];
}

- (void)rightFlipperTapGesture:(__unused UITapGestureRecognizer *)tapGestureRecognizer
{
    [self   fireFlipper:self.rightFlipper
 withRotationAttachment:self.rightFlipperRotationAttachment
       anchorAttachment:self.rightFlipperAnchorAttachment
 springAttachmentOffset:UIOffsetMake(-self.flipperSize.width/2.0f, 0)
         toFlipperAngle:(self.flipperAngle)];
}

- (void)fireFlipper:(UIView *)flipper withRotationAttachment:(UIAttachmentBehavior *)rotationAttachment anchorAttachment:(UIAttachmentBehavior *)anchorAttachment springAttachmentOffset:(UIOffset)attachmentOffset
     toFlipperAngle:(CGFloat)flipperAngle
{
    CGPoint rotationPoint = rotationAttachment.anchorPoint;

    [self.dynamicAnimator removeBehavior:anchorAttachment];

    CGPoint anchorPoint = anchorAttachment.anchorPoint;
    anchorPoint.y = rotationPoint.y - (anchorPoint.y - rotationPoint.y);

    UIAttachmentBehavior *springAttachment = [[UIAttachmentBehavior alloc] initWithItem:flipper offsetFromCenter:attachmentOffset attachedToAnchor:anchorPoint];
    springAttachment.length = 0;
    springAttachment.damping = 0.8f;
    springAttachment.frequency = 10.0f;
    [self.dynamicAnimator addBehavior:springAttachment];

    CGFloat startAngle = [[flipper.layer valueForKeyPath:@"transform.rotation.z"] floatValue];
    CGFloat maxAngleDelta = (CGFloat)fabs(flipperAngle - startAngle);

    __weak CMUIKitPinballViewController *weakSelf = self;
    __weak UIAttachmentBehavior *weakSpringAttachment = springAttachment;

    springAttachment.action = ^{
        CGFloat angle = [[flipper.layer valueForKeyPath:@"transform.rotation.z"] floatValue];
        CGFloat angleDelta = (CGFloat)fabs(angle - startAngle);

        if (angleDelta > maxAngleDelta) {
            __strong CMUIKitPinballViewController *strongSelf = weakSelf;

            [strongSelf.dynamicAnimator removeBehavior:weakSpringAttachment];
            [strongSelf.dynamicAnimator addBehavior:anchorAttachment];
        }
    };
}

@end
