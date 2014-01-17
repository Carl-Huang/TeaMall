//
//  MainViewController.m
//  TeaMall
//
//  Created by Carl on 14-1-10.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "MainViewController.h"
#import "UIViewController+AKTabBarController.h"
#import "UINavigationBar+Custom.h"
#import "HWSDK.h"
#import "CycleScrollView.h"
#import "BrandViewController.h"
#import "MarqueeLabel.h"
#import "SearchViewController.h"
#import "SquareViewController.h"
#import "PublicViewController.h"
#import "ControlCenter.h"
#import "AppDelegate.h"
#import "MarkCellDetailViewController.h"

@interface MainViewController ()<CycleScrollViewDelegate>
{
    //滚动的广告图
    CycleScrollView * scrollView;
    
    //滚动字幕
    MarqueeLabel * scrollLabel;
}
@end

@implementation MainViewController
#pragma mark - Life Cycle
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
    [self initUI];
    
}
-(void)viewDidAppear:(BOOL)animated
{
    NSLog(@"%s",__func__);
 
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dealloc
{
    [self setView:nil];
}

#pragma mark - Private Methods
- (NSString *)tabImageName
{
	return @"首页-图标（黑）";
}

- (NSString *)tabTitle
{
	return nil;
}

- (void)initUI
{
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"顶三儿-底板"]];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    UIBarButtonItem * flexBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem * searchItem = [self customBarItem:@"顶三儿-搜索（黑）" highLightImageName:@"顶三儿-搜索（白）" action:@selector(gotoSearchViewController) size:CGSizeMake(20,30)];
    UIImageView * pointImageView_1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 12, 4)];
    pointImageView_1.image = [UIImage imageNamed:@"两点"];
    UIImageView * pointImageView_2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 12, 4)];
    pointImageView_2.image = [UIImage imageNamed:@"两点副本"];
    UIBarButtonItem * pointItem_1 = [[UIBarButtonItem alloc] initWithCustomView:pointImageView_1];
    UIBarButtonItem * pointItem_2 = [[UIBarButtonItem alloc] initWithCustomView:pointImageView_2];
    UIBarButtonItem * squareItem = [self customBarItem:@"顶三儿-广场（黑）" highLightImageName:@"顶三儿-广场（白）" action:@selector(gotoSquareViewController) size:CGSizeMake(20,30)];
    UIBarButtonItem * publicItem = [self customBarItem:@"顶三儿-发布（黑）" highLightImageName:@"顶三儿-发布（白）" action:@selector(gotoPublicViewController) size:CGSizeMake(20, 35)];
    self.navigationItem.leftBarButtonItems = @[flexBarItem,searchItem,flexBarItem,pointItem_1,flexBarItem,squareItem,flexBarItem,pointItem_2,flexBarItem,publicItem,flexBarItem];

    //顶部的滚动图片
    NSArray * tempArray = @[[UIImage imageNamed:@"广告1"],[UIImage imageNamed:@"广告1"],[UIImage imageNamed:@"整桶（选中状态）"]];
    CGRect tempScrollViewRect = CGRectMake(0, 0, 320, self.adScrollBgView.frame.size.height);
    scrollView = [[CycleScrollView alloc]initWithFrame:tempScrollViewRect
                                        cycleDirection:CycleDirectionLandscape
                                              pictures:tempArray
                                            autoScroll:YES];
    scrollView.delegate = self;
    [self.adScrollBgView addSubview:scrollView];
    scrollView = nil;
    
    //中间的品牌浏览
    NSArray * imageArrays = @[[UIImage imageNamed:@"下关沱"],[UIImage imageNamed:@"合和昌"],[UIImage imageNamed:@"大益"],[UIImage imageNamed:@"广隆号"],[UIImage imageNamed:@"福村梅记"],[UIImage imageNamed:@"老同志"],[UIImage imageNamed:@"雨林"],[UIImage imageNamed:@"龙生"]];
    NSUInteger iconHeight = 65;
    NSUInteger iconWidth  = 65;
    for (int i =0; i<8; i++) {
        UIImageView * imageView = [[UIImageView alloc]initWithImage:[imageArrays objectAtIndex:i]];
        imageView.userInteractionEnabled = YES;
        imageView.tag = i;
        
        //添加点击事件
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBrandImageAction:)];
        [imageView addGestureRecognizer:tap];
        tap = nil;
        
        //调整位置
        [imageView setFrame: CGRectMake(15+(iconWidth+10)*(i%4), 15+(iconHeight+10)*(i/4), iconWidth, iconHeight)];
        [self.brandView addSubview:imageView];
        imageView = nil;
    }
    imageArrays = nil;
    
    //底部的广告
    NSArray * adImageArrays = @[[UIImage imageNamed:@"茶叶超市-图标（橙）"],[UIImage imageNamed:@"茶叶超市-图标（橙）"]];
    NSUInteger adIconHeight = self.bottomAdView.frame.size.height-40;
    NSUInteger adIconWidth = 145;
    for (int i =0; i<2; i++) {
         UIImageView * imageView = [[UIImageView alloc]initWithImage:[adImageArrays objectAtIndex:i]];
        [imageView setBackgroundColor:[UIColor redColor]];
        [imageView setFrame:CGRectMake(10+(adIconWidth+10)*i, 25, adIconWidth, adIconHeight)];
        [self.bottomAdView addSubview:imageView];
        imageView = nil;
    }
    
    //滚动字幕
    scrollLabel = [[MarqueeLabel alloc] initWithFrame:CGRectMake(0, 8, 320, 20) duration:4.0 andFadeLength:10.0f];
    [self.adScrollBgView bringSubviewToFront:self.scrollTextView];
    [self.adScrollBgView addSubview:scrollLabel];
    scrollLabel.numberOfLines = 1;
    scrollLabel.opaque = NO;
    scrollLabel.enabled = YES;
    scrollLabel.shadowOffset = CGSizeMake(0.0, -1.0);
    scrollLabel.textAlignment = UITextAlignmentLeft;
    scrollLabel.textColor = [UIColor whiteColor];
    scrollLabel.backgroundColor = [UIColor clearColor];
    scrollLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17.000];
    
    scrollLabel.text = @"carl,carl,carl,还是carl,carl,carl,carl,carl,carl,还是carl,carl,carl,carl,carl,carl,还是carl,carl,carl";
}

-(void)gotoSearchViewController
{
    NSArray * controllerArrays = self.childViewControllers;
    BOOL isShouldAddSearchViewController = YES;
    for (UIViewController * controller in controllerArrays) {
        if ([controller isKindOfClass:[SearchViewController class]]) {
            isShouldAddSearchViewController = NO;
            [self.view bringSubviewToFront:controller.view];
        }
    }
    if (isShouldAddSearchViewController) {
        SearchViewController * viewController = [[SearchViewController alloc]initWithNibName:@"SearchViewController" bundle:nil];
        [self addChildViewController:viewController];
        [self.view addSubview:viewController.view];
        viewController = nil;

    }
}

-(void)gotoSquareViewController
{
    NSArray * controllerArrays = self.childViewControllers;
    BOOL isShouldAddSearchViewController = YES;
    for (UIViewController * controller in controllerArrays) {
        if ([controller isKindOfClass:[SquareViewController class]]) {
            isShouldAddSearchViewController = NO;
            [self.view bringSubviewToFront:controller.view];
        }
    }
    if (isShouldAddSearchViewController) {
        SquareViewController * viewController = [[SquareViewController alloc]initWithNibName:@"SquareViewController" bundle:nil];
        [self addChildViewController:viewController];
        [self.view addSubview:viewController.view];
        viewController = nil;
        
    }
}


-(void)gotoPublicViewController
{
    NSArray * controllerArrays = self.childViewControllers;
    BOOL isShouldAddSearchViewController = YES;
    for (UIViewController * controller in controllerArrays) {
        if ([controller isKindOfClass:[PublicViewController class]]) {
            isShouldAddSearchViewController = NO;
            [self.view bringSubviewToFront:controller.view];
        }
    }
    if (isShouldAddSearchViewController) {
        PublicViewController * viewController = [[PublicViewController alloc]initWithNibName:@"PublicViewController" bundle:nil];
        [self addChildViewController:viewController];
        [self.view addSubview:viewController.view];
        viewController = nil;
        
    }
}
-(void)tapBrandImageAction:(UITapGestureRecognizer *)tapGesture
{
    NSLog(@"%s",__func__);
    UIImageView * imageView = (UIImageView *)tapGesture.view;
    NSLog(@"%d",imageView.tag);

    MarkCellDetailViewController * viewController = [[MarkCellDetailViewController alloc]initWithNibName:@"MarkCellDetailViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
    viewController = nil;
}

#pragma  mark - CycleScrollView Delegate
- (void)cycleScrollViewDelegate:(CycleScrollView *)cycleScrollView didSelectImageView:(int)index {
    
    NSLog(@"%s",__func__);
}
@end
