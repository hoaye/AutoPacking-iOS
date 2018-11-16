//
//  YJBannerViewFooter.m
//  YJBannerViewDemo
//
//  Created by YJHou on 2015/5/24.
//  Copyright © 2015年 Address:https://github.com/stackhou . All rights reserved.
//

#import "YJBannerViewFooter.h"

#define YJ_ARROW_SIZE 15.0f

@interface YJBannerViewFooter ()

@property (nonatomic, strong) UIImageView *arrowView;
@property (nonatomic, strong) UILabel *label;

@end

@implementation YJBannerViewFooter

@synthesize idleTitle = _idleTitle;
@synthesize triggerTitle = _triggerTitle;


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.arrowView];
        [self addSubview:self.label];
        
        self.state = YJBannerViewStatusIdle;
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat arrowX = self.bounds.size.width * 0.5 - YJ_ARROW_SIZE - 2.5;
    CGFloat arrowY = (self.bounds.size.height - YJ_ARROW_SIZE) * 0.5;
    CGFloat arrowW = YJ_ARROW_SIZE;
    CGFloat arrowH = YJ_ARROW_SIZE;
    self.arrowView.frame = CGRectMake(arrowX, arrowY, arrowW, arrowH);
    
    CGFloat labelX = self.bounds.size.width * 0.5 + 2.5;
    CGFloat labelY = 0;
    CGFloat labelW = YJ_ARROW_SIZE;
    CGFloat labelH = self.bounds.size.height;
    self.label.frame = CGRectMake(labelX, labelY, labelW, labelH);
}

#pragma mark - setters & getters
- (void)setState:(YJBannerViewStatus)state{
    _state = state;
    
    switch (state) {
        case YJBannerViewStatusIdle:{
            self.label.text = self.idleTitle;
            [UIView animateWithDuration:0.25 animations:^{
                self.arrowView.transform = CGAffineTransformMakeRotation(0);
            }];
        }
            break;
        case YJBannerViewStatusTrigger:{
            self.label.text = self.triggerTitle;
            [UIView animateWithDuration:0.25 animations:^{
                self.arrowView.transform = CGAffineTransformMakeRotation(M_PI);
            }];
        }
            break;
        default:
            break;
    }
}

#pragma mark - Setter
- (void)setFooterTitleFont:(UIFont *)footerTitleFont{
    _footerTitleFont = footerTitleFont;
    self.label.font = _footerTitleFont;
}

- (void)setFooterTitleColor:(UIColor *)footerTitleColor{
    _footerTitleColor = footerTitleColor;
    self.label.textColor = _footerTitleColor;
}

- (void)setIndicateImageName:(NSString *)IndicateImageName{
    _IndicateImageName = IndicateImageName;
    if (_IndicateImageName.length > 0 && self.arrowView.image == nil) {
        self.arrowView.image = [UIImage imageNamed:_IndicateImageName];
    }
}

#pragma mark - Lazy
- (UIImageView *)arrowView{
    if (!_arrowView) {
        _arrowView = [[UIImageView alloc] init];
    }
    return _arrowView;
}

- (UILabel *)label{
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.numberOfLines = 0;
    }
    return _label;
}

- (void)setIdleTitle:(NSString *)idleTitle{
    _idleTitle = idleTitle;
    if (self.state == YJBannerViewStatusIdle) {
        self.label.text = idleTitle;
    }
}

- (void)setTriggerTitle:(NSString *)triggerTitle{
    _triggerTitle = triggerTitle;
    if (self.state == YJBannerViewStatusTrigger) {
        self.label.text = triggerTitle;
    }
}

@end
