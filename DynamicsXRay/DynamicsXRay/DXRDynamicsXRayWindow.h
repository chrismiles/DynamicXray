//
//  DXRDynamicsXRayWindow.h
//  DynamicsXRay
//
//  Created by Chris Miles on 12/11/2013.
//  Copyright (c) 2013 Chris Miles. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DXRDynamicsXRayWindowDelegate;


@interface DXRDynamicsXRayWindow : UIWindow

@property (weak, nonatomic) id<DXRDynamicsXRayWindowDelegate> xrayWindowDelegate;

@end


@protocol DXRDynamicsXRayWindowDelegate <NSObject>

- (void)dynamicsXRayWindowNeedsToLayoutSubviews:(DXRDynamicsXRayWindow *)dynamicsXRayWindow;

@end
