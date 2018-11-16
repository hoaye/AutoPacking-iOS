![Logo](https://ws2.sinaimg.cn/large/006tNc79ly1fl3joaz995j31kw09htj4.jpg)

<!--&middot;-->
[![Travis](https://img.shields.io/travis/stackhou/YJBannerViewOC.svg?style=flat)](https://github.com/stackhou/YJBannerViewOC.git)
[![Language](https://img.shields.io/badge/Language-Objective--C-FF7F24.svg?style=flat)](https://github.com/YJManager/YJBannerViewOC.git)
[![CocoaPods](https://img.shields.io/cocoapods/p/YJBannerView.svg)](https://github.com/stackhou/YJBannerViewOC.git)
[![CocoaPods](https://img.shields.io/cocoapods/v/YJBannerView.svg)](https://github.com/stackhou/YJBannerViewOC.git)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/stackhou/YJBannerViewOC.git)
<!-- [![CocoaPods](https://img.shields.io/cocoapods/at/YJBannerView.svg)](https://github.com/stackhou/YJBannerViewOC.git) -->

# YJBannerView
- 使用简单、功能丰富的 `Objective-C版` 轮播控件,  基于 `UICollectionView` 实现, 多种场景均支持使用.

## 效果样例
普通 | 自定义View
---- | ---
<img src="https://github.com/stackhou/YJBannerViewOC/blob/master/YJBannerViewDemo/Resources/bannerDemo.gif" width="300" height="563" /> | <img src="https://github.com/stackhou/YJBannerViewOC/blob/master/YJBannerViewDemo/Resources/videoDemo01.gif" width="300" height="563" />


## Features

- [x] 支持自带PageControl样式配置, 也支持自定义        
- [x] 支持上、下、左、右四个方向自动、手动动滚动
- [x] 支持自动滚动时间设置                               
- [x] 支持首尾循环滚动的开关
- [x] 支持滚动相关手势的开关                             
- [x] 支持ContentMode的设置                            
- [x] 支持Banner标题的设置自定义
- [x] 支持自定义UICollectionViewCell                    
- [x] 支持在Storyboard\xib中创建并配置其属性   
- [x] 支持非首尾循环的Footer样式和进入详情回调
- [x] 不依赖其他三方SDWebImage或者AFNetworking设置图片
- [x] 支持CocoaPods
- [x] 支持Carthage
- [x] 支持获取当前位置的自身偏移量


## Installation

### Cocoapods

YJBannerView is available through [CocoaPods](http://cocoapods.org). To install it, simply add the following line to your Podfile:

```ruby
    pod 'YJBannerView'
```

### Carthage
```ruby
    github "stackhou/YJBannerView"
```

## Usage

### 1.创建BannerView:
```objc
-(YJBannerView *)normalBannerView{
    if (!_normalBannerView) {
        _normalBannerView = [YJBannerView bannerViewWithFrame:CGRectMake(0, 20, kSCREEN_WIDTH, 180) dataSource:self delegate:self placeholderImageName:@"placeholder" selectorString:@"sd_setImageWithURL:placeholderImage:"];
        _normalBannerView.pageControlAliment = PageControlAlimentRight;
        _normalBannerView.autoDuration = 2.5f;
    }
    return _normalBannerView;
}
```
### 2.实现数据源方法和代理:
```objc
// 将网络图片或者本地图片 或者混合数组
- (NSArray *)bannerViewImages:(YJBannerView *)bannerView{
    return self.imageDataSources;
}

// 将标题对应数组传递给bannerView 如果不需要, 可以不实现该方法
- (NSArray *)bannerViewTitles:(YJBannerView *)bannerView{
    return self.titlesDataSources;
}

// 代理方法 点击了哪个bannerView 的 第几个元素
-(void)bannerView:(YJBannerView *)bannerView didSelectItemAtIndex:(NSInteger)index{
    NSString *title = [self.titlesDataSources objectAtIndex:index];
    NSLog(@"当前%@-->%@", bannerView, title);
}
```

### 扩展自定义方法
```objc
// 自定义Cell方法
- (Class)bannerViewCustomCellClass:(YJBannerView *)bannerView{
    return [HeadLinesCell class];
}

// 自定义Cell的数据刷新方法
- (void)bannerView:(YJBannerView *)bannerView customCell:(UICollectionViewCell *)customCell index:(NSInteger)index{

    HeadLinesCell *cell = (HeadLinesCell *)customCell;
    [cell cellWithHeadHotLineCellData:@"打折活动开始了~~快来抢购啊"];
}
```

## 版本记录

日期 | 版本号 | 更新内容
------ | ----- | ----
2015-5-10~2016-10-17 | 1.0~2.0 | 2.0之前的更新内容没有实际意义，省略...
2016-10-17~2017-01-01 | 2.0~2.1 | 功能完善Bug修复等
2017-01-01~2017-07-30 | 2.1~2.2 | 主要功能优化，新增FooterView等
2017-7-30~2017-09-30 |  2.2.0~2.3.0 | 调优、降低内存消耗等
2017-9-30 | 2.3.0 | 调优 创建该控件由原来的120毫秒 优化到只需要60毫秒左右，和创建一个UILabel相当。
2017-11-1 | 2.3.1 | 增加停止定时器和重新开启定时器API
2017-11-16 | 2.3.2 | 修复当数据为空时刷新后再次有数据刷新不滚动问题
2017-12-05 | 2.3.4 | 规范图片加载流程
2017-12-06 | 2.3.5 | 区分没有数据的占位图片和图片未加载的占位图片
2017-12-14 | 2.3.6 | 数据安全保护和数据更新速度优化
2017-12-15 | 2.3.7 | 增加当前滚动位置相对偏移量API
2018-01-18 | 2.3.8 | 优化自定义View的实现方式，支持不同位置的Banner自由选择显示类型
2018-06-21 | 2.3.9 | 更新 Cocoapods 配置 Source 的修正
2018-07-09 | 2.4.0 | 修改手势在iOS 8.1上面的 Crash Bug

## 性能表现

- 简单设置时：

![](https://ws2.sinaimg.cn/large/006tKfTcly1fk1lk1i4d7j30c903uwf8.jpg)

- 复杂设置时:

![](https://ws2.sinaimg.cn/large/006tKfTcly1fk1lktrc6fj30bu03q750.jpg)

---

## License

This code is distributed under the terms and conditions of the [MIT license](LICENSE).

## Change-log

A brief summary of each YJBannerView release can be found in the [CHANGELOG](CHANGELOG.mdown).
