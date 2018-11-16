//
//  YJAnimatedDotView.m
//  YJBannerViewDemo
//
//  Created by YJHou on 2015/5/24.
//  Copyright © 2015年 Address:https://github.com/stackhou . All rights reserved.
//

#import "YJAnimatedDotView.h"

static CGFloat const kAnimateDuration = 0;

@implementation YJAnimatedDotView

- (instancetype)init{
    self = [super init];
    if (self) {
        [self initialization];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialization];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialization];
    }
    return self;
}

- (void)setDotColor:(UIColor *)dotColor{
    _dotColor = dotColor;
    self.layer.borderColor = dotColor.CGColor;
}

- (void)setCurrentDotColor:(UIColor *)currentDotColor{
    _currentDotColor = currentDotColor;
    self.backgroundColor = [UIColor clearColor];
}

- (void)initialization{
    _dotColor = [UIColor whiteColor];
    _currentDotColor = [UIColor whiteColor];
    self.backgroundColor    = [UIColor clearColor];
    self.layer.cornerRadius = CGRectGetWidth(self.frame) * 0.5;
    self.layer.borderColor  = [UIColor whiteColor].CGColor;
    self.layer.borderWidth  = 1.5;
    self.resizeScale = 1.4f;
}

- (void)changeActivityState:(BOOL)active{
    if (active) {
        [self animateToActiveState];
    } else {
        [self animateToDeactiveState];
    }
}

- (void)animateToActiveState{
    [UIView animateWithDuration:kAnimateDuration delay:0 usingSpringWithDamping:.5 initialSpringVelocity:-20 options:UIViewAnimationOptionCurveLinear animations:^{
        self.backgroundColor = self.currentDotColor;
        self.layer.borderColor = [UIColor clearColor].CGColor;
        self.transform = CGAffineTransformMakeScale(self.resizeScale, self.resizeScale);
    } completion:nil];
}

- (void)animateToDeactiveState{
    [UIView animateWithDuration:kAnimateDuration delay:0 usingSpringWithDamping:.5 initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.backgroundColor = [UIColor clearColor];
        self.layer.borderColor = self.dotColor.CGColor;
        self.transform = CGAffineTransformIdentity;
    } completion:nil];
}

@end
