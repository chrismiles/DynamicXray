//
//  BHLoadingPattie.m
//  Burgerhead
//
//  Created by Peter Hare on 3/03/2014.
//  Copyright (c) 2014 Burgerhead. All rights reserved.
//

#import "BHLoadingPatty.h"
#import <DynamicXray/DynamicXray.h>

static CGFloat const kDuration = 0.2;
static NSString *const kPattyBoundaryIdentifier = @"PattyBoundary";

@interface BHLoadingPatty ()

@property UIDynamicAnimator *animator;
@property UICollisionBehavior *collisions;
@property NSArray *pattyViews;

@end

@implementation BHLoadingPatty

+ (instancetype)instanceShownInView:(UIView *)view
{
    BHLoadingPatty *loadingView = [[self alloc] initWithFrame:view.bounds];
    [view addSubview:loadingView];
    loadingView.alpha = 0.;

    [UIView animateWithDuration:kDuration animations:^{
        loadingView.alpha = 1.;
    }];

    return loadingView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self];
        self.pattyViews = @[[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loading-bun-bottom"]],
                            [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loading-patty-middle"]],
                            [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loading-bun-top"]]];
        [self.pattyViews enumerateObjectsUsingBlock:^(UIView *view, __unused NSUInteger idx, __unused BOOL *stop) {
            [self addSubview:view];
        }];

        [self setupDynamics];
    }
    return self;
}

- (void)setupDynamics
{
    [self.animator addBehavior:[[DynamicXray alloc] init]];

    srand48(time(0));

    [self setPattyPositions];

    UIGravityBehavior *gravity = [[UIGravityBehavior alloc] initWithItems:self.pattyViews];
    [self.animator addBehavior:gravity];

    UIDynamicItemBehavior *bounce = [[UIDynamicItemBehavior alloc] initWithItems:self.pattyViews];
    bounce.elasticity = 0.6;
    [self.animator addBehavior:bounce];

    self.collisions = [[UICollisionBehavior alloc] initWithItems:self.pattyViews];
    [self addHalfwayCollision];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removePattyBoundary];
    });

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self resetSystem];
    });
}

- (void)setPattyPositions
{
    [self.pattyViews enumerateObjectsUsingBlock: ^(UIView *view, NSUInteger index, __unused BOOL *stop) {
        CGSize size = [view sizeThatFits:CGSizeZero];
        view.transform = CGAffineTransformIdentity;
        view.frame = CGRectMake((self.bounds.size.width - view.frame.size.width) / 2., 80. - 30.*index, size.width, size.height);
        view.transform = CGAffineTransformMakeRotation((drand48() - 0.5) * M_PI_2/8.);
        view.alpha = 0.;
        [UIView animateWithDuration:0.6 animations:^{
            view.alpha = 1.;
        }];
        [self.animator updateItemUsingCurrentState:view];
    }];
}

- (void)removePattyBoundary
{
    [self.collisions removeBoundaryWithIdentifier:kPattyBoundaryIdentifier];
    [self.pattyViews enumerateObjectsUsingBlock:^(UIView *view, __unused NSUInteger idx, __unused BOOL *stop) {
        [UIView animateWithDuration:0.6 animations:^{
            view.alpha = 0.;
        }];
    }];
}

- (void)addHalfwayCollision
{
    [self.collisions addBoundaryWithIdentifier:kPattyBoundaryIdentifier fromPoint:CGPointMake(0., self.bounds.size.height/2.) toPoint:CGPointMake(self.bounds.size.width, self.bounds.size.height/2.)];
    [self.animator addBehavior:self.collisions];
}

- (void)resetSystem
{
    [self.animator removeAllBehaviors];
    [self setupDynamics];
}

- (void)hide
{
    [UIView animateWithDuration:kDuration animations:^{
        self.alpha = 0.;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
