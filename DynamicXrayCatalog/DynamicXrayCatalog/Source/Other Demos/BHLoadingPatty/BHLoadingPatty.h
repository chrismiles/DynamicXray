//
//  BHLoadingPattie.h
//  Burgerhead
//
//  Created by Peter Hare on 3/03/2014.
//  Copyright (c) 2014 Burgerhead. All rights reserved.
//

@class DynamicXray;

@interface BHLoadingPatty : UIView

@property (nonatomic) DynamicXray *dynamicXray;

+ (instancetype)instanceShownInView:(UIView *)view;

- (void)hide;

@end
