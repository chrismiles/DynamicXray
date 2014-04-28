//
//  CMLabelledSwitch.h
//  CMLabelledSwitch
//
//  Created by Chris Miles on 3/10/13.
//  Copyright (c) 2013 Chris Miles. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMLabelledSwitch : UIView

@property (strong, nonatomic, readonly) UILabel *label;
@property (strong, nonatomic, readonly) UISwitch *embeddedSwitch;

@property (strong, nonatomic) NSString *text;

@end
