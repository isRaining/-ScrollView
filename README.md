

		在iOS开发过程中，UIScrollView经常会出现在项目中，例如商城类、新闻类的app，多会在UITableView头部添加一个轮播的滚动视图。还有图片的展示，发布的公告，商品详情图预览以及页面的切换，UIScrollView无疑是开发中最佳的选择。

这篇主要讲UIScrollView对于图片的循环轮播
## UIScrollView滚动展示

对于UIScrollView的滚动展示，相信这个最基本的大家都应该会，通常如果不多加留意，我们很容易做到图片的轮播。

**不加思索的做法**
```objc
//定义一个UIScrollView
@property (weak, nonatomic)UIScrollView *scrollView;
@property(nonatomic , assign)int currentIndex;//记录滚动的页面下标，初始化为0

//然后初始化该UIScrollView
 . . .（此处省略初始化方法）
 
//设置scrollView的内容，放置了5个View
for (int i = 0; i < 5; i ++ ) {
        UIView * view = [[UIView alloc]init];
        //设置每个View的frame
        view.frame = CGRectMake(i*kdeviceWidth, 100, kdeviceWidth, 200);
        //View随机生成颜色
        view.backgroundColor = [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1];
        UILabel *labe = [[UILabel alloc] initWithFrame:view.frame];
        labe.textAlignment = NSTextAlignmentCenter;
        labe.text = [NSString stringWithFormat:@"我是第   %d  个页面",i + 1 ];
        [view addSubview:labe];
        [self.scrollView addSubview:view];
    }


//开启定时器，使scrollView滚动
[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(xunhuan) userInfo:nil repeats:YES];

//设置循环方法
-(void)xunhuan
{
    _currentIndex += 1;//每次执行加1
    if (_currentIndex > 4) {//当大于4的时候，重新归0，从第0張开始
        _currentIndex = 0;
    }
    [self.scrollView setContentOffset:CGPointMake(kdeviceWidth*_currentIndex, 0) animated:YES];//设置scrollView的偏移量
}
```

效果如下
![这里写图片描述](http://img.blog.csdn.net/20151125145232308)
存在两个问题：

* 从第五张滚动到第一张有回滚的动画，体验不好
* 第五张后不能在同一个方向手动滚动到第一张

## 保持UIScrollView循环滚动
这里主要是一个思路问题：

* 可以让UIScrollView的当前页面和前后两个页面被加载，就可以模拟出正常的滑动效果
* 滚动结束后立即加载前后两张
* 保持滚动视图的偏移量不变，这样就能够一直手动的滑动它

代码如下：
```objc
//保持滑动视图的偏移位
[self.scrollView setContentOffset:CGPointMake([UIScreen mainScreen].bounds.size.width, 0)];

//创建内容数组
//添加了几个View
- (NSArray *)iteamArray
{
    if (_iteamArray == nil)
    {
        NSMutableArray *array = [NSMutableArray array];
        for (int i =0; i < 5; i++)
        {
            
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,230 )];
            view.backgroundColor = [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1];
            UILabel *labe = [[UILabel alloc] initWithFrame:view.frame];
            labe.textAlignment = NSTextAlignmentCenter;
            labe.text = [NSString stringWithFormat:@"我是第   %d  个页面",i + 1 ];
            [view addSubview:labe];
            [array addObject:view];
        }
       
        _iteamArray = [array copy];
    }
    return _iteamArray;
}

//设置scrollView的内容
- (void)setupFrameWithCurrentIndex
{
    int count = (int)self.iteamArray.count;
    
    UIView *currentView  = self.iteamArray[_currentIndex];
    CGRect frame = currentView.frame;
    frame.origin.x = frame.size.width;
    currentView.frame = frame;
    [self.scrollView addSubview:currentView];
    
    _priventIndex = (_currentIndex + count -1) %count;
    
    UIView *priventView  = self.iteamArray[_priventIndex];
    frame = priventView.frame;
    frame.origin.x = 0;
    priventView.frame = frame;
    [self.scrollView addSubview:priventView];
    
    _nextIndex = (_currentIndex + count  + 1) %count;
    
    
    UIView *nextView  = self.iteamArray[_nextIndex];
    frame = nextView.frame;
    frame.origin.x = 2 * frame.size.width;
    nextView.frame = frame;
    [self.scrollView addSubview:nextView];
    self.scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width * 3, 0);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
}

//实现代理方法，在代理方法中修改变量currentIndex
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _currentIndex += (scrollView.contentOffset.x / scrollView.bounds.size.width + 0.5  + self.iteamArray.count -1) ;
    _currentIndex %= self.iteamArray.count;
    [self setupFrameWithCurrentIndex];
    [self.scrollView setContentOffset:CGPointMake([UIScreen mainScreen].bounds.size.width, 0)];
}
```
最终实现效果如下图：
![这里写图片描述](http://img.blog.csdn.net/20151125152315618)

上图是手动滑动，如果需要定时滚动，只需要创建定时器，让变量currentIndex递加后归0，即可

项目源码：[点击下载页面](https://github.com/isRaining/-ScrollView)

---

有错误请告知我并帮助纠正，谢谢