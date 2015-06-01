//
//  WNXPageView.m
//  AutoScrollView
//
//  Created by MacBook on 15/5/31.
//  Copyright (c) 2015年 维尼的小熊. All rights reserved.
//

#import "WNXPageView.h"
#import "UIImageView+WebCache.h"

/** 图片切换动画时间 */
#define KImageCutTimeInterval 2.0f
/** 图片滑动动画时间 */
#define KImageSkideTimeInterval 0.5f

@interface WNXPageView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, weak) NSTimer *timer;

@property (nonatomic, strong) UIImage *pleaseHoldImage;

@end

@implementation WNXPageView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.bounces = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.userInteractionEnabled = YES;
        [self addSubview:_scrollView];
        
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.hidesForSinglePage = YES;
        [self addSubview:_pageControl];
    }
    
    return self;
}

- (void)setImageArr:(NSArray *)imageArr
{
    _imageArr = imageArr;
    
    [self timerStop];
    //将scrollView的子控件清空
    [_scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    BOOL isURL = [imageArr[0] isKindOfClass:[NSURL class]];
    
    NSInteger imageCount = imageArr.count;
    
    for (int i = 0; i<imageCount + 2; i++) {
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.userInteractionEnabled = YES;
        imageView.tag = i;
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                               action:@selector(ViewClick:)];
        [imageView addGestureRecognizer:tapGestureRecognizer];
        
        if (i == 0) {
            if (isURL) {
                [imageView sd_setImageWithURL:imageArr[imageCount - 1] placeholderImage:self.pleaseHoldImage];
            } else {
                imageView.image = imageArr[imageCount - 1];
            }
        } else if (i == (imageCount + 1)) {
            if (isURL) {
                [imageView sd_setImageWithURL:imageArr[0] placeholderImage:self.pleaseHoldImage];
            } else {
                imageView.image = imageView.image =imageArr[0];
            }
        } else {
            if (isURL) {
                [imageView sd_setImageWithURL:imageArr[i - 1] placeholderImage:self.pleaseHoldImage];
            } else {
                imageView.image = imageArr[i - 1];
            }
        }
        
        [_scrollView addSubview:imageView];
    }
    
    _pageControl.numberOfPages = imageCount;
    
    [self timerStart];
}

-(void)imageWithURLStringArray:(NSArray *)urlStringArray pleaseHoldImage:(UIImage *)image
{
    if (urlStringArray.count == 0) return;
    
    _pleaseHoldImage = image;
    
    NSMutableArray *urlArr = [NSMutableArray array];
    NSURL *url = nil;
    
    for (int i = 0; i<urlStringArray.count; i++) {
        url = [NSURL URLWithString:urlStringArray[i]];
        [urlArr addObject:url];
    }
    
    [self setImageArr:urlArr];
}

#pragma mark - 设置内部控件的位置
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.scrollView.frame = self.bounds;
    
    CGFloat scrollW = self.bounds.size.width;
    CGFloat scrollH = self.bounds.size.height;
    NSInteger imageCount = _imageArr.count + 2;
    
    if (self.isScrollDirectionPortrait) {
        _scrollView.contentSize = CGSizeMake(0, scrollH * imageCount);
        _scrollView.contentOffset = CGPointMake(0, scrollH);
    } else {
        _scrollView.contentSize = CGSizeMake(scrollW * imageCount, 0);
        _scrollView.contentOffset = CGPointMake(scrollW, 0);
    }
    
    for (int i = 0; i<imageCount; i++) {
        UIImageView *scrollSubView = _scrollView.subviews[i];
        
        if (self.isScrollDirectionPortrait) {
            scrollSubView.frame = CGRectMake(0, i * scrollH, scrollW, scrollH);
        } else {
            scrollSubView.frame = CGRectMake(i * scrollW, 0, scrollW, scrollH);
        }
    }
    
    CGFloat pageViewW = 80;
    CGFloat pageViewH = 20;
    CGFloat pageViewX = scrollW - pageViewW - 5;
    CGFloat pageViewY = scrollH - pageViewH - 5;
    self.pageControl.frame = CGRectMake(pageViewX, pageViewY, pageViewW, pageViewH);
    
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat scrolloffset = self.isScrollDirectionPortrait ? scrollView.contentOffset.y : scrollView.contentOffset.x;
    CGFloat scrollW = self.isScrollDirectionPortrait ? scrollView.bounds.size.height : scrollView.bounds.size.width;
    int pageNum = (int)(scrolloffset / scrollW + 0.5) - 1;
    
    self.pageControl.currentPage = pageNum;
    
    if (scrolloffset == 0) {
        if (self.isScrollDirectionPortrait) {
            self.scrollView.contentOffset  = CGPointMake(0, _imageArr.count * scrollW);
        } else {
            self.scrollView.contentOffset = CGPointMake(_imageArr.count * scrollW, 0);
        }
    } else if (scrolloffset == (_imageArr.count + 1)* scrollW) {
        if (self.isScrollDirectionPortrait) {
            self.scrollView.contentOffset = CGPointMake(0, scrollW);
        } else {
            self.scrollView.contentOffset = CGPointMake(scrollW, 0);
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self timerStop];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self timerStart];
}

#pragma  mark - Timer
- (void)timerStart
{
    //此处TimeInterval为图片切换的速度，修改速度就在此处改值
    NSTimer * timer = [NSTimer scheduledTimerWithTimeInterval:KImageCutTimeInterval target:self selector:@selector(scrollViewStartScroll) userInfo:nil repeats:YES];
    //将时间控制器放到RunLoop中，防止主线程被占用时时间器停止
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    self.timer = timer;
    
}

- (void)timerStop
{
    [_timer invalidate];
    _timer = nil;
}

#pragma mark -
- (void)scrollViewStartScroll
{
    CGFloat scrolloffset = self.isScrollDirectionPortrait ? _scrollView.contentOffset.y : _scrollView.contentOffset.x;
    CGFloat scrollW = self.isScrollDirectionPortrait ? _scrollView.bounds.size.height : _scrollView.bounds.size.width;
    CGPoint offset = self.isScrollDirectionPortrait ? CGPointMake(0, scrolloffset + scrollW) : CGPointMake(scrolloffset + scrollW, 0);
    
    [UIView animateWithDuration:KImageSkideTimeInterval animations:^{
        _scrollView.contentOffset = offset;
    }];
    
}

- (void)ViewClick:(UITapGestureRecognizer *)tap
{
    if ([self.delegate respondsToSelector:@selector(imageViewIsClick:)]) {
        [self.delegate imageViewIsClick:(UIImageView *)tap.view];
    }
}

@end
