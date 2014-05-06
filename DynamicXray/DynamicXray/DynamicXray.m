//
//  DynamicXray.m
//  DynamicXray
//
//  Created by Chris Miles on 4/08/13.
//  Copyright (c) 2013-2014 Chris Miles. All rights reserved.
//

#import "DynamicXray.h"
#import "DynamicXray_Internal.h"
#import "DynamicXray+XrayContacts.h"
#import "DynamicXray+XrayPushBehavior.h"
#import "DynamicXray+XrayVisualiseBehaviors.h"

#import "DXRDynamicXrayView.h"
#import "DXRDynamicXrayWindowController.h"
#import "DXRContactHandler.h"


/*
    Enable one or both of these macro definitons to dump object information.
    This is normally only needed by DynamicXray developers.
 */
//#define DYNAMIC_ANIMATOR_OBJECT_INTROSPECTION
//#define DYNAMIC_BEHAVIOR_OBJECT_INTROSPECTION

#if defined(DYNAMIC_ANIMATOR_OBJECT_INTROSPECTION) || defined(DYNAMIC_BEHAVIOR_OBJECT_INTROSPECTION)
#   import "NSObject+CMObjectIntrospection.h"
#endif


/*
 * Configurables
 */

// How often to periodically check whether the xray view needs a redraw.
// This is required to prevent a stale xray view for cases like when the animator
// is paused and the reference view changes in some way (e.g. is removed from window).
// Note: this is a secondary redraw check. Normally the xray view is redrawn on
// every dynamic animator tick.
// Set this to 0 to disable it.
static NSTimeInterval const DynamicXrayRedrawCheckInterval = 0.25;     // seconds


/*
 * Globals
 */
NSString *const DynamicXrayVersion = @"0.1";


/*
 * Shared Private
 */
static DXRDynamicXrayWindowController *sharedXrayWindowController = nil;


@interface DynamicXray (XRayVisualStyleInternals)

- (void)updateDynamicsViewTransparencyLevels;

@end


@implementation DynamicXray

- (id)init
{
    self = [super init];
    if (self) {
        // Create a single shared UIWindow
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            if (sharedXrayWindowController == nil) {
                sharedXrayWindowController = [[DXRDynamicXrayWindowController alloc] init];
            }
        });

        _active = YES;

        _dynamicItemContactLifetimes = [NSMapTable weakToStrongObjectsMapTable];
        _pathContactLifetimes = [NSMapTable weakToStrongObjectsMapTable];
        _instantaneousPushBehaviorLifetimes = [NSMapTable weakToStrongObjectsMapTable];

        // Grab a strong reference to the shared XRay window (a new one is created on demand if needed)
        self.xrayWindow = sharedXrayWindowController.xrayWindow;

        _xrayViewController = [[DXRDynamicXrayViewController alloc] initDynamicXray:self];

        [sharedXrayWindowController presentDynamicXrayViewController:_xrayViewController];
        [self.xrayWindow setHidden:NO];

        [self updateDynamicsViewTransparencyLevels];

        [self setDrawDynamicItemsEnabled:YES];

        __weak DynamicXray *weakSelf = self;
        self.action = ^{
            __strong DynamicXray *strongSelf = weakSelf;
            [strongSelf redraw];
        };

        [self scheduleDelayedRedrawCheckRepeats:YES];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dynamicXrayContactDidBeginNotification:) name:DXRDynamicXrayContactDidBeginNotification object:[DXRContactHandler class]];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dynamicXrayContactDidEndNotification:) name:DXRDynamicXrayContactDidEndNotification object:[DXRContactHandler class]];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(instantaneousPushBehaviorDidBecomeActiveNotification:) name:DXRDynamicXrayInstantaneousPushBehaviorDidBecomeActiveNotification object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    [sharedXrayWindowController dismissDynamicXrayViewController:self.xrayViewController];
    [sharedXrayWindowController dismissConfigViewController];
}


#pragma mark - Active

- (void)setActive:(BOOL)active
{
    if (active != _active) {
        _active = active;

        if (active) {
            [self introspectDynamicAnimator:self.dynamicAnimator];
        }
    }

    self.xrayViewController.view.hidden = (active == NO);
}


#pragma mark - Xray Window Controller

- (DXRDynamicXrayWindowController *)xrayWindowController
{
    return sharedXrayWindowController;
}


#pragma mark - Xray View

- (DXRDynamicXrayView *)xrayView
{
    return self.xrayViewController.xrayView;
}


#pragma mark - Redraw

- (void)redraw
{
    //[self calcFPS];
    [self introspectDynamicAnimator:self.dynamicAnimator];
}

- (void)calcFPS
{
    // FPS
    static double fps_prev_time = 0;
    static NSUInteger fps_count = 0;

    /* FPS */
    double curr_time = CACurrentMediaTime();
    if (curr_time - fps_prev_time >= 0.5) {
        double delta = (curr_time - fps_prev_time) / fps_count;
        NSString *fpsDescription = [NSString stringWithFormat:@"%0.0f fps", 1.0/delta];
        NSLog(@"Animator FPS: %@", fpsDescription);
        fps_prev_time = curr_time;
        fps_count = 1;
    }
    else {
        fps_count++;
    }
}

- (void)scheduleDelayedRedrawCheckRepeats:(BOOL)repeats
{
    if (DynamicXrayRedrawCheckInterval > 0) {
        __weak DynamicXray *weakSelf = self;
        double delayInSeconds = DynamicXrayRedrawCheckInterval;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            if (weakSelf) {
                __strong DynamicXray *strongSelf = weakSelf;
                [strongSelf redrawIfNeeded];

                if (repeats) {
                    [strongSelf scheduleDelayedRedrawCheckRepeats:repeats];
                }
            }
        });
    }
}

- (void)redrawIfNeeded
{
    // Only redraws if the reference view has changed

    [self findReferenceView];
    __strong UIView *referenceView = self.referenceView;

    BOOL needsRedraw = NO;

    if (referenceView != self.previousReferenceView) {
        needsRedraw = YES;
    }
    else if (referenceView) {
        if (referenceView.window != self.previousReferenceViewWindow) {
            needsRedraw = YES;
        }
        else if (CGRectEqualToRect(referenceView.frame, self.previousReferenceViewFrame) == NO) {
            needsRedraw = YES;
        }
    }

    if (needsRedraw) {
        [self redraw];
    }

    self.previousReferenceViewFrame = referenceView.frame;
    self.previousReferenceViewWindow = referenceView.window;
    self.previousReferenceView = referenceView;
}


#pragma mark - Introspect Dynamic Behavior

- (void)introspectDynamicAnimator:(UIDynamicAnimator *)dynamicAnimator
{
    if ([self isActive] == NO) return;

#ifdef DYNAMIC_ANIMATOR_OBJECT_INTROSPECTION
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [dynamicAnimator CMObjectIntrospectionDumpInfo];
    });
#endif

    [self findReferenceView];

    if ([self referenceViewIsVisible]) {
        [self introspectBehaviors:dynamicAnimator.behaviors];
    }

    [self.xrayViewController.xrayView setNeedsDisplay];
}

- (BOOL)referenceViewIsVisible
{
    __strong UIView *referenceView = self.referenceView;
    if (referenceView && referenceView.window == nil) {
        // If reference view is available, but it is not attached to a window, then it is not visible
        return NO;
    }

    return YES;
}

- (void)findReferenceView
{
    UIView *referenceView = self.dynamicAnimator.referenceView;
    if (referenceView == nil) {
        UICollectionViewLayout *referenceSystem = [self.dynamicAnimator valueForKey:@"referenceSystem"];
        if (referenceSystem) {
            if ([referenceSystem respondsToSelector:@selector(collectionView)]) {
                referenceView = referenceSystem.collectionView;
            }
            else {
                DLog(@"Unknown reference system: %@", referenceSystem);
            }
        }
    }

    self.referenceView = referenceView;
}

- (void)introspectBehaviors:(NSArray *)behaviors
{
    DXRDynamicXrayView *xrayView = [self xrayView];
    xrayView.dynamicsReferenceView = self.referenceView;

    [self.dynamicItemsToDraw removeAllObjects];

    for (UIDynamicBehavior *behavior in behaviors)
    {
        
#ifdef DYNAMIC_BEHAVIOR_OBJECT_INTROSPECTION
        if ([behavior isKindOfClass:[DynamicXray class]] == NO) {
            [behavior CMObjectIntrospectionDumpInfo];
        }
#endif
        
	if ([behavior isKindOfClass:[UIAttachmentBehavior class]]) {
	    [self visualiseAttachmentBehavior:(UIAttachmentBehavior *)behavior];
	}
	else if ([behavior isKindOfClass:[UICollisionBehavior class]]) {
	    [self visualiseCollisionBehavior:(UICollisionBehavior *)behavior];
	}
	else if ([behavior isKindOfClass:[UIGravityBehavior class]]) {
	    [self visualiseGravityBehavior:(UIGravityBehavior *)behavior];
	}
	else if ([behavior isKindOfClass:[UISnapBehavior class]]) {
	    [self visualiseSnapBehavior:(UISnapBehavior *)behavior];
	}
	else if ([behavior isKindOfClass:[UIPushBehavior class]]) {
            // Only visualise continuous push behaviors here
            UIPushBehavior *pushBehavior = (UIPushBehavior *)behavior;
            if (pushBehavior.mode == UIPushBehaviorModeContinuous) {
                [self visualisePushBehavior:pushBehavior];
            }
	}

        /* Introspect any child behaviors.
         */
        if ([behavior.childBehaviors count] > 0) {
            [self introspectBehaviors:behavior.childBehaviors];
        }
    }

    // Instantaneous push behaviors need to be captured out-of-band
    [self introspectInstantaneousPushBehaviors];

    // Draw any dynamic items
    [xrayView drawDynamicItems:self.dynamicItemsToDraw contactedItems:self.dynamicItemContactLifetimes];

    // Draw any contact paths above all else
    [xrayView drawContactPaths:self.pathContactLifetimes];
}


#pragma mark - Color

+ (UIColor *)xrayStrokeColor
{
    return [UIColor colorWithRed:0 green:0.639216f blue:0.85098f alpha:1.0f];
}

+ (UIColor *)xrayFillColor
{
    return [self xrayStrokeColor];
}

+ (UIColor *)xrayContactColor
{
    return [UIColor colorWithRed:1.0f green:0.478431f blue:0.0941176f alpha:1.0f];
}

@end
