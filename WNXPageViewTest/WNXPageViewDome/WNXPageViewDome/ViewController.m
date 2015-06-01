//
//  ViewController.m
//  WNXPageViewDome
//
//  Created by MacBook on 15/5/31.
//  Copyright (c) 2015年 维尼的小熊. All rights reserved.
//

#import "ViewController.h"
#import "WNXPageView.h"

@interface ViewController () <WNXPageViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //初始化WNXPageView对象
    WNXPageView *pageView = [[WNXPageView alloc] init];
    pageView.frame = CGRectMake((self.view.bounds.size.width - 350)/2, 60, 350, 230);
    //修改pageView内部pageControl属性
    pageView.pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
    pageView.pageControl.pageIndicatorTintColor = [UIColor grayColor];
    //如果图片是本地的图片，可以直接将图片数组赋值给pageView.imageArr属性
    pageView.imageArr = [NSArray arrayWithObjects:[UIImage imageNamed:@"img_00"],
                                                  [UIImage imageNamed:@"img_01"],
                                                  [UIImage imageNamed:@"img_02"],
                                                  [UIImage imageNamed:@"img_03"],
                                                  [UIImage imageNamed:@"img_04"],
                                                   nil];
    //如果图片需要网络获取
    //直接调用下面方法，将网络图片的URLString数组直接传入即可
//    //pleaseHoldImage为加载图片的占位图
//    NSArray *urlStingArr = @[@"http://pic.nipic.com/2007-11-09/200711912453162_2.jpg",
//                             @"http://pic2.ooopic.com/01/26/61/83bOOOPIC72.jpg",
//                             @"http://a2.att.hudong.com/04/58/300001054794129041580438110_950.jpg",
//                             @"http://d.hiphotos.baidu.com/zhidao/wh%3D600%2C800/sign=324d313a233fb80e0c8469d106e10316/21a4462309f79052ab867a350ef3d7ca7bcbd51b.jpg",
//                             @"http://img.xiaba.cvimage.cn/4cbc56c1a57e26873c140000.jpg"];
//    
//    [pageView imageWithURLStringArray:urlStingArr pleaseHoldImage:[UIImage imageNamed:@"img_00"]];
    //设置代理，监听UIImageView的点击
    pageView.delegate = self;
    [self.view addSubview:pageView];
}

#pragma mark - WNXPageView代理方法，监听图片的点击，返回点击的图片
- (void)imageViewIsClick:(UIImageView *)clickImageView
{

}


@end
