//
//  DXRDynamicsXrayBehaviorAttachment.h
//  DynamicsXray
//
//  Created by Chris Miles on 4/08/13.
//  Copyright (c) 2013 Chris Miles. All rights reserved.
//

#import "DXRDynamicsXrayBehavior.h"
@import UIKit;

@interface DXRDynamicsXrayBehaviorAttachment : DXRDynamicsXrayBehavior

- (id)initWithAnchorPoint:(CGPoint)anchorPoint attachmentPoint:(CGPoint)attachmentPoint length:(CGFloat)length isSpring:(BOOL)isSpring;

@property (assign, nonatomic) CGPoint anchorPoint;
@property (assign, nonatomic) CGPoint attachmentPoint;
@property (assign, nonatomic) BOOL isSpring;
@property (assign, nonatomic) CGFloat length;

@end
