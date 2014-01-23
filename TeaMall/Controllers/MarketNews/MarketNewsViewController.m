//
//  MarketNewsViewController.m
//  TeaMall
//
//  Created by Carl on 14-1-10.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "MarketNewsViewController.h"
#import "UIViewController+AKTabBarController.h"
#import "DataAccess.h"
#import "UINavigationBar+Custom.h"
#import "CycleScrollView.h"
#import "NewsDetailViewController.h"
@interface MarketNewsViewController ()<CycleScrollViewDelegate,AODelegate>
{
    CycleScrollView * scrollView;
}
@end

@implementation MarketNewsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"市场资讯";
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"顶三儿-底板"]];
    
    DataAccess *dataAccess= [[DataAccess alloc]init];
    NSMutableArray *dataArray = [dataAccess getDateArray];
    
    self.aoView = [[AOWaterView alloc]initWithDataArray:dataArray];
    self.aoView.aoDelegate = self;
    //self.aoView.delegate=self;
    [self.view addSubview:self.aoView];
    
    
    CGRect tempScrollViewRect = CGRectMake(0, 0, 320, self.adScrolllView.frame.size.height);
     NSArray * tempArray = @[[UIImage imageNamed:@"广告1"],[UIImage imageNamed:@"广告1"],[UIImage imageNamed:@"整桶（选中状态）"]];
    scrollView = [[CycleScrollView alloc]initWithFrame:tempScrollViewRect
                                        cycleDirection:CycleDirectionLandscape
                                              pictures:tempArray
                                            autoScroll:YES];
    CGRect pageControlRect = scrollView.pageControl.frame;
    pageControlRect.origin.x = 260;
    scrollView.pageControl.frame = pageControlRect;
    //scrollView.delegate = self;
    [self.adScrolllView addSubview:scrollView.pageControl];
    [self.adScrolllView addSubview:scrollView];
    scrollView = nil;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

//加载调用的方法
- (void)getNextPageView
{
    DataAccess *dataAccess= [[DataAccess alloc]init];
    NSMutableArray *dataArray = [dataAccess getDateArray];
    [self.aoView getNextPage:dataArray];
}

- (void)clickAction:(DataInfo *)data
{
    NewsDetailViewController *newsDetailViewController = [[NewsDetailViewController alloc]initWithNibName:@"NewsDetailViewController" bundle:nil];
    [self.navigationController pushViewController:newsDetailViewController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)tabImageName
{
	return @"市场资讯-图标（黑）";
}

- (NSString *)tabTitle
{
	return nil;
}

@end
