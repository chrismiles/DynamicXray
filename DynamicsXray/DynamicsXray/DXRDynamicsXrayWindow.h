//
//  DXRDynamicsXrayWindow.h
//  DynamicsXray
//
//  Created by Chris Miles on 12/11/2013.
//  Copyright (c) 2013 Chris Miles. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DXRDynamicsXrayWindowDelegate;


@interface DXRDynamicsXrayWindow : UIWindow

@property (weak, nonatomic) id<DXRDynamicsXrayWindowDelegate> xrayWindowDelegate;

@end


@protocol DXRDynamicsXrayWindowDelegate <NSObject>

- (void)dynamicsXRayWindowNeedsToLayoutSubviews:(DXRDynamicsXrayWindow *)dynamicsXRayWindow;

@end
