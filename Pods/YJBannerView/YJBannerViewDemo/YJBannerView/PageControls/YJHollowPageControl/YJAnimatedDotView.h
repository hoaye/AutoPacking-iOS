//
//  YJAnimatedDotView.h
//  YJBannerViewDemo
//
//  Created by YJHou on 2015/5/24.
//  Copyright © 2015年 Address:https://github.com/stackhou . All rights reserved.
//

#import "YJAbstractDotView.h"

@interface YJAnimatedDotView : YJAbstractDotView

@property (nonatomic, strong) UIColor *dotColor;
@property (nonatomic, strong) UIColor *currentDotColor;
@property (nonatomic, assign) CGFloat resizeScale; /**< 调整比例 */

@end
