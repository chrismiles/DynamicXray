//
//  DXRDynamicXrayWindow.h
//  DynamicsXray
//
//  Created by Chris Miles on 12/11/2013.
//  Copyright (c) 2013 Chris Miles. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DXRDynamicXrayWindowDelegate;


@interface DXRDynamicXrayWindow : UIWindow

@property (weak, nonatomic) id<DXRDynamicXrayWindowDelegate> xrayWindowDelegate;

@end


@protocol DXRDynamicXrayWindowDelegate <NSObject>

- (void)dynamicsXrayWindowNeedsToLayoutSubviews:(DXRDynamicXrayWindow *)dynamicsXrayWindow;

@end
