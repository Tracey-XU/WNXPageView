# WNXPageView框架
#####封装的PageView框架，实现了图片轮播，手势滑动功能
###功能
- 图片无限循环播放展示
- 支持手势无限循环滑动
- 支持本地图片展示
- 支持网络URL加载图片展示
- 图片点击事件
- pageControl个性化定制
- 支持图片水平方向滑动或者垂直方向滑动

![image](/Users/macbook/Desktop/image.png)

###使用方法
- 使用非常简单,如果是本地图片直接放图片数组赋值给对象.imageArr即可
- 网络URL加载图片只需调用[pageView imageWithURLStringArray:urlStingArr pleaseHoldImage:[UIImage imageNamed:@"img_00"]];
- 将URLString数组传入即可
- 如需修改动画时间，只需在.m文件下的
- 默认是水平方向滑动 如需要垂直方向滑动只需设置pageView.scrollDirectionPortrait = NO即可
```
/** 图片切换动画时间 */
#define KImageCutTimeInterval 2.0f
/** 图片滑动动画时间 */
#define KImageSkideTimeInterval 0.5f
```

####代码Demo

```objc
    //初始化WNXPageView对象
    WNXPageView *pageView = [[WNXPageView alloc] init];
    pageView.frame = CGRectMake((self.view.bounds.size.width - 350)/2, 60, 350, 230);
    //修改pageView内部pageControl属性
    pageView.pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
    pageView.pageControl.pageIndicatorTintColor = [UIColor grayColor];
    //默认是水平方向滑动 如需要垂直方向滑动只需设置pageView.scrollDirectionPortrait = NO即可
    //如果图片是本地的图片，可以直接将图片数组赋值给pageView.imageArr属性
    pageView.imageArr = [NSArray arrayWithObjects:[UIImage imageNamed:@"img_00"],
                                                  [UIImage imageNamed:@"img_01"],
                                                  [UIImage imageNamed:@"img_02"],
                                                  [UIImage imageNamed:@"img_03"],
                                                  [UIImage imageNamed:@"img_04"],
                                                   nil];
    //如果图片需要网络获取
    //直接调用下面方法，将网络图片的URLString数组直接传入即可
    //pleaseHoldImage为加载图片的占位图
    NSArray *urlStingArr = @[@"http://pic.nipic.com/2007-11-09/200711912453162_2.jpg",
                             @"http://pic2.ooopic.com/01/26/61/83bOOOPIC72.jpg",
                             @"http://a2.att.hudong.com/04/58/300001054794129041580438110_950.jpg",
                             @"http://d.hiphotos.baidu.com/zhidao/wh%3D600%2C800/sign=
                             324d313a233fb80e0c8469d106e10316/21a4462309f79052ab867a350ef3d7ca7bcbd51b.jpg",
                             @"http://img.xiaba.cvimage.cn/4cbc56c1a57e26873c140000.jpg"];

    [pageView imageWithURLStringArray:urlStingArr pleaseHoldImage:[UIImage imageNamed:@"img_00"]];
    //设置代理，监听UIImageView的点击
    pageView.delegate = self;
    [self.view addSubview:pageView];
```
