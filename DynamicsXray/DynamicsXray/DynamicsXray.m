//
//  DynamicsXray.m
//  DynamicsXray
//
//  Created by Chris Miles on 4/08/13.
//  Copyright (c) 2013-2014 Chris Miles. All rights reserved.
//

#import "DynamicsXray.h"
#import "DynamicsXray_Internal.h"
#import "DXRDynamicsXrayView.h"
#import "DXRDynamicsXrayWindowController.h"
#import "DXRContactHandler.h"
#import "DXRContactLifetime.h"


/*
    Enable one or both of these macro definitons to dump object information.
    This is normally only needed by DynamicsXray developers.
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
static NSTimeInterval const DynamicsXrayRedrawCheckInterval = 0.25;     // seconds


/*
 * Globals
 */
NSString *const DynamicsXrayVersion = @"0.1";


/*
 * Shared Private
 */
static DXRDynamicsXrayWindowController *sharedXrayWindowController = nil;


@interface DynamicsXray (XRayVisualStyleInternals)

- (void)updateDynamicsViewTransparencyLevels;

@end


@implementation DynamicsXray

- (id)init
{
    self = [super init];
    if (self) {
        // Create a single shared UIWindow
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            if (sharedXrayWindowController == nil) {
                sharedXrayWindowController = [[DXRDynamicsXrayWindowController alloc] init];
            }
        });

        _active = YES;

        _dynamicItemsContactCount = [NSMapTable weakToStrongObjectsMapTable];
        _pathsContactCount = [NSMapTable weakToStrongObjectsMapTable];

        // Grab a strong reference to the shared XRay window (a new one is created on demand if needed)
        self.xrayWindow = sharedXrayWindowController.xrayWindow;

        _xrayViewController = [[DXRDynamicsXrayViewController alloc] initDynamicsXray:self];

        [sharedXrayWindowController presentDynamicsXrayViewController:_xrayViewController];
        [self.xrayWindow setHidden:NO];

        [self updateDynamicsViewTransparencyLevels];

        [self setDrawDynamicItemsEnabled:YES];

        __weak DynamicsXray *weakSelf = self;
        self.action = ^{
            __strong DynamicsXray *strongSelf = weakSelf;
            [strongSelf redraw];
        };

        [self scheduleDelayedRedrawCheckRepeats:YES];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dynamicsXrayContactDidBeginNotification:) name:DXRDynamicsXrayContactDidBeginNotification object:[DXRContactHandler class]];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dynamicsXrayContactDidEndNotification:) name:DXRDynamicsXrayContactDidEndNotification object:[DXRContactHandler class]];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    [sharedXrayWindowController dismissDynamicsXrayViewController:self.xrayViewController];
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


#pragma mark - Xray View

- (DXRDynamicsXrayView *)xrayView
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
    if (DynamicsXrayRedrawCheckInterval > 0) {
        __weak DynamicsXray *weakSelf = self;
        double delayInSeconds = DynamicsXrayRedrawCheckInterval;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            if (weakSelf) {
                [weakSelf redrawIfNeeded];

                if (repeats) {
                    [weakSelf scheduleDelayedRedrawCheckRepeats:repeats];
                }
            }
        });
    }
}

- (void)redrawIfNeeded
{
    // Only redraws if the reference view has changed

    [self findReferenceView];

    BOOL needsRedraw = NO;

    if (self.referenceView != self.previousReferenceView) {
        needsRedraw = YES;
    }
    else if (self.referenceView) {
        if (self.referenceView.window != self.previousReferenceViewWindow) {
            needsRedraw = YES;
        }
        else if (CGRectEqualToRect(self.referenceView.frame, self.previousReferenceViewFrame) == NO) {
            needsRedraw = YES;
        }
    }

    if (needsRedraw) {
        [self redraw];
    }

    self.previousReferenceViewFrame = self.referenceView.frame;
    self.previousReferenceViewWindow = self.referenceView.window;
    self.previousReferenceView = self.referenceView;
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
    if (self.referenceView && self.referenceView.window == nil) {
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
    [self.dynamicItemsToDraw removeAllObjects];

    for (UIDynamicBehavior *behavior in behaviors)
    {
        
#ifdef DYNAMIC_BEHAVIOR_OBJECT_INTROSPECTION
        if ([behavior isKindOfClass:[DynamicsXray class]] == NO) {
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

        /* Introspect any child behaviors.
         */
        if ([behavior.childBehaviors count] > 0) {
            [self introspectBehaviors:behavior.childBehaviors];
        }
    }

    [self.xrayViewController.xrayView drawDynamicItems:self.dynamicItemsToDraw contactedItems:self.dynamicItemsContactCount withReferenceView:self.referenceView];
    [self.xrayViewController.xrayView drawContactPaths:self.pathsContactCount withReferenceView:self.referenceView];
}


#pragma mark - Attachment Behavior

- (void)visualiseAttachmentBehavior:(UIAttachmentBehavior *)attachmentBehavior
{
    NSValue *anchorPointAValue = [attachmentBehavior valueForKey:@"anchorPointA"];
    
    CGPoint anchorPointA = CGPointZero;
    if (anchorPointAValue) anchorPointA = [anchorPointAValue CGPointValue];
    
    id<UIDynamicItem> itemA = nil;
    id<UIDynamicItem> itemB = nil;
    
    itemA = attachmentBehavior.items[0];
    
    if ([attachmentBehavior.items  count] > 1) {
        itemB = attachmentBehavior.items[1];
    }
    
    CGPoint anchorPoint, attachmentPoint;
    
    if (itemB) {
        // Item to Item

        CGPoint anchorPointB = CGPointZero;
        NSValue *anchorPointBValue = [attachmentBehavior valueForKey:@"anchorPointB"];
        if (anchorPointBValue) anchorPointB = [anchorPointBValue CGPointValue];

        anchorPoint = itemA.center;
        anchorPointA = CGPointApplyAffineTransform(anchorPointA, itemA.transform);
        anchorPoint.x += anchorPointA.x;
        anchorPoint.y += anchorPointA.y;
        anchorPoint = [self.xrayView convertPoint:anchorPoint fromReferenceView:self.referenceView];

        attachmentPoint = itemB.center;
        anchorPointB = CGPointApplyAffineTransform(anchorPointB, itemB.transform);
        attachmentPoint.x += anchorPointB.x;
        attachmentPoint.y += anchorPointB.y;
        attachmentPoint = [self.xrayView convertPoint:attachmentPoint fromReferenceView:self.referenceView];
    }
    else {
        // Anchor to Item
        
        anchorPoint = [self.xrayView convertPoint:attachmentBehavior.anchorPoint fromReferenceView:self.referenceView];

        attachmentPoint = itemA.center;
        anchorPointA = CGPointApplyAffineTransform(anchorPointA, itemA.transform);
        attachmentPoint.x += anchorPointA.x;
        attachmentPoint.y += anchorPointA.y;
        attachmentPoint = [self.xrayView convertPoint:attachmentPoint fromReferenceView:self.referenceView];
    }
    
    BOOL isSpring = (attachmentBehavior.frequency > 0.0);
    
    [self.xrayViewController.xrayView drawAttachmentFromAnchor:anchorPoint toPoint:attachmentPoint length:attachmentBehavior.length isSpring:isSpring];

    [self.dynamicItemsToDraw addObjectsFromArray:attachmentBehavior.items];
}


#pragma mark - Collision Behavior

- (void)visualiseCollisionBehavior:(UICollisionBehavior *)collisionBehavior
{
    // TODO: boundaries by identifier
    //NSArray *boundaryIdentifiers = collisionBehavior.boundaryIdentifiers;
    //DLog(@"boundaryIdentifiers: %@", boundaryIdentifiers);

    if (collisionBehavior.translatesReferenceBoundsIntoBoundary) {
        UIView *referenceView = collisionBehavior.dynamicAnimator.referenceView;
        CGRect referenceBoundaryFrame = referenceView.frame;
        CGRect boundaryRect = [self.xrayViewController.xrayView convertRect:referenceBoundaryFrame fromView:referenceView.superview];
        [self.xrayViewController.xrayView drawBoundsCollisionBoundaryWithRect:boundaryRect];
    }

    [self.dynamicItemsToDraw addObjectsFromArray:collisionBehavior.items];
}


#pragma mark - Gravity Behavior

- (void)visualiseGravityBehavior:(UIGravityBehavior *)gravityBehavior
{
    [self.xrayViewController.xrayView drawGravityBehaviorWithMagnitude:gravityBehavior.magnitude angle:gravityBehavior.angle];

    [self.dynamicItemsToDraw addObjectsFromArray:gravityBehavior.items];
}


#pragma mark - Contact Notifications

- (void)dynamicsXrayContactDidBeginNotification:(NSNotification *)notification
{
    id<UIDynamicItem> dynamicItem = notification.userInfo[@"dynamicItem"];
    if (dynamicItem) {
        //DLog(@"DynamicItem did begin contact: %@", dynamicItem);
        DXRContactLifetime *contactLifetime = [self.dynamicItemsContactCount objectForKey:dynamicItem];
        if (contactLifetime == nil) {
            contactLifetime = [[DXRContactLifetime alloc] init];
            [self.dynamicItemsContactCount setObject:contactLifetime forKey:dynamicItem];
        }
        [contactLifetime incrementCount];
    }

    CGPathRef path = CFBridgingRetain(notification.userInfo[@"path"]);
    if (path) {
        id key = CFBridgingRelease(path);
        DXRContactLifetime *contactLifetime = [self.pathsContactCount objectForKey:key];
        if (contactLifetime == nil) {
            contactLifetime = [[DXRContactLifetime alloc] init];
            [self.pathsContactCount setObject:contactLifetime forKey:key];
        }
        [contactLifetime incrementCount];
    }
}

- (void)dynamicsXrayContactDidEndNotification:(NSNotification *)notification
{
    id<UIDynamicItem> dynamicItem = notification.userInfo[@"dynamicItem"];
    if (dynamicItem) {
        //DLog(@"DynamicItem did end contact: %@", dynamicItem);
        DXRContactLifetime *contactLifetime = [self.dynamicItemsContactCount objectForKey:dynamicItem];
        [contactLifetime decrementCount];

        if ([contactLifetime decay] <= 0) {
            [self.dynamicItemsContactCount removeObjectForKey:dynamicItem];
        }
    }

    CGPathRef path = CFBridgingRetain(notification.userInfo[@"path"]);
    if (path) {
        id key = CFBridgingRelease(path);
        DXRContactLifetime *contactLifetime = [self.pathsContactCount objectForKey:key];
        [contactLifetime decrementCount];

        if ([contactLifetime decay] <= 0) {
            [self.pathsContactCount removeObjectForKey:key];
        }
    }
}

@end


@implementation DynamicsXray (XrayUserInterface)

- (void)presentConfigurationViewController
{
    [sharedXrayWindowController presentConfigViewControllerWithDynamicsXray:self animated:YES];
}

@end
