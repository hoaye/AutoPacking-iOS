//
//  YJBannerViewCell.m
//  YJBannerViewDemo
//
//  Created by YJHou on 2015/5/24.
//  Copyright © 2015年 Address:https://github.com/stackhou . All rights reserved.
//

#import "YJBannerViewCell.h"
#import "UIView+YJBannerViewExt.h"

@interface YJBannerViewCell ()

@property (nonatomic, strong) UIImageView *showImageView; /**< 显示图片 */
@property (nonatomic, strong) UILabel *titleLabel; /**< 标题头 */
@property (nonatomic, strong) UIView *titleLabelBgView; /**< 标题背景 */

@end

@implementation YJBannerViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self _setUpMainView];
    }
    return self;
}

- (void)_setUpMainView{
    [self.contentView addSubview:self.showImageView];
    [self.contentView addSubview:self.titleLabelBgView];
    [self.contentView addSubview:self.titleLabel];
}

#pragma mark - Setter && Getter
- (void)setTitleLabelBackgroundColor:(UIColor *)titleLabelBackgroundColor{
    _titleLabelBackgroundColor = titleLabelBackgroundColor;
    self.titleLabelBgView.backgroundColor = titleLabelBackgroundColor;
}

- (void)setTitleLabelTextColor:(UIColor *)titleLabelTextColor{
    _titleLabelTextColor = titleLabelTextColor;
    self.titleLabel.textColor = titleLabelTextColor;
}

- (void)setTitleLabelTextFont:(UIFont *)titleLabelTextFont{
    _titleLabelTextFont = titleLabelTextFont;
    self.titleLabel.font = titleLabelTextFont;
}

-(void)setTitleLabelTextAlignment:(NSTextAlignment)titleLabelTextAlignment{
    _titleLabelTextAlignment = titleLabelTextAlignment;
    self.titleLabel.textAlignment = titleLabelTextAlignment;
}

- (void)setShowImageViewContentMode:(UIViewContentMode)showImageViewContentMode{
    _showImageViewContentMode = showImageViewContentMode;
    self.showImageView.contentMode = showImageViewContentMode;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat titleBgViewlH = self.titleLabelHeight;
    self.showImageView.frame = self.bounds;
    titleBgViewlH = self.titleLabelHeight;
    
    CGFloat titlBgViewX   = 0.0f;
    CGFloat titleBgViewY = self.height_bannerView - titleBgViewlH;
    CGFloat titleBgViewW = self.width_bannerView - 2 * titlBgViewX;
    _titleLabelBgView.frame = CGRectMake(titlBgViewX, titleBgViewY, titleBgViewW, titleBgViewlH);
    
    CGFloat titleLabelH = titleBgViewlH;
    CGFloat titleLabelX = self.titleLabelEdgeMargin;
    CGFloat titleLabelY = titleBgViewY;
    CGFloat titleLabelW = self.width_bannerView - 2 * titleLabelX;
    _titleLabel.frame = CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH);
}

#pragma mark - 刷新数据
- (void)cellWithSelectorString:(NSString *)selectorString imagePath:(NSString *)imagePath placeholderImage:(UIImage *)placeholderImage title:(NSString *)title{

    if (imagePath) {
        self.showImageView.hidden = NO;
        if ([imagePath isKindOfClass:[NSString class]]) {
            if ([imagePath hasPrefix:@"http"]) {
                
                // 检验方法是否可用
                SEL selector = NSSelectorFromString(selectorString);
                if ([self.showImageView respondsToSelector:selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                    [self.showImageView performSelector:selector withObject:[NSURL URLWithString:imagePath] withObject:placeholderImage];
#pragma clang diagnostic pop
                }
            } else {
                if (imagePath.length > 0) {
                    UIImage *image = [UIImage imageNamed:imagePath];
                    if (!image) {
                        image = [UIImage imageWithContentsOfFile:imagePath];
                    }
                    self.showImageView.image = image;
                }
            }
        } else if ([imagePath isKindOfClass:[UIImage class]]) {
            self.showImageView.image = (UIImage *)imagePath;
        }else{
            self.showImageView.image = placeholderImage;
        }
    }else{
        self.showImageView.hidden = YES;
    }
    
    if (title.length > 0) {
        self.titleLabel.text = title;
        self.titleLabel.hidden = NO;
        self.titleLabelBgView.hidden = NO;
    }else{
        self.titleLabel.hidden = YES;
        self.titleLabelBgView.hidden = YES;
    }
}

#pragma mark - Lazy
- (UIImageView *)showImageView{
    if (!_showImageView) {
        _showImageView = [[UIImageView alloc] init];
    }
    return _showImageView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.hidden = YES;
        _titleLabel.backgroundColor = [UIColor clearColor];
    }
    return _titleLabel;
}

- (UIView *)titleLabelBgView{
    if (!_titleLabelBgView) {
        _titleLabelBgView = [[UIView alloc] init];
        _titleLabelBgView.hidden = YES;
    }
    return _titleLabelBgView;
}


@end
