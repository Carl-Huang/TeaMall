//
//  MainViewController.m
//  TeaMall
//
//  Created by vedon on 13/1/12.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//
#define AddViewTag 1001

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
#import "MBProgressHUD.h"
#import "HttpService.h"
#import "TeaCategory.h"
#import "ControlCenter.h"
#import "MarketNews.h"
#import "UIImageView+AFNetworking.h"
@interface MainViewController ()<CycleScrollViewDelegate>
{
    //滚动的广告图
    CycleScrollView * scrollView;
    
    //滚动字幕
    MarqueeLabel * scrollLabel;
}
@property (nonatomic,strong) NSArray * teaCategorys;
@property (nonatomic,strong) NSArray * categoryNames;
@property (nonatomic,strong) NSArray * marketNews;
@end

@implementation MainViewController
#pragma mark - Life Cycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _categoryNames = @[@"下关沱",@"合和昌",@"大益",@"广隆号",@"福村梅记",@"老同志",@"雨林",@"龙生"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(ShowContentView) name:@"ShowMainView" object:nil];
    //处理UI
    [self initUI];
    //请求数据
    [self fetchData];

    
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
    _teaCategorys = nil;
    _categoryNames = nil;
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)ShowContentView
{
    for (UIView * view in self.view.subviews) {
        if (view.tag == AddViewTag) {
            [self.view sendSubviewToBack:view];
        }
    }
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
        imageView.tag = i + 5;
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


- (void)fetchData
{
    [self getTeaCategorys:NO];
    [self getMarketNews];
    [self getLastCommodity];
}

//获取商品分类
- (void)getTeaCategorys:(BOOL)isShowHUD
{
    if (isShowHUD) {
        MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"加载中...";
    }
    [[HttpService sharedInstance] getCategory:@{@"is_system":@"1"} completionBlock:^(id object) {
        _teaCategorys = object;
        if(isShowHUD)
            [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failureBlock:^(NSError *error, NSString *responseString) {
        if(isShowHUD)
            [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

//获取市场资讯
- (void)getMarketNews
{
    [[HttpService sharedInstance] getMarketNewsWithCompletionBlock:^(id object) {
        if(object == nil || [object count] == 0)
        {
            return ;
        }
        for(int i = 0; i < [object count]; i++)
        {
            if(i == 2) break;
            UIImageView * imageView = (UIImageView *)[self.bottomAdView viewWithTag:i + 5];
            MarketNews * news = [object objectAtIndex:i];
            [imageView setImageWithURL:[NSURL URLWithString:news.image]];
            UITapGestureRecognizer * tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMarketNewsImageView:)];
            [imageView addGestureRecognizer:tapGestureRecognizer];
            tapGestureRecognizer = nil;
            imageView.userInteractionEnabled = YES;
        }
        self.marketNews = object;
        
    } failureBlock:^(NSError *error, NSString *responseString) {
        
    }];
}

//获取最新发布的商品
- (void)getLastCommodity
{
    [[HttpService sharedInstance] getCommodity:@{@"page":@"1",@"pageSize":@"3"} completionBlock:^(id object) {
        
        if(object == nil || [object count] == 0)
        {
            return ;
        }
    } failureBlock:^(NSError *error, NSString *responseString) {
        
    }];
}

-(void)gotoSearchViewController
{
    [self postNotification];
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
        viewController.view.tag = AddViewTag;
        [self addChildViewController:viewController];
        [self.view addSubview:viewController.view];
        viewController = nil;

    }
}

-(void)gotoSquareViewController
{
    [self postNotification];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowPublish" object:nil];
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
        viewController.view.tag = AddViewTag;
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
        viewController.view.tag = AddViewTag;
        [self addChildViewController:viewController];
        [self.view addSubview:viewController.view];
        viewController = nil;
        
    }
}

- (void)postNotification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HideKeyboard" object:nil];
    
}

//点击品牌图片事件
-(void)tapBrandImageAction:(UITapGestureRecognizer *)tapGesture
{
    NSLog(@"%s",__func__);
    UIImageView * imageView = (UIImageView *)tapGesture.view;
    NSLog(@"%d",imageView.tag);
    //先判断是否加载分类，如果没有加载，则重新请求
    if(_teaCategorys == nil)
    {
        MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"加载中...";
        [[HttpService sharedInstance] getCategory:@{@"is_system":@"1"} completionBlock:^(id object) {
            [hud hide:YES];
            _teaCategorys = object;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showCommodityWithTag:imageView.tag];
            });
        } failureBlock:^(NSError *error, NSString *responseString) {
            hud.labelText = @"加载失败,请重试!";
            [hud hide:YES afterDelay:2.0];
        }];
        return ;
    }
    
    [self showCommodityWithTag:imageView.tag];
//    MarkCellDetailViewController * viewController = [[MarkCellDetailViewController alloc]initWithNibName:@"MarkCellDetailViewController" bundle:nil];
//    [self.navigationController pushViewController:viewController animated:YES];
//    viewController = nil;
}

- (void)tapMarketNewsImageView:(UITapGestureRecognizer *)gesture
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
    if(_marketNews == nil || [_marketNews count] == 0) return;
    UIImageView * imageView = (UIImageView *)gesture.view;
    int index = imageView.tag - 5;
    MarketNews * news = [_marketNews objectAtIndex:index];
    [ControlCenter showMarketNewsWithNews:news];
}

- (void)showCommodityWithTag:(int)tag
{
    if(tag >= [_categoryNames count])
    {
        NSLog(@"Could not found category");
        return;
    }
    NSString * categoryName = [_categoryNames objectAtIndex:tag];
    for(TeaCategory * teaCategory in _teaCategorys)
    {
        if([teaCategory.name isEqualToString:categoryName])
        {
            [ControlCenter showTeaMarketWithCatagory:teaCategory];
            break;
        }
    }
}

#pragma  mark - CycleScrollView Delegate
- (void)cycleScrollViewDelegate:(CycleScrollView *)cycleScrollView didSelectImageView:(int)index {
    
    NSLog(@"%s",__func__);
}
@end
