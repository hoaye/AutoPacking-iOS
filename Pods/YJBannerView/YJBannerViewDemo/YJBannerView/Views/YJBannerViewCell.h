//
//  YJBannerViewCell.h
//  YJBannerViewDemo
//
//  Created by YJHou on 2015/5/24.
//  Copyright © 2015年 Address:https://github.com/stackhou . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YJBannerViewCell : UICollectionViewCell

@property (nonatomic, strong) UIColor *titleLabelTextColor;
@property (nonatomic, strong) UIFont *titleLabelTextFont;
@property (nonatomic, strong) UIColor *titleLabelBackgroundColor;
@property (nonatomic, assign) CGFloat titleLabelHeight;
@property (nonatomic, assign) CGFloat titleLabelEdgeMargin;
@property (nonatomic, assign) NSTextAlignment titleLabelTextAlignment;
@property (nonatomic, assign) UIViewContentMode showImageViewContentMode; /**< 填充样式 默认UIViewContentModeScaleToFill */
@property (nonatomic, assign) BOOL isConfigured;

- (void)cellWithSelectorString:(NSString *)selectorString imagePath:(NSString *)imagePath placeholderImage:(UIImage *)placeholderImage title:(NSString *)title;

@end
