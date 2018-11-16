//
//  YJBannerViewFooter.h
//  YJBannerViewDemo
//
//  Created by YJHou on 2015/5/24.
//  Copyright © 2015年 Address:https://github.com/stackhou . All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, YJBannerViewStatus) {
    YJBannerViewStatusIdle = 0,  // 闲置
    YJBannerViewStatusTrigger    // 触发
};

@interface YJBannerViewFooter : UICollectionReusableView

@property (nonatomic, assign) YJBannerViewStatus state;

@property (nonatomic, strong) UIFont *footerTitleFont;
@property (nonatomic, strong) UIColor *footerTitleColor;
@property (nonatomic, copy) NSString *IndicateImageName;    /**< 指示图片的名字 */
@property (nonatomic, copy) NSString *idleTitle;            /**< 闲置 */
@property (nonatomic, copy) NSString *triggerTitle;         /**< 触发 */

@end
