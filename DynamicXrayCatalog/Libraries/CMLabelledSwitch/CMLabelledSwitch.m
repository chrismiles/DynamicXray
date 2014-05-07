//
//  CMLabelledSwitch.m
//  CMLabelledSwitch
//
//  Created by Chris Miles on 3/10/13.
//  Copyright (c) 2013 Chris Miles. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
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
