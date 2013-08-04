//
//  DXRDynamicsXRayView.m
//  DynamicsXRay
//
//  Created by Chris Miles on 4/08/13.
//  Copyright (c) 2013 Chris Miles. All rights reserved.
//

#import "DXRDynamicsXRayView.h"

@interface DXRDynamicsXRayView ()

@property (strong, nonatomic) NSMutableArray *elementsToDraw;

@end


@implementation DXRDynamicsXRayView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
	_elementsToDraw = [NSMutableArray array];
    }
    return self;
}

- (void)drawAttachmentFromAnchor:(CGPoint)anchorPoint toPoint:(CGPoint)attachmentPoint isSpring:(BOOL)isSpring
{
    // TODO: custom class would be better here
    NSDictionary *element = @{@"type": @"attachment", @"anchorPoint": [NSValue valueWithCGPoint:anchorPoint], @"attachmentPoint": [NSValue valueWithCGPoint:attachmentPoint]};
    
    [self.elementsToDraw addObject:element];
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef c = UIGraphicsGetCurrentContext();
    
    [[UIColor redColor] set];
    
    for (NSDictionary *element in self.elementsToDraw) {
	// TODO: handles ONLY attachments
	
	CGPoint anchorPoint = [element[@"anchorPoint"] CGPointValue];
	CGPoint attachmentPoint = [element[@"attachmentPoint"] CGPointValue];
	
	CGContextMoveToPoint(c, anchorPoint.x, anchorPoint.y);
	CGContextAddLineToPoint(c, attachmentPoint.x, attachmentPoint.y);
	CGContextStrokePath(c);
    }
    
    [self.elementsToDraw removeAllObjects];
}

@end
