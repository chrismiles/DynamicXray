//
//  DXRDynamicsXrayView.m
//  DynamicsXray
//
//  Created by Chris Miles on 4/08/13.
//  Copyright (c) 2013 Chris Miles. All rights reserved.
//

#import "DXRDynamicsXrayView.h"
#import "DXRDynamicsXrayBehaviorDrawing.h"
#import "DXRDynamicsXrayBehaviorAttachment.h"
#import "DXRDynamicsXrayBehaviorBoundaryCollision.h"
#import "DXRDynamicsXrayBehaviorGravity.h"
#import "DXRDynamicsXrayItemSnapshot.h"
#import "DXRDynamicsXrayItemSnapshot+DXRDrawing.h"

#import "DXRContactLifetime.h"
#import "DXRContactVisualise.h"


@interface DXRDynamicsXrayView ()

@property (strong, nonatomic) NSMutableArray *behaviorsToDraw;
@property (strong, nonatomic) NSMutableArray *contactPathsToDraw;
@property (strong, nonatomic) NSMutableArray *dynamicItemsToDraw;

@property (assign, nonatomic) CGSize lastBoundsSize;
@property (assign, nonatomic) CGPoint contactPathsOffset;

@end


@implementation DXRDynamicsXrayView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _allowsAntialiasing = YES;

        _behaviorsToDraw = [NSMutableArray array];
        _contactPathsToDraw = [NSMutableArray array];
        _dynamicItemsToDraw = [NSMutableArray array];

	self.backgroundColor = [UIColor clearColor];
	self.userInteractionEnabled = NO;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    if ([self sizeHasChanged]) {
        [self setNeedsDisplay];
    }
}

- (BOOL)sizeHasChanged
{
    CGSize size = self.bounds.size;
    if (CGSizeEqualToSize(size, self.lastBoundsSize)) {
        return NO;
    }
    else {
        self.lastBoundsSize = size;
        return YES;
    }
}

- (void)drawAttachmentFromAnchor:(CGPoint)anchorPoint toPoint:(CGPoint)attachmentPoint length:(CGFloat)length isSpring:(BOOL)isSpring
{
    DXRDynamicsXrayBehaviorAttachment *attachment = [[DXRDynamicsXrayBehaviorAttachment alloc] initWithAnchorPoint:anchorPoint attachmentPoint:attachmentPoint length:length isSpring:isSpring];
    [self itemNeedsDrawing:attachment];
}

- (void)drawBoundsCollisionBoundaryWithRect:(CGRect)boundaryRect
{
    DXRDynamicsXrayBehaviorBoundaryCollision *collision = [[DXRDynamicsXrayBehaviorBoundaryCollision alloc] initWithBoundaryRect:boundaryRect];
    [self itemNeedsDrawing:collision];
}

- (void)drawGravityBehaviorWithMagnitude:(CGFloat)magnitude angle:(CGFloat)angle
{
    DXRDynamicsXrayBehaviorGravity *gravity = [[DXRDynamicsXrayBehaviorGravity alloc] initWithGravityMagnitude:magnitude angle:angle];
    [self itemNeedsDrawing:gravity];
}

- (void)itemNeedsDrawing:(DXRDynamicsXrayBehavior *)item
{
    [self.behaviorsToDraw addObject:item];

    [self setNeedsDisplay];
}

- (void)drawDynamicItems:(NSSet *)dynamicItems contactedItems:(NSMapTable *)contactedItems withReferenceView:(UIView *)referenceView
{
    if (dynamicItems && [dynamicItems count] > 0) {
        for (id<UIDynamicItem> item in dynamicItems) {
            CGRect itemBounds = item.bounds;
            CGPoint itemCenter = [self convertPoint:item.center fromReferenceView:referenceView];
            CGAffineTransform itemTransform = item.transform;

            BOOL isContacted = ([[contactedItems objectForKey:item] integerValue] > 0);

            DXRDynamicsXrayItemSnapshot *itemSnapshot = [DXRDynamicsXrayItemSnapshot snapshotWithBounds:itemBounds center:itemCenter transform:itemTransform contacted:isContacted];
            [self.dynamicItemsToDraw addObject:itemSnapshot];
        }

        [self setNeedsDisplay];
    }
}

- (void)drawContactPaths:(NSMapTable *)contactedPaths withReferenceView:(UIView *)referenceView
{
    [self.contactPathsToDraw removeAllObjects];

    NSMutableArray *pathsToDraw = [NSMutableArray array];

    for (id key in contactedPaths) {
        // Keys are CGPathRefs
        DXRContactLifetime *contactLifetime = [contactedPaths objectForKey:key];
        float alpha = [contactLifetime decay];

        DXRContactVisualise *contactVisualise = [[DXRContactVisualise alloc] initWithObjToDraw:key alpha:alpha];
        [pathsToDraw addObject:contactVisualise];
    }

    [self.contactPathsToDraw addObjectsFromArray:pathsToDraw];

    self.contactPathsOffset = [self convertPoint:CGPointZero fromReferenceView:referenceView];
}


#pragma mark - Coordinate Conversion

- (CGPoint)convertPoint:(CGPoint)point fromReferenceView:(UIView *)referenceView
{
    UIWindow *appWindow = [UIApplication sharedApplication].keyWindow;
    CGPoint result;

    if (referenceView) {
        result = [referenceView convertPoint:point toView:nil];         // convert reference view to its window coords
    }
    else {
        result = [self pointTransformedFromDeviceOrientation:point];    // convert to app window coords
    }

    result = [self.window convertPoint:result fromWindow:appWindow];    // convert to DynamicsXray window coords
    result = [self convertPoint:result fromView:nil];                   // convert to DynamicsXray view coords

    result.x += self.drawOffset.horizontal;
    result.y += self.drawOffset.vertical;

    return result;
}

- (CGPoint)pointTransformedFromDeviceOrientation:(CGPoint)point
{
    CGPoint result;
    CGSize windowSize = [UIApplication sharedApplication].keyWindow.bounds.size;
    UIInterfaceOrientation statusBarOrientation = [UIApplication sharedApplication].statusBarOrientation;

    if (statusBarOrientation == UIInterfaceOrientationLandscapeRight) {
        result.x = windowSize.width - point.y;
        result.y = point.x;
    }
    else if (statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        result.x = windowSize.width - point.x;
        result.y = windowSize.height - point.y;
    }
    else if (statusBarOrientation == UIInterfaceOrientationLandscapeLeft) {
        result.x = point.y;
        result.y = windowSize.height - point.x;
    }
    else {
        result = point;
    }

    return result;
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
        NSLog(@"    Draw FPS: %@", fpsDescription);
        fps_prev_time = curr_time;
        fps_count = 1;
    }
    else {
        fps_count++;
    }
}


#pragma mark - Drawing

- (void)drawRect:(CGRect)rect
{
    //[self calcFPS];

    CGContextRef context = UIGraphicsGetCurrentContext();

    CGRect bounds = self.bounds;
    CGContextClipToRect(context, bounds);
    CGContextSetAllowsAntialiasing(context, (bool)self.allowsAntialiasing);

    [[UIColor blueColor] set];

    for (DXRDynamicsXrayItemSnapshot *itemSnapshot in self.dynamicItemsToDraw) {
        CGContextSaveGState(context);
        [itemSnapshot drawInContext:context];
        CGContextRestoreGState(context);
    }

    for (DXRDynamicsXrayBehavior *behavior in self.behaviorsToDraw) {
        if ([behavior conformsToProtocol:@protocol(DXRDynamicsXrayBehaviorDrawing)]) {
            CGContextSaveGState(context);
            [(id<DXRDynamicsXrayBehaviorDrawing>)behavior drawInContext:context];
            CGContextRestoreGState(context);
        }
        else {
            DLog(@"WARNING: DXRDynamicsXrayBehavior is not drawable: %@", behavior);
        }
    }

    if ([self.contactPathsToDraw count] > 0) {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, self.contactPathsOffset.x, self.contactPathsOffset.y);
        CGContextSetLineWidth(context, 5.0f);

        for (DXRContactVisualise *contactVisualise in self.contactPathsToDraw) {
            CGPathRef path = (__bridge CGPathRef)(contactVisualise.objToDraw);
            CGFloat alpha = contactVisualise.alpha;

            CGContextSetStrokeColorWithColor(context, [[UIColor redColor] colorWithAlphaComponent:alpha].CGColor);

            CGContextAddPath(context, path);
            CGContextStrokePath(context);
        }
        CGContextRestoreGState(context);
    }
    
    [self.behaviorsToDraw removeAllObjects];
    [self.contactPathsToDraw removeAllObjects];
    [self.dynamicItemsToDraw removeAllObjects];
}

@end
