//
//  YJBannerView.h
//  YJBannerViewDemo
//
//  Created by YJHou on 2015/5/24.
//  Copyright © 2015年 Address:https://github.com/stackhou . All rights reserved.
//

/**
 __   __  _ ____                            __     ___
 \ \ / / | | __ )  __ _ _ __  _ __   ___ _ __ \   / (_) _____      __
  \ V /  | |  _ \ / _` | '_ \| '_ \ / _ \ '__\ \ / /| |/ _ \ \ /\ / /
   | | |_| | |_) | (_| | | | | | | |  __/ |   \ V / | |  __/\ V  V /
   |_|\___/|____/ \__,_|_| |_|_| |_|\___|_|    \_/  |_|\___| \_/\_/
 
*********  Current-Version : 2.4.0 ************
 
 Version record: https://github.com/stackhou/YJBannerViewOC
 
 */

#import <UIKit/UIKit.h>
#import "YJBannerViewCollectionView.h"

/** 指示器位置 */
typedef NS_ENUM(NSInteger, PageControlAliment) {
    PageControlAlimentLeft = 0,     // 居左
    PageControlAlimentCenter,       // 居中
    PageControlAlimentRight         // 居右
};

/** 指示器样式 */
typedef NS_ENUM(NSInteger, PageControlStyle) {
    PageControlNone = 0,            // 无
    PageControlSystem,              // 系统自带
    PageControlHollow,              // 空心的
    PageControlCustom               // 自定义 需要图片Dot
};

/** 滚动方向   */
typedef NS_ENUM(NSInteger, BannerViewDirection) {
    BannerViewDirectionLeft = 0,    // 水平向左
    BannerViewDirectionRight,       // 水平向右
    BannerViewDirectionTop,         // 竖直向上
    BannerViewDirectionBottom       // 竖直向下
};


@class YJBannerView;
@protocol YJBannerViewDataSource, YJBannerViewDelegate;

@interface YJBannerView : UIView

@property (nonatomic, strong) UIImageView *backgroundImageView;                     /**< 数据为空时的背景图 */
@property (nonatomic, strong, readonly) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong, readonly) YJBannerViewCollectionView *collectionView;

@property (nonatomic, weak) IBOutlet id<YJBannerViewDataSource> dataSource;         /**< 数据源代理 */
@property (nonatomic, weak) IBOutlet id<YJBannerViewDelegate> delegate;             /**< 代理 */

@property (nonatomic, assign) IBInspectable BOOL autoScroll;                        /**< 是否自动 默认YES */

@property (nonatomic, assign) IBInspectable CGFloat autoDuration;                   /**< 自动滚动时间间隔 默认3s */

@property (nonatomic, assign) IBInspectable BOOL cycleScrollEnable;                 /**< 是否首尾循环 默认是YES */

@property (nonatomic, assign) BannerViewDirection bannerViewScrollDirection;        /**< 滚动方向 默认水平向左 */

@property (nonatomic, assign) BOOL bannerGestureEnable;                             /**< 手势是否可用 默认可用YES */

@property (nonatomic, assign) IBInspectable BOOL showFooter;                        /**< 显示footerView 默认是 NO 设置为YES 后将 autoScroll和cycleScrollEnable 自动置为NO 只支持水平向左 */
@property (nonatomic, assign) NSInteger repeatCount;                                /**< 数据源重复次数 默认是200 若循环必须大于2的偶数 */

@property (nonatomic, strong) UIImage *placeholderImage;                            /**< 默认图片 */
@property (nonatomic, strong) UIImage *emptyImage;                                  /**< 空数据图片 */

@property (nonatomic, copy) NSString *bannerViewSelectorString;                     /**< 自定义设置网络和默认图片的方法 */

@property (nonatomic, assign) UIViewContentMode bannerImageViewContentMode;         /**< 填充样式 默认UIViewContentModeScaleAspectFill */

@property (nonatomic, assign) PageControlAliment pageControlAliment;                /**< 指示器的位置 默认是Center */

@property (nonatomic, assign) PageControlStyle pageControlStyle;                    /**< 指示器样式 默认System */

@property (nonatomic, assign) CGFloat pageControlBottomMargin;                      /**< 指示器距离底部的间距 默认10 */

@property (nonatomic, assign) CGFloat pageControlHorizontalEdgeMargin;              /**< 指示器水平方向上的边缘间距 默认10 */

@property (nonatomic, assign) CGFloat pageControlPadding;                           /**< 指示器水平方向上间距 默认 5 系统样式无效 */

@property (nonatomic, assign) CGSize pageControlDotSize;                            /**< 指示器圆标大小 默认 8*8*/

@property (nonatomic, strong) UIColor *pageControlNormalColor;                      /**< 指示器正常颜色 */

@property (nonatomic, strong) UIColor *pageControlHighlightColor;                   /**< 指示器小圆标颜色 */

@property (nonatomic, strong) UIImage *customPageControlNormalImage;                /**< 指示器小圆点正常的图片 */

@property (nonatomic, strong) UIImage *customPageControlHighlightImage;             /**< 当前分页控件图片 */

@property (nonatomic, strong) UIFont *titleFont;                                    /**< 文字大小 默认14.0f */

@property (nonatomic, strong) UIColor *titleTextColor;                              /**< 文字颜色 默认 whiteColor */

@property (nonatomic, assign) NSTextAlignment titleAlignment;                       /**< 文字对齐方式 默认 Left */

@property (nonatomic, strong) UIColor *titleBackgroundColor;                        /**< 文字背景颜色 默认 黑0.5 */

@property (nonatomic, assign) CGFloat titleHeight;                                  /**< 文字高度 默认30 */

@property (nonatomic, assign) CGFloat titleEdgeMargin;                              /**< 文字边缘间距 默认是10 */

@property (nonatomic, copy) NSString *footerIndicateImageName;                      /**< footer 指示图片名字 默认是自带的 */

@property (nonatomic, copy) NSString *footerNormalTitle;                            /**< footer 常态Title 默认 "拖动查看详情" */

@property (nonatomic, copy) NSString *footerTriggerTitle;                           /**< footer Trigger Title 默认 "释放查看详情" */

@property (nonatomic, strong) UIFont *footerTitleFont;                              /**< footer Font 默认 12 */

@property (nonatomic, strong) UIColor *footerTitleColor;                            /**< footer TitleColoe 默认是 darkGrayColor */

@property (nonatomic, copy) void(^didScroll2IndexBlock)(NSInteger index);
@property (nonatomic, copy) void(^didSelectItemAtIndexBlock)(NSInteger index);
@property (nonatomic, copy) void(^didEndTriggerFooterBlock)();

/**
 创建bannerView实例的方法

 @param frame bannerView的Frame
 @param dataSource 数据源代理
 @param delegate 普通代理
 @param emptyImage 空数据图片
 @param placeholderImage 默认图片
 @param selectorString 必须是 UIImageView 设置图片和placeholderImage的方法 如: @"sd_setImageWithURL:placeholderImage:", 分别接收NSURL和UIImage两个参数
 @return YJBannerView 实例
 */
+ (YJBannerView *)bannerViewWithFrame:(CGRect)frame
                           dataSource:(id<YJBannerViewDataSource>)dataSource
                             delegate:(id<YJBannerViewDelegate>)delegate
                           emptyImage:(UIImage *)emptyImage
                     placeholderImage:(UIImage *)placeholderImage
                       selectorString:(NSString *)selectorString;

/** 刷新BannerView数据 */
- (void)reloadData;

/** 停止定时器接口 */
- (void)invalidateTimerWhenAutoScroll;

/** 重新开启定时器 */
- (void)startTimerWhenAutoScroll;

/** 调整滚动到指定位置 */
- (void)adjustBannerViewScrollToIndex:(NSInteger)index animated:(BOOL)animated;

/** 如果卡屏请在控制器 viewWillAppear 内调用此方法 */
- (void)adjustBannerViewWhenCardScreen;

@end

#pragma mark - 协议部分
@protocol YJBannerViewDataSource <NSObject>

@required
/**
 显示Banner数据源代理方法

 @param bannerView 当前Banner
 @return 兼容 http(s):// 和 本地图片Name 类型: NSString 数组
 */
- (NSArray *)bannerViewImages:(YJBannerView *)bannerView;

@optional
/** 文字数据源 */
- (NSArray *)bannerViewTitles:(YJBannerView *)bannerView;

/**
 自定义 View 要同时配合实现以下3个方法

 @param bannerView 当前的Banner
 @return 需要注册的自定义View类的集合. e.g.: @[[CustomViewA class], [CustomViewB class]]
 */
- (NSArray *)bannerViewRegistCustomCellClass:(YJBannerView *)bannerView;
/** 根据 Index 选择使用哪个 reuseIdentifier */
- (Class)bannerView:(YJBannerView *)bannerView reuseIdentifierForIndex:(NSInteger)index;
/** 自定义 View 刷新数据或者其他配置 */
- (UICollectionViewCell *)bannerView:(YJBannerView *)bannerView customCell:(UICollectionViewCell *)customCell index:(NSInteger)index;

/** Footer 高度 默认是 49.0 */
- (CGFloat)bannerViewFooterViewHeight:(YJBannerView *)bannerView;

@end

@protocol YJBannerViewDelegate <NSObject>

@optional
/** 正在滚动的位置及偏移量 */
- (void)bannerView:(YJBannerView *)bannerView didScrollCurrentIndex:(NSInteger)currentIndex contentOffset:(CGFloat)contentOffset;

/** 滚动到 index */
- (void)bannerView:(YJBannerView *)bannerView didScroll2Index:(NSInteger)index;

/** 点击回调 */
- (void)bannerView:(YJBannerView *)bannerView didSelectItemAtIndex:(NSInteger)index;

/** BannerView Footer 回调 */
- (void)bannerViewFooterDidEndTrigger:(YJBannerView *)bannerView;

@end

