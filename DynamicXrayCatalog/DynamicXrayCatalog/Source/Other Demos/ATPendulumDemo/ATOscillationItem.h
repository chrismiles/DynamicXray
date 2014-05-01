//
//  ATOscillationItem.h
//  Animation Tests
//
//  Created by Peter Hare on 3/07/2013.
//  Copyright (c) 2013 Peter Hare. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ATOscillationItem : NSObject <UIDynamicItem>

@property (nonatomic, readonly) CGRect bounds;
@property (nonatomic, readwrite) CGPoint center;
@property (nonatomic, readwrite) CGAffineTransform transform;

@end
