//
//  DCSpringyRopeLayer.m
//  DynamicsCatalog
//
//  Created by Chris Miles on 30/09/13.
//  Copyright (c) 2013 Chris Miles. All rights reserved.
//
//  Based on CMTraerPhysics demo by Chris Miles, https://github.com/chrismiles/CMTraerPhysics
//  Based on traerAS3 example by Arnaud Icard, https://github.com/sqrtof5/traerAS3
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

#import "DCSpringyRopeLayer.h"
#import "DCSpringyRopeParticle.h"
#import "DCSpringyRopeSmoothedPath.h"
@import CoreMotion;

#import <DynamicsXRay/DynamicsXRay.h>


/*
    Physics Configuration
 */
static CGFloat const DCSpringyRopeDamping = 1.0f;
static CGFloat const DCSpringyRopeFrequency = 5.0f;
static CGFloat const DCSpringyRopeParticleDensity = 0.5f;
static CGFloat const DCSpringyRopeParticleResistance = 0.5f;

/*
    Visual Configuration
 */
static CGFloat const DCSpringyRopeLayerHandleRadius = 5.0f;


/*
    Utility Functions
 */
static CGFloat CGPointDistance(CGPoint userPosition, CGPoint prevPosition)
{
    CGFloat dx = prevPosition.x - userPosition.x;
    CGFloat dy = prevPosition.y - userPosition.y;
    return sqrtf(dx*dx + dy*dy);
}


/*
    DCSpringyRopeLayer
 */
@interface DCSpringyRopeLayer ()

@property (assign, nonatomic) float spring_length;
@property (assign, nonatomic) NSUInteger subdivisions;

@property (assign, nonatomic) CGPoint handle;
@property (assign, nonatomic) BOOL isDragging;
@property (assign, nonatomic) CGSize lastSize;

@property (assign, nonatomic) float gravityScale;
@property (strong, nonatomic) CMMotionManager *motionManager;

// Physics
@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong, nonatomic) UIGravityBehavior *gravityBehavior;
@property (strong, nonatomic) NSArray *particles;
@property (strong, nonatomic) UIAttachmentBehavior *anchorSpringBehavior;

// FPS
@property (assign, nonatomic) double fps_prev_time;
@property (assign, nonatomic) NSUInteger fps_count;

@end


@implementation DCSpringyRopeLayer

- (id)init
{
    self = [super init];
    if (self) {
	self.contentsScale = [UIScreen mainScreen].scale;
	
	_lastSize = self.bounds.size;
	_handle = CGPointZero;
	
	_spring_length = 25.0;
	_subdivisions = 8;
	
	_motionManager = [[CMMotionManager alloc] init];
        _motionManager.deviceMotionUpdateInterval = 0.02; // 50 Hz
	
	_animator = [[UIDynamicAnimator alloc] init];
	_gravityBehavior = [[UIGravityBehavior alloc] initWithItems:nil];
	_gravityBehavior.gravityDirection = CGVectorMake(0, 1.0f);
	
	__weak DCSpringyRopeLayer *weakSelf = self;
	_gravityBehavior.action = ^{
	    __strong DCSpringyRopeLayer *strongSelf = weakSelf;
	    [strongSelf drawFrame];
	};
	[_animator addBehavior:_gravityBehavior];
	
	/*
	    Dynamics Xray
	 */
	DynamicsXRay *xray = [[DynamicsXRay alloc] init];
	[_animator addBehavior:xray];
    }
    return self;
}

- (void)layoutSublayers
{
    [super layoutSublayers];
    
    if (self.particles == nil) [self generateParticles];
}

#pragma mark - Animation Start/Stop

- (void)startAnimation
{

}

- (void)stopAnimation
{

}

- (void)drawFrame
{
    if (self.motionManager.isDeviceMotionActive) {
        CMAcceleration gravity = self.motionManager.deviceMotion.gravity;
	CGVector gravityVector = CGVectorMake((float)(gravity.x) * self.gravityScale, (float)(-gravity.y) * self.gravityScale);
	self.gravityBehavior.gravityDirection = gravityVector;
    }
    
    [self setNeedsDisplay];      // draw layer
    
    /* FPS */
    if (self.fpsLabel) {
	double curr_time = CACurrentMediaTime();
	if (curr_time - self.fps_prev_time >= 0.2) {
	    double delta = (curr_time - self.fps_prev_time) / self.fps_count;
	    self.fpsLabel.text = [NSString stringWithFormat:@"%0.0f fps", 1.0/delta];
	    self.fps_prev_time = curr_time;
	    self.fps_count = 1;
	}
	else {
	    self.fps_count++;
	}
    }
}

- (void)generateParticles
{
    NSMutableArray *particles = [NSMutableArray array];
    
    CGPoint anchorPoint = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetHeight(self.bounds)*0.2f);
    
    UIDynamicItemBehavior *particleBehavior = [[UIDynamicItemBehavior alloc] initWithItems:nil];
    particleBehavior.density = DCSpringyRopeParticleDensity;
    particleBehavior.resistance = DCSpringyRopeParticleResistance;
    
    NSUInteger subdivisions = self.subdivisions;
    
    float sub_len = self.spring_length / subdivisions;
    for (NSUInteger i=1; i<=subdivisions; i++) {
	DCSpringyRopeParticle *p = [[DCSpringyRopeParticle alloc] initWithCenterPosition:CGPointMake(anchorPoint.x, anchorPoint.y + i*sub_len)];
	[particles addObject:p];
	[particleBehavior addItem:p];
	[self.gravityBehavior addItem:p];
    }
    
    for (NSUInteger i=0; i<[particles count]-1; i++)  {
//	[s makeSpringBetweenParticleA:[particles objectAtIndex:i] particleB:[particles objectAtIndex:i+1] springConstant:0.5f damping:0.2f restLength:sub_len];
	if (i == 0) {
	    UIAttachmentBehavior *anchorSpringBehavior = [[UIAttachmentBehavior alloc] initWithItem:particles[i] attachedToAnchor:anchorPoint];
	    anchorSpringBehavior.length = sub_len;
	    anchorSpringBehavior.frequency = DCSpringyRopeFrequency;
	    anchorSpringBehavior.damping = DCSpringyRopeDamping;
	    [self.animator addBehavior:anchorSpringBehavior];
	    self.anchorSpringBehavior = anchorSpringBehavior;
	}
	
	UIAttachmentBehavior *springBehavior = [[UIAttachmentBehavior alloc] initWithItem:particles[i] attachedToItem:particles[i+1]];
	springBehavior.length = sub_len;
	springBehavior.frequency = DCSpringyRopeFrequency;
	springBehavior.damping = DCSpringyRopeDamping;
	[self.animator addBehavior:springBehavior];
    }
    
    [self.animator addBehavior:particleBehavior];
    
    self.particles = particles;
}


#pragma mark - Custom property accessors

- (BOOL)isDeviceMotionAvailable
{
    return self.motionManager.isDeviceMotionAvailable;
}

- (void)setGravityByDeviceMotionEnabled:(BOOL)gravityByDeviceMotionEnabled
{
    if (gravityByDeviceMotionEnabled) {
        if ([self.motionManager isDeviceMotionAvailable]) {
            [self.motionManager startDeviceMotionUpdates];
        }
    }
    else {
        if ([self.motionManager isDeviceMotionActive]) {
            [self.motionManager stopDeviceMotionUpdates];
        }
    }
}

- (BOOL)gravityByDeviceMotionEnabled
{
    return [self.motionManager isDeviceMotionActive];
}


#pragma mark - Handle touches

- (void)touchBeganAtLocation:(CGPoint)location
{
    if (CGPointDistance(location, self.handle) <= 40.0f) {
	self.isDragging = YES;
	self.handle = location;
    }
}

- (void)touchMovedAtLocation:(CGPoint)location
{
    if (self.isDragging) {
	self.handle = location;
    }
}

- (void)touchEndedAtLocation:(CGPoint)location
{
    if (self.isDragging) {
	self.handle = location;
	self.isDragging = NO;
    }
}

- (void)touchCancelledAtLocation:(__unused CGPoint)location
{
    if (self.isDragging) {
	self.isDragging = NO;
    }
}


#pragma mark - CALayer methods

- (void)drawInContext:(CGContextRef)ctx
{
    if (!CGSizeEqualToSize(self.bounds.size, self.lastSize)) {
	self.gravityScale = 1.0f * CGRectGetHeight(self.frame) / 320.0f;
        self.lastSize = self.bounds.size;
    }

    DCSpringyRopeParticle *p = self.particles[self.subdivisions-1];
    if (!self.isDragging) {
	
	self.handle = CGPointMake(p.center.x, p.center.y);
    } else {
	
//	p.position = CMTPVector3DMake(self.handle.x, self.handle.y, 0.0f);
	p.center = CGPointMake(self.handle.x, self.handle.y);
	[self.animator updateItemUsingCurrentState:p];
    }
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPoint anchorPoint = self.anchorSpringBehavior.anchorPoint;
//    p = [particles objectAtIndex:0];
    CGPathMoveToPoint(path, NULL, anchorPoint.x, anchorPoint.y);
    for (NSUInteger i=0; i<[self.particles count]; i++) {
	p = [self.particles objectAtIndex:i];
	CGPathAddLineToPoint(path, NULL, p.center.x, p.center.y);
    }
    
    UIGraphicsPushContext(ctx);
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithCGPath:path];
    if (self.smoothed) {
	bezierPath = smoothedPath(bezierPath, 8);
    }
//    [bezierPath stroke];
    UIGraphicsPopContext();
    
    CGPathRelease(path);
    
    // Draw handle
    CGContextAddEllipseInRect(ctx, CGRectMake(self.handle.x-DCSpringyRopeLayerHandleRadius, self.handle.y-DCSpringyRopeLayerHandleRadius, DCSpringyRopeLayerHandleRadius*2, DCSpringyRopeLayerHandleRadius*2));
    CGContextStrokePath(ctx);
}

@end
