//
//  YJHollowPageControl.m
//  YJBannerViewDemo
//
//  Created by YJHou on 2015/5/24.
//  Copyright © 2015年 Address:https://github.com/stackhou . All rights reserved.
//

#import "YJHollowPageControl.h"
#import "YJAnimatedDotView.h"

static CGSize const kDefaultDotSize = {8, 8};
static NSInteger const kDefaultNumberOfPages = 0;
static NSInteger const kDefaultCurrentPage = 0;
static BOOL const kDefaultHideForSinglePage = NO;
static BOOL const kDefaultShouldResizeFromCenter = YES;
static NSInteger const kDefaultSpacingBetweenDots = 8;

@interface YJHollowPageControl ()

@property (nonatomic, strong) NSMutableArray *dots; /**< 保存所有的点 */

@end

@implementation YJHollowPageControl

- (id)init{
    self = [super init];
    if (self) {
        [self _initializationSetting];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self _initializationSetting];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self _initializationSetting];
    }
    return self;
}

- (void)_initializationSetting{
    self.dotViewClass           = [YJAnimatedDotView class];
    self.spacing                = kDefaultSpacingBetweenDots;
    self.numberOfPages          = kDefaultNumberOfPages;
    self.currentPage            = kDefaultCurrentPage;
    self.hidesForSinglePage     = kDefaultHideForSinglePage;
    self.shouldResizeFromCenter = kDefaultShouldResizeFromCenter;
}


#pragma mark - Touch event
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    if (touch.view != self) {
        NSInteger index = [self.dots indexOfObject:touch.view];
        if ([self.delegate respondsToSelector:@selector(yjHollowPageControl:didSelectPageAtIndex:)]) {
            [self.delegate yjHollowPageControl:self didSelectPageAtIndex:index];
        }
    }
}

- (void)sizeToFit{
    [self updateFrame:YES];
}

- (CGSize)sizeForNumberOfPages:(NSInteger)pageCount{
    return CGSizeMake((self.dotSize.width + self.spacing) * pageCount - self.spacing , self.dotSize.height);
}


- (void)updateDots{
    if (self.numberOfPages == 0) {return;}
    
    for (NSInteger i = 0; i < self.numberOfPages; i++) {
        
        UIView *dot;
        if (i < self.dots.count) {
            dot = [self.dots objectAtIndex:i];
        } else {
            dot = [self generateDotView];
        }
        [self updateDotFrame:dot atIndex:i];
    }
    [self changeActivity:YES atIndex:self.currentPage];
    
    [self hideForSinglePage];
}

/**
 Update frame to fit current number of pages.

 @param newFrame override Existing Frame
 */
- (void)updateFrame:(BOOL)newFrame{
    CGPoint center = self.center;
    CGSize requiredSize = [self sizeForNumberOfPages:self.numberOfPages];
    
    // We apply requiredSize only if authorize to and necessary
    if (newFrame || ((CGRectGetWidth(self.frame) < requiredSize.width || CGRectGetHeight(self.frame) < requiredSize.height) && !newFrame)) {
        self.frame = CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame), requiredSize.width, requiredSize.height);
        if (self.shouldResizeFromCenter) {
            self.center = center;
        }
    }
    [self resetDotViews];
}

/**
 *  Update the frame of a specific dot at a specific index
 *
 *  @param dot   Dot view
 *  @param index Page index of dot
 */
- (void)updateDotFrame:(UIView *)dot atIndex:(NSInteger)index{
    // Dots are always centered within view
    CGFloat x = (self.dotSize.width + self.spacing) * index + ( (CGRectGetWidth(self.frame) - [self sizeForNumberOfPages:self.numberOfPages].width) / 2);
    CGFloat y = (CGRectGetHeight(self.frame) - self.dotSize.height) / 2;
    
    dot.frame = CGRectMake(x, y, self.dotSize.width, self.dotSize.height);
}

- (void)setDotCurrentColor:(UIColor *)currentDotColor{
    _dotCurrentColor = currentDotColor;
}

- (void)setDotNormalColor:(UIColor *)dotColor{
    _dotNormalColor = dotColor;
}


#pragma mark - Utils
/**
 *  Generate a dot view and add it to the collection
 *
 *  @return The UIView object representing a dot
 */
- (UIView *)generateDotView{
    UIView *dotView;
    
    if (self.dotViewClass) {
        dotView = [[self.dotViewClass alloc] initWithFrame:CGRectMake(0, 0, self.dotSize.width, self.dotSize.height)];
        if ([dotView isKindOfClass:[YJAnimatedDotView class]]) {
            if (self.resizeScale > 0) {
                ((YJAnimatedDotView *)dotView).resizeScale = self.resizeScale;
            }
            if (self.dotNormalColor) {
                ((YJAnimatedDotView *)dotView).dotColor = self.dotNormalColor;
            }
            if (self.dotCurrentColor){
                ((YJAnimatedDotView *)dotView).currentDotColor = self.dotCurrentColor;
            }
        }
    } else {
        dotView = [[UIImageView alloc] initWithImage:self.dotNormalImage];
        dotView.contentMode = UIViewContentModeScaleAspectFit;
        dotView.frame = CGRectMake(0, 0, self.dotSize.width, self.dotSize.height);
    }
    
    if (dotView) {
        [self addSubview:dotView];
        [self.dots addObject:dotView];
    }
    
    dotView.userInteractionEnabled = YES;
    return dotView;
}


/**
 *  Change activity state of a dot view. Current/not currrent.
 *
 *  @param active Active state to apply
 *  @param index  Index of dot for state update
 */
- (void)changeActivity:(BOOL)active atIndex:(NSInteger)index{
    if (self.dotViewClass) {
        YJAbstractDotView *abstractDotView = (YJAbstractDotView *)[self.dots objectAtIndex:index];
        if ([abstractDotView respondsToSelector:@selector(changeActivityState:)]) {
            [abstractDotView changeActivityState:active];
        } else {
            NSLog(@"Custom view : %@ must implement an 'changeActivityState' method or you can subclass %@ to help you.", self.dotViewClass, [YJAbstractDotView class]);
        }
    } else if (self.dotNormalImage && self.dotCurrentImage) {
        UIImageView *dotView = (UIImageView *)[self.dots objectAtIndex:index];
        dotView.image = (active) ? self.dotCurrentImage : self.dotNormalImage;
    }
}

- (void)resetDotViews{
    for (UIView *dotView in self.dots) {
        [dotView removeFromSuperview];
    }
    [self.dots removeAllObjects];
    [self updateDots];
}

- (void)hideForSinglePage{
    if (self.dots.count == 1 && self.hidesForSinglePage) {
        self.hidden = YES;
    } else {
        self.hidden = NO;
    }
}

#pragma mark - Setters
- (void)setNumberOfPages:(NSInteger)numberOfPages{
    _numberOfPages = numberOfPages;
    // Update dot position to fit new number of pages
    [self resetDotViews];
}

- (void)setSpacing:(CGFloat)spacing{
    _spacing = spacing;
    [self resetDotViews];
}

- (void)setCurrentPage:(NSInteger)currentPage{
    // If no pages, no current page to treat.
    if (self.numberOfPages == 0 || currentPage == _currentPage) {
        _currentPage = currentPage;
        return;
    }
    
    // Pre set
    [self changeActivity:NO atIndex:_currentPage];
    _currentPage = currentPage;
    // Post set
    [self changeActivity:YES atIndex:_currentPage];
}

- (void)setDotNormalImage:(UIImage *)dotImage{
    _dotNormalImage = dotImage;
    [self resetDotViews];
    self.dotViewClass = nil;
}

- (void)setDotCurrentImage:(UIImage *)currentDotimage{
    _dotCurrentImage = currentDotimage;
    [self resetDotViews];
    self.dotViewClass = nil;
}

- (void)setDotViewClass:(Class)dotViewClass{
    _dotViewClass = dotViewClass;
    self.dotSize = CGSizeZero;
    [self resetDotViews];
}

#pragma mark - Getter
- (CGSize)dotSize{
    if (self.dotNormalImage && CGSizeEqualToSize(_dotSize, CGSizeZero)) {
        _dotSize = self.dotNormalImage.size;
    } else if (self.dotViewClass && CGSizeEqualToSize(_dotSize, CGSizeZero)) {
        _dotSize = kDefaultDotSize;
        return _dotSize;
    }
    return _dotSize;
}

#pragma mark - Lazy
- (NSMutableArray *)dots{
    if (!_dots) {
        _dots = [NSMutableArray array];
    }
    return _dots;
}

@end


@implementation YJDotView

- (instancetype)init{
    self = [super init];
    if (self) {
        [self _initializationSetting];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self _initializationSetting];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self _initializationSetting];
    }
    return self;
}

- (void)_initializationSetting{
    self.backgroundColor    = [UIColor clearColor];
    self.layer.cornerRadius = CGRectGetWidth(self.frame) * 0.5;
    self.layer.borderColor  = [UIColor whiteColor].CGColor;
    self.layer.borderWidth  = 2;
}

- (void)changeActivityState:(BOOL)active{
    if (active) {
        self.backgroundColor = [UIColor whiteColor];
    } else {
        self.backgroundColor = [UIColor clearColor];
    }
}

@end
