//
//  UIView+YJBannerViewExt.m
//  YJBannerViewDemo
//
//  Created by YJHou on 2015/5/24.
//  Copyright © 2015年 Address:https://github.com/stackhou . All rights reserved.
//

#import "UIView+YJBannerViewExt.h"

@implementation UIView (YJBannerViewExt)

- (void)setX_bannerView:(CGFloat)x_bannerView{
    CGRect temp = self.frame;
    temp.origin.x = x_bannerView;
    self.frame = temp;
}

- (CGFloat)x_bannerView{
    return self.frame.origin.x;
}

- (void)setY_bannerView:(CGFloat)y_bannerView{
    CGRect temp = self.frame;
    temp.origin.y = y_bannerView;
    self.frame = temp;
}

- (CGFloat)y_bannerView{
    return self.frame.origin.y;
}

- (void)setWidth_bannerView:(CGFloat)width_bannerView{
    CGRect temp = self.frame;
    temp.size.width = width_bannerView;
    self.frame = temp;
}

- (CGFloat)width_bannerView{
    return self.frame.size.width;
}

- (void)setHeight_bannerView:(CGFloat)height_bannerView{
    CGRect temp = self.frame;
    temp.size.height = height_bannerView;
    self.frame = temp;
}

- (CGFloat)height_bannerView{
    return self.frame.size.height;
}

@end
