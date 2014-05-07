//
//  CMUIKitPinballViewController.m
//  DynamicXrayCatalog
//
//  Created by Chris Miles on 3/02/2014.
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
#import "CMUIKitPinballViewController_Private.h"
#import "CMUIKitPinballViewController+Bumpers.h"
#import "CMUIKitPinballViewController+Configuration.h"
#import "CMUIKitPinballViewController+Edges.h"
#import "CMUIKitPinballViewController+Flippers.h"
#import "CMUIKitPinballViewController+Launcher.h"


static NSString * const LaunchButtonBoundary = @"LaunchButtonBoundary";


@implementation CMUIKitPinballViewController

- (void)awakeFromNib
{
    self.ballsInPlay = [NSMutableArray array];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationController.toolbarHidden = YES;

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Xray" style:UIBarButtonItemStyleBordered target:self action:@selector(xrayAction:)];

    [self configureSizesWithViewBounds:self.view.bounds];

    [self setupDynamics];
    [self setupEdges];
    [self setupLauncher];
    [self setupFlippers];
    [self setupFlipperButtons];
    [self setupBumpers];

    //[self.dynamicXray setActive:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [self addBall];
}

- (void)viewDidLayoutSubviews
{
    CGSize boundsSize = self.view.bounds.size;
    if (CGSizeEqualToSize(boundsSize, self.lastBoundsSize) == NO) {
        self.lastBoundsSize = boundsSize;

        [self configureSizesWithViewBounds:self.view.bounds];

        [self setupEdges];
        [self setupLauncher];
        [self layoutFlippers];
        [self setupFlipperButtons];
        [self setupBumpers];
    }
}

- (void)configureSizesWithViewBounds:(CGRect)bounds
{
    self.launcherWidth = ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad ? 120.0f : 60.0f);
    self.launchButtonHeight = 60.0f;
    self.launchSpringHeight = 180.0f;
    self.flipperAngle = ConfigValueForIdiom(CMUIKitPinballFlipperAnglePad, CMUIKitPinballFlipperAnglePhone) * M_PI / 180.0f;

    CGSize flipperSize = ConfigValueForIdiom((UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation) ? CMUIKitPinballFlipperSizePadLandscape : CMUIKitPinballFlipperSizePadPortrait), CMUIKitPinballFlipperSizePhone);

    self.flipperSize = flipperSize;

    self.launcherWallSize = CGSizeMake(4.0f, CGRectGetHeight(bounds) * 0.5f);
}


#pragma mark - Set Up Dynamics

- (void)setupDynamics
{
    if (self.dynamicAnimator == nil) {
        __weak CMUIKitPinballViewController *weakSelf = self;

        UIDynamicAnimator *dynamicAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];

        UIGravityBehavior *gravityBehavior = [[UIGravityBehavior alloc] initWithItems:@[]];
        gravityBehavior.action = ^{
            __strong CMUIKitPinballViewController *strongSelf = weakSelf;
            [strongSelf checkLostBalls];
        };
        [dynamicAnimator addBehavior:gravityBehavior];

        UICollisionBehavior *collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[]];
        collisionBehavior.collisionDelegate = self;
        collisionBehavior.collisionMode = UICollisionBehaviorModeEverything;
        [dynamicAnimator addBehavior:collisionBehavior];

        UIDynamicItemBehavior *launchSpringItemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[]];
        launchSpringItemBehavior.allowsRotation = NO;
        [dynamicAnimator addBehavior:launchSpringItemBehavior];

        self.dynamicAnimator = dynamicAnimator;
        self.collisionBehavior = collisionBehavior;
        self.gravityBehavior = gravityBehavior;
        self.launchSpringItemBehavior = launchSpringItemBehavior;
    }
}


#pragma mark - Add "Ball"

- (void)addBall
{
    if (self.ballReadyForLaunch == nil) {
        UIView *newBall;

        u_int32_t selection = arc4random_uniform(6);
        if (selection == 0) {
            newBall = [[UISwitch alloc] initWithFrame:CGRectZero];
            [(UISwitch *)newBall setOn:YES];
        }
        else if (selection == 1) {
            UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            activityView.color = [UIColor orangeColor];
            [activityView startAnimating];
            newBall = activityView;
        }
        else if (selection == 2) {
            UISegmentedControl *segmented = [[UISegmentedControl alloc] initWithItems:@[@"1", @"2"]];
            [segmented setSelectedSegmentIndex:0];
            newBall = segmented;
        }
        else if (selection == 3) {
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 60.0f, 25.0f)];
            textField.placeholder = @"Text";
            textField.borderStyle = UITextBorderStyleRoundedRect;
            newBall = textField;
        }
        else if (selection == 4) {
            UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, 60.0f, 25.0f)];
            [slider setValue:0.5f];
            newBall = slider;
        }
        else if (selection == 5) {
            UIStepper *stepper = [[UIStepper alloc] initWithFrame:CGRectZero];
            [stepper sizeToFit];
            newBall = stepper;
        }

        [newBall sizeToFit];

        CGSize ballSize = newBall.bounds.size;
        CGFloat launcherEndY = [self launcherEndYPos];

        newBall.center = CGPointMake(CGRectGetWidth(self.view.bounds) - self.launcherWidth/2.0f,
                                     launcherEndY - ballSize.height/2.0f);
        [self.view addSubview:newBall];

        [self.gravityBehavior addItem:newBall];
        [self.collisionBehavior addItem:newBall];

        self.ballReadyForLaunch = newBall;
        [self.ballsInPlay addObject:newBall];
    }
}

- (void)removeBall:(UIView *)ball
{
    [ball removeFromSuperview];

    [self.gravityBehavior removeItem:ball];
    [self.collisionBehavior removeItem:ball];

    [self.ballsInPlay removeObject:ball];
    if (self.ballReadyForLaunch == ball) self.ballReadyForLaunch = nil;
}

- (void)checkLostBalls
{
    CGRect bounds = self.view.bounds;

    for (UIView *ball in [self.ballsInPlay copy]) {
        CGRect frame = ball.frame;
        if (CGRectIntersectsRect(frame, bounds) == NO) {
            [self removeBall:ball];
        }
    }

    if ([self.ballsInPlay count] == 0) {
        [self addBall];
    }
}


#pragma mark - Colours

- (UIColor *)wallColour
{
    return [UIColor darkGrayColor];
}


#pragma mark - DynamicXray

- (DynamicXray *)dynamicXray
{
    if (_dynamicXray == nil) {
        _dynamicXray = [[DynamicXray alloc] init];
        _dynamicXray.active = NO;

        [self.dynamicAnimator addBehavior:_dynamicXray];
    }

    return _dynamicXray;
}

- (void)xrayAction:(__unused id)sender
{
    [self.dynamicXray presentConfigurationViewController];
}


#pragma mark - UICollisionBehaviorDelegate

- (void)collisionBehavior:(__unused UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item withBoundaryIdentifier:(id<NSCopying>)identifier atPoint:(CGPoint)p
{
    //DLog(@"%@ item: %@ identifier: %@", behavior, item, identifier);

    NSString *boundaryID = (NSString *)identifier;
    if ([boundaryID isKindOfClass:[NSString class]]) {
        if ([boundaryID hasPrefix:CMUIKitPinballBumperBoundaryIdentifierPrefix]) {
            [self handleBumperContactWithBoundaryIdentifier:boundaryID item:item atPoint:p];
        }
    }
}

//- (void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item1 withItem:(id<UIDynamicItem>)item2 atPoint:(CGPoint)p
//{
//    [self checkBumperContactWithItem1:item1 item2:item2 atPoint:p];
//}

@end
