//
//  WNXPageView.h
//  AutoScrollView
//
//  Created by MacBook on 15/5/31.
//  Copyright (c) 2015年 维尼的小熊. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WNXPageViewDelegate <NSObject>

/** 返回被点击的imageView*/
- (void)imageViewIsClick:(UIImageView *)clickImageView;

@end

@interface WNXPageView : UIView

/** 传入图片数组*/
@property (nonatomic, strong) NSArray *imageArr;
/** 如果图片需要从网络获取，设置imageURLStringArr */
@property (nonatomic, strong) NSArray *imageURLStringArr;
/** 图片是否是上下滑动 默认是NO*/
@property (assign, nonatomic, getter=isScrollDirectionPortrait) BOOL scrollDirectionPortrait;
/** pageControl,可以修改pageControl的属性*/
@property (nonatomic, strong) UIPageControl *pageControl;
/** 代理*/
@property (nonatomic, assign) id <WNXPageViewDelegate> delegate;

- (void)imageWithURLStringArray:(NSArray *)urlStringArray pleaseHoldImage:(UIImage *)image;

@end
