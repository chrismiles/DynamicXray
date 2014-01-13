//
//  DXRContactVisualise.h
//  DynamicsXray
//
//  Created by Chris Miles on 13/01/2014.
//  Copyright (c) 2014 Chris Miles. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DXRContactVisualise : NSObject

- (id)initWithObjToDraw:(id)objToDraw alpha:(float)alpha;

@property (strong, nonatomic) id objToDraw;
@property (assign, nonatomic) float alpha;

@end
