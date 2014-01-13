//
//  DXRContactVisualise.m
//  DynamicsXray
//
//  Created by Chris Miles on 13/01/2014.
//  Copyright (c) 2014 Chris Miles. All rights reserved.
//

#import "DXRContactVisualise.h"

@implementation DXRContactVisualise

- (id)initWithObjToDraw:(id)objToDraw alpha:(float)alpha
{
    self = [super init];
    if (self) {
        _objToDraw = objToDraw;
        _alpha = alpha;
    }
    return self;
}

@end
