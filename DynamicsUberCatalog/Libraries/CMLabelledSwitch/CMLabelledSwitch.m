//
//  CMLabelledSwitch.m
//  CMLabelledSwitch
//
//  Created by Chris Miles on 3/10/13.
//  Copyright (c) 2013 Chris Miles. All rights reserved.
//

#import "CMLabelledSwitch.h"

@interface CMLabelledSwitch ()

@property (strong, nonatomic, readwrite) UILabel *label;
@property (strong, nonatomic, readwrite) UISwitch *embeddedSwitch;

@end


@implementation CMLabelledSwitch

@dynamic text;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
	_label = [[UILabel alloc] initWithFrame:CGRectZero];
	_label.backgroundColor = [UIColor clearColor];
	
	_embeddedSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
	
	[self addSubview:_label];
	[self addSubview:_embeddedSwitch];
    }
    return self;
}

- (void)layoutSubviews
{
    [self.embeddedSwitch sizeToFit];
    [self.label sizeToFit];
    
    CGFloat width = fmaxf(CGRectGetWidth(self.label.frame), CGRectGetWidth(self.embeddedSwitch.frame));
    
    CGRect labelFrame = self.label.frame;
    labelFrame.origin.x = (width - CGRectGetWidth(labelFrame)) / 2.0f;
    labelFrame.origin.y = 0;
    self.label.frame = CGRectIntegral(labelFrame);
    
    CGRect switchFrame = self.embeddedSwitch.frame;
    switchFrame.origin.x = (width - CGRectGetWidth(switchFrame)) / 2.0f;
    switchFrame.origin.y = CGRectGetHeight(labelFrame);
    self.embeddedSwitch.frame = CGRectIntegral(switchFrame);
}

- (CGSize)sizeThatFits:(__unused CGSize)size
{
    [self layoutSubviews];
    
    CGSize result;
    result.width = fmaxf(CGRectGetWidth(self.label.frame), CGRectGetWidth(self.embeddedSwitch.frame));
    result.height = CGRectGetMaxY(self.embeddedSwitch.frame);
    return result;
}

- (void)sizeToFit
{
    CGRect frame = self.frame;
    frame.size = [self sizeThatFits:CGSizeZero];
    self.frame = frame;
}


#pragma mark - Text Property

- (NSString *)text
{
    return self.label.text;
}

- (void)setText:(NSString *)text
{
    self.label.text = text;
    [self setNeedsLayout];
}

@end
