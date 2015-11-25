//
//  ViewController.m
//  ScrollView_无限循环
//
//  Created by Jinhong on 15-1-7.
//  Copyright (c) 2015年 xiaoxiaobing. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property(nonatomic , strong)NSArray *iteamArray;
@property(nonatomic , assign)int currentIndex;
@property(nonatomic , assign)int priventIndex;
@property(nonatomic , assign)int nextIndex;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupScrollView];
}

- (void)setupScrollView
{
    int count = (int)self.iteamArray.count;
    
    _currentIndex = 0;
    
    self.scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width * count, 0);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    
    [self setupFrameWithCurrentIndex];
    
    [self.scrollView setContentOffset:CGPointMake([UIScreen mainScreen].bounds.size.width, 0)];
}

- (void)setupFrameWithCurrentIndex
{
    int count = (int)self.iteamArray.count;//5
    
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
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    NSLog(@"%d",decelerate);
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    NSLog(@"%d",self.currentIndex);
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"%f",scrollView.contentOffset.x);
    NSLog(@"%f",scrollView.contentOffset.x / scrollView.bounds.size.width);
    _currentIndex += (scrollView.contentOffset.x / scrollView.bounds.size.width + 0.5  + self.iteamArray.count -1) ;
    NSLog(@"%d",_currentIndex);
    _currentIndex %= self.iteamArray.count;
    NSLog(@"%d",self.currentIndex);
    [self setupFrameWithCurrentIndex];
    [self.scrollView setContentOffset:CGPointMake([UIScreen mainScreen].bounds.size.width, 0)];
}

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
@end
