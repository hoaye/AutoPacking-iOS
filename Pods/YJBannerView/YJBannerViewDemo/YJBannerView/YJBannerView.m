//
//  YJBannerView.m
//  YJBannerViewDemo
//
//  Created by YJHou on 2015/5/24.
//  Copyright © 2015年 Address:https://github.com/stackhou/YJBannerViewOC . All rights reserved.
//

/**
 __   __  _ ____                            __     ___
 \ \ / / | | __ )  __ _ _ __  _ __   ___ _ __ \   / (_) _____      __
  \ V /  | |  _ \ / _` | '_ \| '_ \ / _ \ '__\ \ / /| |/ _ \ \ /\ / /
   | | |_| | |_) | (_| | | | | | | |  __/ |   \ V / | |  __/\ V  V /
   |_|\___/|____/ \__,_|_| |_|_| |_|\___|_|    \_/  |_|\___| \_/\_/
 
 */

#import "YJBannerView.h"
#import "YJBannerViewCell.h"
#import "UIView+YJBannerViewExt.h"
#import "YJHollowPageControl.h"
#import "YJBannerViewFooter.h"

static NSString *const bannerViewCellId         = @"YJBannerView";
static NSString *const bannerViewFooterId       = @"YJBannerViewFooter";
static NSInteger const totalCollectionViewCellCount = 200;
#define kPageControlDotDefaultSize CGSizeMake(8, 8)
#define BANNER_FOOTER_HEIGHT 49.0

@interface YJBannerView () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout> {
    YJBannerViewCollectionView *_collectionView;
    UICollectionViewFlowLayout *_flowLayout;
}

@property (nonatomic, weak) UIControl *pageControl;
@property (nonatomic, weak) NSTimer *timer;
@property (nonatomic, assign) NSInteger totalBannerItemsCount;
@property (nonatomic, strong) NSArray *saveScrollViewGestures;
@property (nonatomic, strong) YJBannerViewFooter *bannerFooter;
@property (nonatomic, strong) NSArray *showNewDatasource;
@property (nonatomic, assign) CGFloat lastContentOffset;

@end

@implementation YJBannerView
@synthesize autoScroll = _autoScroll;
@synthesize cycleScrollEnable = _cycleScrollEnable;
@synthesize bannerImageViewContentMode = _bannerImageViewContentMode;
@synthesize pageControlNormalColor = _pageControlNormalColor;
@synthesize pageControlHighlightColor = _pageControlHighlightColor;

#pragma mark - Public API
+ (YJBannerView *)bannerViewWithFrame:(CGRect)frame
                           dataSource:(id<YJBannerViewDataSource>)dataSource
                             delegate:(id<YJBannerViewDelegate>)delegate
                           emptyImage:(UIImage *)emptyImage
                     placeholderImage:(UIImage *)placeholderImage
                       selectorString:(NSString *)selectorString{
    
    YJBannerView *bannerView = [[YJBannerView alloc] initWithFrame:frame];
    bannerView.dataSource = dataSource;
    bannerView.delegate = delegate;
    bannerView.bannerViewSelectorString = selectorString;
    bannerView.emptyImage = emptyImage;
    bannerView.placeholderImage = placeholderImage;

    return bannerView;
}

- (void)reloadData{
    
    [self invalidateTimer];
    self.showNewDatasource = [self _getImageDataSources];
    
    // Hidden when data source is greater than zero
    self.backgroundImageView.hidden = ([self _imageDataSources].count > 0);
    
    if ([self _imageDataSources].count > 1) {
        self.collectionView.scrollEnabled = YES;
        [self setAutoScroll:self.autoScroll];
    } else {
        
        if ([self _imageDataSources].count == 0) { self.showFooter = NO; }
        
        BOOL isCan = ([self _imageDataSources].count == 0)?NO:(self.showFooter?YES:NO);
        
        self.collectionView.scrollEnabled = isCan;
        
        [self invalidateTimerWhenAutoScroll];
    }
    
    [self _setFooterViewCanShow:self.showFooter];
    [self _setupPageControl];
    
    // Regist Custom Cell
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(bannerViewRegistCustomCellClass:)] && [self.dataSource bannerViewRegistCustomCellClass:self]) {
        NSArray *clazzs = [self.dataSource bannerViewRegistCustomCellClass:self];
        for (Class clazz in clazzs) {
            [self.collectionView registerClass:clazz forCellWithReuseIdentifier:NSStringFromClass(clazz)];
        }
    }
    
    [self.collectionView reloadData];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self _initSetting];
        [self addSubview:self.collectionView];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self _initSetting];
        [self addSubview:self.collectionView];
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [self _initSetting];
    [self addSubview:self.collectionView];
}

/** Initialize the default settings */
- (void)_initSetting{
    
    self.backgroundColor = [UIColor whiteColor];
    _autoDuration = 3.0;
    _autoScroll = YES;
    _pageControlStyle = PageControlSystem;
    _pageControlAliment = PageControlAlimentCenter;
    _pageControlDotSize = kPageControlDotDefaultSize;
    _pageControlBottomMargin = 10.0f;
    _pageControlHorizontalEdgeMargin = 10.0f;
    _pageControlPadding = 5.0f;
    
    _titleHeight = 30.0f;
    _titleEdgeMargin = 10.0f;
    _titleAlignment = NSTextAlignmentLeft;
    _bannerGestureEnable = YES;
    _cycleScrollEnable = YES;
    
    _showFooter = NO;
    _footerIndicateImageName = @"YJBannerView.bundle/yjbanner_arrow.png";
    _footerNormalTitle = @"拖动查看详情";
    _footerTriggerTitle = @"释放查看详情";
}

#pragma mark - Setter && Getter
- (void)setEmptyImage:(UIImage *)emptyImage{
    _emptyImage = emptyImage;
    if (emptyImage) {
        self.backgroundImageView.image = emptyImage;
    }
}

- (void)setPageControlDotSize:(CGSize)pageControlDotSize{
    
    _pageControlDotSize = pageControlDotSize;
    
    [self _setupPageControl];
    if ([self.pageControl isKindOfClass:[YJHollowPageControl class]]) {
        YJHollowPageControl *pageContol = (YJHollowPageControl *)_pageControl;
        pageContol.dotSize = pageControlDotSize;
    }
}

- (void)setPageControlStyle:(PageControlStyle)pageControlStyle{
    
    _pageControlStyle = pageControlStyle;
    
    [self _setupPageControl];
}

- (void)setPageControlNormalColor:(UIColor *)pageControlNormalColor{
    
    _pageControlNormalColor = pageControlNormalColor;
    
    if ([self.pageControl isKindOfClass:[YJHollowPageControl class]]) {
        YJHollowPageControl *pageControl = (YJHollowPageControl *)_pageControl;
        pageControl.dotNormalColor = pageControlNormalColor;
    }else if ([self.pageControl isKindOfClass:[UIPageControl class]]) {
        UIPageControl *pageControl = (UIPageControl *)_pageControl;
        pageControl.pageIndicatorTintColor = pageControlNormalColor;
    }
}

- (void)setPageControlHighlightColor:(UIColor *)pageControlHighlightColor{
    
    _pageControlHighlightColor = pageControlHighlightColor;
    
    if ([self.pageControl isKindOfClass:[YJHollowPageControl class]]) {
        YJHollowPageControl *pageControl = (YJHollowPageControl *)_pageControl;
        pageControl.dotCurrentColor = pageControlHighlightColor;
    } else if ([self.pageControl isKindOfClass:[UIPageControl class]]){
        UIPageControl *pageControl = (UIPageControl *)_pageControl;
        pageControl.currentPageIndicatorTintColor = pageControlHighlightColor;
    }
}

- (void)setCustomPageControlNormalImage:(UIImage *)customPageControlNormalImage{
    _customPageControlNormalImage = customPageControlNormalImage;
    [self setCustomPageControlDotImage:customPageControlNormalImage isCurrentPageDot:NO];
}

- (void)setCustomPageControlHighlightImage:(UIImage *)customPageControlHighlightImage{
    _customPageControlHighlightImage = customPageControlHighlightImage;
    [self setCustomPageControlDotImage:customPageControlHighlightImage isCurrentPageDot:YES];
}

- (void)setCustomPageControlDotImage:(UIImage *)image isCurrentPageDot:(BOOL)isCurrentPageDot{
    
    if (!image || !self.pageControl) return;
    
    if ([self.pageControl isKindOfClass:[YJHollowPageControl class]]) {
        YJHollowPageControl *pageControl = (YJHollowPageControl *)_pageControl;
        if (isCurrentPageDot) {
            pageControl.dotCurrentImage = image;
        } else {
            pageControl.dotNormalImage = image;
        }
    }
}

- (void)setAutoScroll:(BOOL)autoScroll{
    
    _autoScroll = autoScroll;
    [self invalidateTimer];
    if (autoScroll) {
        [self _setupTimer];
    }
}

- (void)setBannerViewScrollDirection:(BannerViewDirection)bannerViewScrollDirection{
    
    if (self.showFooter && bannerViewScrollDirection != BannerViewDirectionLeft) {
        bannerViewScrollDirection = BannerViewDirectionLeft;
    }

    _bannerViewScrollDirection = bannerViewScrollDirection;
    
    if (bannerViewScrollDirection == BannerViewDirectionLeft || bannerViewScrollDirection == BannerViewDirectionRight) {
        self.flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }else if (bannerViewScrollDirection == BannerViewDirectionTop || bannerViewScrollDirection == BannerViewDirectionBottom){
        self.flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    }
}

- (void)setAutoDuration:(CGFloat)autoDuration{
    
    _autoDuration = autoDuration;
    [self setAutoScroll:self.autoScroll];
}

- (void)setBannerGestureEnable:(BOOL)bannerGestureEnable{
    if (_bannerGestureEnable && bannerGestureEnable) { // 不操作
    }else if (!_bannerGestureEnable && bannerGestureEnable){
        self.collectionView.canCancelContentTouches = YES;
        for (NSInteger i = 0; i < self.saveScrollViewGestures.count; i++) {
            UIGestureRecognizer *gesture = self.saveScrollViewGestures[i];
            if (![self.collectionView.gestureRecognizers containsObject:gesture]) {
                [self.collectionView addGestureRecognizer:gesture];
            }
        }
    }else if (_bannerGestureEnable && !bannerGestureEnable){
        self.collectionView.canCancelContentTouches = NO;
        for (UIGestureRecognizer *gesture in self.collectionView.gestureRecognizers) {
            if ([gesture isKindOfClass:[UIPanGestureRecognizer class]]) {
                [self.collectionView removeGestureRecognizer:gesture];
            }
        }
    }
    _bannerGestureEnable = bannerGestureEnable;
}

- (void)setBannerImageViewContentMode:(UIViewContentMode)bannerImageViewContentMode{
    _bannerImageViewContentMode = bannerImageViewContentMode;
    self.backgroundImageView.contentMode = bannerImageViewContentMode;
}

- (NSInteger)repeatCount{
    if (_repeatCount <= 0) {
        return totalCollectionViewCellCount;
    }else{
        if (_repeatCount % 2 != 0) {
            return _repeatCount + 1;
        }else{
            return _repeatCount;
        }
    }
}

#pragma mark - Getter
- (NSInteger)totalBannerItemsCount{
    
    return self.cycleScrollEnable?(([self _imageDataSources].count > 1)?([self _imageDataSources].count * self.repeatCount):[self _imageDataSources].count):([self _imageDataSources].count);
}

- (BOOL)autoScroll{
    if (self.showFooter) {
        return NO;
    }
    return _autoScroll;
}

- (BOOL)cycleScrollEnable{
    if (self.showFooter) {
        return NO;
    }
    return _cycleScrollEnable;
}

- (UIFont *)titleFont{
    if (!_titleFont) {
        _titleFont = [UIFont systemFontOfSize:14.0f];
    }
    return _titleFont;
}

- (UIColor *)titleTextColor{
    if (!_titleTextColor) {
        _titleTextColor = [UIColor whiteColor];
    }
    return _titleTextColor;
}

- (UIColor *)titleBackgroundColor{
    if (!_titleBackgroundColor) {
        _titleBackgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    }
    return _titleBackgroundColor;
}

- (UIFont *)footerTitleFont{
    if (!_footerTitleFont) {
        _footerTitleFont = [UIFont systemFontOfSize:12.0f];
    }
    return _footerTitleFont;
}

- (UIColor *)footerTitleColor{
    if (!_footerTitleColor) {
        _footerTitleColor = [UIColor darkGrayColor];
    }
    return _footerTitleColor;
}

- (UIViewContentMode)bannerImageViewContentMode{
    if (!_bannerImageViewContentMode) {
        _bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    }
    return _bannerImageViewContentMode;
}

- (UIColor *)pageControlNormalColor{
    if (!_pageControlNormalColor) {
        _pageControlNormalColor = [UIColor lightGrayColor];
    }
    return _pageControlNormalColor;
}

- (UIColor *)pageControlHighlightColor{
    if (!_pageControlHighlightColor) {
        _pageControlHighlightColor = [UIColor whiteColor];
    }
    return _pageControlHighlightColor;
}

- (NSArray *)saveScrollViewGestures{
    if (!_saveScrollViewGestures) {
        _saveScrollViewGestures = [self.collectionView.gestureRecognizers copy];
    }
    return _saveScrollViewGestures;
}

#pragma mark - layoutSubviews
- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.dataSource = self.dataSource;
    [super layoutSubviews];
    
    self.flowLayout.itemSize = self.frame.size;
    
    self.collectionView.frame = self.bounds;
    
    if (self.collectionView.contentOffset.x == 0 &&  self.totalBannerItemsCount) {
        NSInteger targetIndex = self.cycleScrollEnable?(self.totalBannerItemsCount * 0.5):(0);
        [self _scrollBannerViewToSpecifiedPositionIndex:targetIndex animated:NO];
    }
    
    CGSize size = CGSizeZero;
    
    if ([self.pageControl isKindOfClass:[YJHollowPageControl class]]) {
        
        YJHollowPageControl *pageControl = (YJHollowPageControl *)_pageControl;
        
        if (!(self.customPageControlNormalImage && self.customPageControlHighlightImage && CGSizeEqualToSize(kPageControlDotDefaultSize, self.pageControlDotSize))) {
            pageControl.dotSize = self.pageControlDotSize;
        }
        
        size = [pageControl sizeForNumberOfPages:[self _imageDataSources].count];
    } else {
        size = CGSizeMake([self _imageDataSources].count * self.pageControlDotSize.width * 1.5, self.pageControlDotSize.height);
    }
    CGFloat x = (self.width_bannerView - size.width) * 0.5;
    if (self.pageControlAliment == PageControlAlimentLeft) {
        x = 0.0f;
    }else if (self.pageControlAliment == PageControlAlimentCenter){
    }else if (self.pageControlAliment == PageControlAlimentRight){
        x = self.collectionView.width_bannerView - size.width;
    }
    
    CGFloat y = self.collectionView.height_bannerView - size.height;
    
    if ([self.pageControl isKindOfClass:[YJHollowPageControl class]]) {
        
        YJHollowPageControl *pageControl = (YJHollowPageControl *)_pageControl;
        [pageControl sizeToFit];
    }
    
    CGRect pageControlFrame = CGRectMake(x, y, size.width, size.height);
    if (self.pageControlAliment == PageControlAlimentLeft) {
        pageControlFrame.origin.x += self.pageControlHorizontalEdgeMargin;
    }else if (self.pageControlAliment == PageControlAlimentRight){
        pageControlFrame.origin.x -= self.pageControlHorizontalEdgeMargin;
    }
    pageControlFrame.origin.y -= self.pageControlBottomMargin;
    self.pageControl.frame = pageControlFrame;
    
    self.pageControl.hidden = self.pageControlStyle == PageControlNone;
    
    if (self.backgroundImageView) {
        self.backgroundImageView.frame = self.bounds;
    }
}

#pragma mark - Resolve compatibility optimization issues
- (void)willMoveToSuperview:(UIView *)newSuperview{
    if (!newSuperview) {
        [self invalidateTimer];
    }
}

- (void)adjustBannerViewScrollToIndex:(NSInteger)index animated:(BOOL)animated{
    
    if (self.showNewDatasource.count == 0) { return; }
    if (index >= 0 && index < self.showNewDatasource.count) {
        if (self.autoScroll) { [self invalidateTimer]; }
        
        [self _scrollToIndex:((int)(self.totalBannerItemsCount * 0.5 + index)) animated:animated];
        
        if (self.autoScroll) { [self _setupTimer]; }
    }
}

- (void)adjustBannerViewWhenCardScreen{
    
    long targetIndex = [self _currentPageIndex];
    if (targetIndex < self.totalBannerItemsCount) {
        [self _scrollBannerViewToSpecifiedPositionIndex:targetIndex animated:NO];
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.totalBannerItemsCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    YJBannerViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:bannerViewCellId forIndexPath:indexPath];
    long itemIndex = [self _getRealIndexFromCurrentCellIndex:indexPath.item];
    
    // Custom Cell
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(bannerViewRegistCustomCellClass:)] && [self.dataSource bannerViewRegistCustomCellClass:self] && [self.dataSource respondsToSelector:@selector(bannerView:customCell:index:)] && [self.dataSource respondsToSelector:@selector(bannerView:reuseIdentifierForIndex:)]) {
        
        NSString *reuseIdentifier = NSStringFromClass([self.dataSource bannerView:self reuseIdentifierForIndex:itemIndex]);
        if (reuseIdentifier.length > 0) {
            UICollectionViewCell *customCell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
            
            if ([self.dataSource bannerView:self customCell:customCell index:itemIndex]) {
                return customCell;
            }
        }
    }
    
    NSString *imagePath = (itemIndex < [self _imageDataSources].count)?[self _imageDataSources][itemIndex]:nil;
    NSString *title = (itemIndex < [self _titlesDataSources].count)?[self _titlesDataSources][itemIndex]:nil;
    
    if (!cell.isConfigured) {
        cell.titleLabelBackgroundColor = self.titleBackgroundColor;
        cell.titleLabelHeight = self.titleHeight;
        cell.titleLabelEdgeMargin = self.titleEdgeMargin;
        cell.titleLabelTextAlignment = self.titleAlignment;
        cell.titleLabelTextColor = self.titleTextColor;
        cell.titleLabelTextFont = self.titleFont;
        cell.showImageViewContentMode = self.bannerImageViewContentMode;
        cell.clipsToBounds = YES;
        cell.isConfigured = YES;
    }
    
    [cell cellWithSelectorString:self.bannerViewSelectorString imagePath:imagePath placeholderImage:self.placeholderImage title:title];

    return cell;
}

// Setting Footer Size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeMake((self.showFooter && [self _imageDataSources].count != 0)?[self _bannerViewFooterHeight]:0.0f, self.frame.size.height);
}

// Footer
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    if(kind == UICollectionElementKindSectionFooter){
        
        YJBannerViewFooter *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:bannerViewFooterId forIndexPath:indexPath];
        self.bannerFooter = footer;
        
        footer.IndicateImageName = self.footerIndicateImageName;
        footer.footerTitleFont = self.footerTitleFont;
        footer.footerTitleColor = self.footerTitleColor;
        footer.idleTitle = self.footerNormalTitle;
        footer.triggerTitle = self.footerTriggerTitle;
        
        footer.hidden = !(self.showFooter && [self _imageDataSources].count != 0);
        
        return footer;
    }
    return nil;
}

#pragma mark - UIScrollViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.delegate && [self.delegate respondsToSelector:@selector(bannerView:didSelectItemAtIndex:)]) {
        [self.delegate bannerView:self didSelectItemAtIndex:[self _getRealIndexFromCurrentCellIndex:indexPath.item]];
    }
    if (self.didSelectItemAtIndexBlock) {
        self.didSelectItemAtIndexBlock([self _getRealIndexFromCurrentCellIndex:indexPath.item]);
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (![self _imageDataSources].count) return;
    int itemIndex = [self _currentPageIndex];
    int indexOnPageControl = [self _getRealIndexFromCurrentCellIndex:itemIndex];
    
    // 手动退拽时左右两端
    if (scrollView == self.collectionView && scrollView.isDragging && self.cycleScrollEnable) {
        NSInteger targetIndex = self.totalBannerItemsCount * 0.5;
        if (itemIndex == 0) { // top
            [self _scrollBannerViewToSpecifiedPositionIndex:targetIndex animated:NO];
        }else if (itemIndex == (self.totalBannerItemsCount - 1)){ // bottom
            targetIndex -= 1;
            [self _scrollBannerViewToSpecifiedPositionIndex:targetIndex animated:NO];
        }
    }
    
    // pageControl
    if ([self.pageControl isKindOfClass:[YJHollowPageControl class]]) {
        YJHollowPageControl *pageControl = (YJHollowPageControl *)_pageControl;
        pageControl.currentPage = indexOnPageControl;
    } else {
        UIPageControl *pageControl = (UIPageControl *)_pageControl;
        pageControl.currentPage = indexOnPageControl;
    }
    
    // Footer
    if (self.showFooter) {
        static CGFloat lastOffset;
        CGFloat footerDisplayOffset = (self.collectionView.contentOffset.x - (self.flowLayout.itemSize.width * (self.totalBannerItemsCount - 1)));
        
        if (footerDisplayOffset > 0){
            if (footerDisplayOffset > [self _bannerViewFooterHeight]) {
                if (lastOffset > 0) return;
                self.bannerFooter.state = YJBannerViewStatusTrigger;
            } else {
                if (lastOffset < 0) return;
                self.bannerFooter.state = YJBannerViewStatusIdle;
            }
            lastOffset = footerDisplayOffset - [self _bannerViewFooterHeight];
        }
    }
    
    // contentOffset
    [self _saveInitializationContentOffsetJudgeZero:YES];
    CGFloat contentOffset = 0.0f;
    if (self.flowLayout.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        contentOffset = self.collectionView.contentOffset.x;
    } else {
        contentOffset = self.collectionView.contentOffset.y;
    }
    CGFloat distance = fabs(self.lastContentOffset - contentOffset);
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(bannerView:didScrollCurrentIndex:contentOffset:)]) {
        [self.delegate bannerView:self didScrollCurrentIndex:indexOnPageControl contentOffset:distance];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self invalidateTimerWhenAutoScroll];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    [self startTimerWhenAutoScroll];
    
    if (self.showFooter) {
        CGFloat footerDisplayOffset = (self.collectionView.contentOffset.x - (self.flowLayout.itemSize.width * (self.totalBannerItemsCount - 1)));
        
        if (footerDisplayOffset > [self _bannerViewFooterHeight]) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(bannerViewFooterDidEndTrigger:)]) {
                [self.delegate bannerViewFooterDidEndTrigger:self];
            }
            
            if (self.didEndTriggerFooterBlock) {
                self.didEndTriggerFooterBlock();
            }
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self scrollViewDidEndScrollingAnimation:self.collectionView];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    if (![self _imageDataSources].count) return;
    int itemIndex = [self _currentPageIndex];
    int indexOnPageControl = [self _getRealIndexFromCurrentCellIndex:itemIndex];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(bannerView:didScroll2Index:)]) {
        [self.delegate bannerView:self didScroll2Index:indexOnPageControl];
    }
    if (self.didScroll2IndexBlock) {
        self.didScroll2IndexBlock(indexOnPageControl);
    }
    
    [self _saveInitializationContentOffsetJudgeZero:NO];
}

#pragma mark - Private function method
/** install PageControl */
- (void)_setupPageControl{
    
    if (_pageControl) [_pageControl removeFromSuperview];
    
    if ([self _imageDataSources].count == 0) {return;}
    
    if ([self _imageDataSources].count == 1) {return;}
    
    int indexOnPageControl = [self _getRealIndexFromCurrentCellIndex:[self _currentPageIndex]];
    
    switch (self.pageControlStyle) {
        case PageControlNone:{
            break;
        }
        case PageControlSystem:{
            UIPageControl *pageControl = [[UIPageControl alloc] init];
            pageControl.numberOfPages = [self _imageDataSources].count;
            pageControl.currentPageIndicatorTintColor = self.pageControlHighlightColor;
            pageControl.pageIndicatorTintColor = self.pageControlNormalColor;
            pageControl.userInteractionEnabled = NO;
            pageControl.currentPage = indexOnPageControl;
            [self addSubview:pageControl];
            _pageControl = pageControl;
            break;
        }
        case PageControlHollow:{
            YJHollowPageControl *pageControl = [[YJHollowPageControl alloc] init];
            pageControl.numberOfPages = [self _imageDataSources].count;
            pageControl.dotNormalColor = self.pageControlNormalColor;
            pageControl.dotCurrentColor = self.pageControlHighlightColor;
            pageControl.userInteractionEnabled = NO;
            pageControl.resizeScale = 1.0;
            pageControl.spacing = self.pageControlPadding;
            pageControl.currentPage = indexOnPageControl;
            [self addSubview:pageControl];
            _pageControl = pageControl;
            break;
        }
        case PageControlCustom:{
            
            YJHollowPageControl *pageControl = [[YJHollowPageControl alloc] init];
            pageControl.numberOfPages = [self _imageDataSources].count;
            pageControl.dotNormalColor = self.pageControlNormalColor;
            pageControl.dotCurrentColor = self.pageControlHighlightColor;
            pageControl.userInteractionEnabled = NO;
            pageControl.resizeScale = 1.0;
            pageControl.spacing = self.pageControlPadding;
            pageControl.currentPage = indexOnPageControl;
            [self addSubview:pageControl];
            _pageControl = pageControl;
            
            if (self.customPageControlNormalImage) {
                self.customPageControlNormalImage = self.customPageControlNormalImage;
            }
            
            if (self.customPageControlHighlightImage) {
                self.customPageControlHighlightImage = self.customPageControlHighlightImage;
            }
        }
        default:
            break;
    }
}

/** install Timer */
- (void)_setupTimer{
    
    [self invalidateTimer];
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:self.autoDuration target:self selector:@selector(_automaticScrollAction) userInfo:nil repeats:YES];
    _timer = timer;
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

/** stop timer */
- (void)invalidateTimer{
    
    [_timer invalidate];
    _timer = nil;
}

/** stop timer api */
- (void)invalidateTimerWhenAutoScroll{
    if (self.autoScroll) {
        [self invalidateTimer];
    }
}

/** restart timer api */
- (void)startTimerWhenAutoScroll{
    if (self.autoScroll) {
        [self _setupTimer];
    }
}

- (void)_automaticScrollAction{
    
    if (self.totalBannerItemsCount == 0) return;
    int currentIndex = [self _currentPageIndex];
    if (self.bannerViewScrollDirection == BannerViewDirectionLeft || self.bannerViewScrollDirection == BannerViewDirectionTop) {
        [self _scrollToIndex:(currentIndex + 1) animated:YES];
    }else if (self.bannerViewScrollDirection == BannerViewDirectionRight || self.bannerViewScrollDirection == BannerViewDirectionBottom){
        if ((currentIndex - 1) < 0) { // 小于零
            currentIndex = self.cycleScrollEnable?(self.totalBannerItemsCount * 0.5):(0);
            [self _scrollBannerViewToSpecifiedPositionIndex:(currentIndex - 1) animated:NO];
        }else{
            [self _scrollToIndex:(currentIndex - 1) animated:YES];
        }
    }
}

- (void)_scrollToIndex:(int)targetIndex animated:(BOOL)animated{
    
    if (targetIndex >= self.totalBannerItemsCount) {  // 超过最大
        targetIndex = self.cycleScrollEnable?(self.totalBannerItemsCount * 0.5):(0);
        [self _scrollBannerViewToSpecifiedPositionIndex:targetIndex animated:NO];
    }else{
        [self _scrollBannerViewToSpecifiedPositionIndex:targetIndex animated:animated];
    }
}

/** current page index */
- (int)_currentPageIndex{
    
    if (self.collectionView.width_bannerView == 0 || self.collectionView.height_bannerView == 0) {return 0;}
    int index = 0;
    if (self.flowLayout.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        index = (self.collectionView.contentOffset.x + self.flowLayout.itemSize.width * 0.5) / self.flowLayout.itemSize.width;
    } else {
        index = (self.collectionView.contentOffset.y + self.flowLayout.itemSize.height * 0.5) / self.flowLayout.itemSize.height;
    }
    return MAX(0, index);
}

/** current real index */
- (int)_getRealIndexFromCurrentCellIndex:(NSInteger)cellIndex{
    return (int)cellIndex % [self _imageDataSources].count;
}

- (NSArray *)_imageDataSources{
    return self.showNewDatasource;
}

/** Get new data from the proxy method */
- (NSArray *)_getImageDataSources{
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(bannerViewImages:)]) {
        return [self.dataSource bannerViewImages:self];
    }
    return @[];
}

/** Get new data from the proxy method */
- (NSArray *)_titlesDataSources{
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(bannerViewTitles:)]) {
        return [self.dataSource bannerViewTitles:self];
    }
    return @[];
}

/** Footer Height */
- (CGFloat)_bannerViewFooterHeight{
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(bannerViewFooterViewHeight:)]) {
        return [self.dataSource bannerViewFooterViewHeight:self];
    }
    return BANNER_FOOTER_HEIGHT;
}

/** reload 时控制尾巴的显示和消失 */
- (void)_setFooterViewCanShow:(BOOL)showFooter{
    
    if (showFooter) {
        self.bannerViewScrollDirection = BannerViewDirectionLeft;
        self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, -[self _bannerViewFooterHeight]);
    }else{
        self.collectionView.contentInset = UIEdgeInsetsZero;
    }
    
    if (self.bannerViewScrollDirection == BannerViewDirectionLeft) {
        self.collectionView.alwaysBounceHorizontal = showFooter;
    }else {
        self.collectionView.accessibilityViewIsModal = showFooter;
    }
}

/** Scroll the CollectionView to the specified location */
- (void)_scrollBannerViewToSpecifiedPositionIndex:(NSInteger)targetIndex animated:(BOOL)animated{
    NSInteger itemCount = [self.collectionView numberOfItemsInSection:0];
    if (targetIndex < itemCount) {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:animated];
    }
}

/** Save the current offset */
- (void)_saveInitializationContentOffsetJudgeZero:(BOOL)judgeZero{
    
    if (self.collectionView.width_bannerView == 0 || self.collectionView.height_bannerView == 0) { return; }
    if (judgeZero) {
        if (self.lastContentOffset == 0) {
            
            if (self.flowLayout.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
                self.lastContentOffset = self.collectionView.contentOffset.x;
            } else {
                self.lastContentOffset = self.collectionView.contentOffset.y;
            }
        }
    }else{
        if (self.flowLayout.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
            self.lastContentOffset = self.collectionView.contentOffset.x;
        } else {
            self.lastContentOffset = self.collectionView.contentOffset.y;
        }
    }
}

#pragma mark - Lazy
- (UIImageView *)backgroundImageView{
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _backgroundImageView.contentMode = self.bannerImageViewContentMode;
        _backgroundImageView.clipsToBounds = YES;
        [self insertSubview:_backgroundImageView belowSubview:self.collectionView];
    }
    return _backgroundImageView;
}

- (UICollectionViewFlowLayout *)flowLayout{
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.minimumLineSpacing = 0.0f;
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _flowLayout;
}

- (YJBannerViewCollectionView *)collectionView{
    if (!_collectionView) {
        _collectionView = [[YJBannerViewCollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.flowLayout];
        _collectionView.pagingEnabled = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor clearColor];

        [_collectionView registerClass:[YJBannerViewCell class] forCellWithReuseIdentifier:bannerViewCellId];
        [_collectionView registerClass:[YJBannerViewFooter class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:bannerViewFooterId];
        
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.scrollsToTop = NO;
    }
    return _collectionView;
}

- (void)dealloc {
    self.collectionView.delegate = nil;
    self.collectionView.dataSource = nil;
}

@end
