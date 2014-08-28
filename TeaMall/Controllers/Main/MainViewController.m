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
#import "Commodity.h"
#import "SDWebImageManager.h"
#import "TeaViewController.h"
#import "Publish.h"
#import "TeaListViewController.h"
#import "Advertisement.h"
@interface MainViewController ()
{
    //滚动的广告图
    CycleScrollView * autoScrollView;
    
    //滚动字幕
    MarqueeLabel * scrollLabel;
    
    //定顶部滚动数据源
    NSArray * upperDataSource;
    NSString * identifier;
    NSString * contentIdentifier;
    
    //顶部滚动信息
    NSMutableArray * upperScrollInformationDataSource;
    
    BOOL isPlaceHolderImage;
}
@property (nonatomic,strong) NSArray * teaCategorys;
@property (nonatomic,strong) NSArray * categoryNames;
@property (nonatomic,strong) NSArray * marketNews;
@property (strong ,nonatomic) CycleScrollView * scrollView;
@property (strong ,nonatomic) NSMutableArray * autoScrollviewDataSource;
@property (strong, nonatomic) UIScrollView * branchScrollView;
@end

@implementation MainViewController
@synthesize scrollView,autoScrollviewDataSource;

#pragma mark - Life Cycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _categoryNames = @[@"下关沱",@"合和昌",@"大益",@"广隆号",@"斗记",@"中茶"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(ShowContentView) name:@"ShowMainView" object:nil];
    [_scrollContainView setContentSize:CGSizeMake(320, 455)];
    //处理UI
    [self initUI];
    //请求数据
    [self fetchData];

    //获取顶部滚动的图片
    [self getUpperScrollViewData];
    
    //获取顶部滚动的信息
    [self getScrollingInformation];

}

-(void)viewWillAppear:(BOOL)animated
{
    NSLog(@"%s",__func__);
    [autoScrollView startTimer];
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
    
    [self clearSelected];
}

-(void)getUpperScrollViewData
{
    __weak MainViewController * weakSelf = self;
    /*
    [[HttpService sharedInstance]getCommodity:@{@"page": @"1",@"pageSize":@"5"}  completionBlock:^(id object) {
        if ([object count]) {
            upperDataSource = object;
            [weakSelf downloadUpperImage];
        }
    } failureBlock:^(NSError *error, NSString *responseString) {
        ;
    }];
    */
    [[HttpService sharedInstance] getAdvertiment:@{@"type":@"2",@"page": @"1",@"pageSize":@"5"} completionBlock:^(id object) {
        upperDataSource = object;
        [weakSelf downloadUpperImage];
    } failureBlock:^(NSError *error, NSString *responseString) {
        ;
    }];
    
}


-(void)downloadUpperImage
{
     NSMutableArray * imageArray = [NSMutableArray array];
    NSInteger last = [self.autoScrollviewDataSource count] - [upperDataSource count];
    if (last >=0) {
        for (int i = [upperDataSource count]-1;i < last ; ++i) {
            UIImageView * imageView = [self.autoScrollviewDataSource objectAtIndex:i];
            [self.autoScrollviewDataSource removeObject:imageView];
        }
    }
    
    for (int i =0 ;i<[upperDataSource count];i++) {
        Advertisement * obj = [upperDataSource objectAtIndex:i];
        @autoreleasepool {
            __weak MainViewController * weakSelf = self;
            NSURL * imageURL = [NSURL URLWithString:obj.image];
            NSInteger tagNum = obj.hw_id.integerValue;
            SDWebImageManager *manager = [SDWebImageManager sharedManager];
            [manager downloadWithURL:imageURL options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                ;
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
                if (image)
                {
                    UIImageView * info = [[UIImageView alloc]initWithImage:image];
                    info.tag = tagNum;

                    NSInteger count = weakSelf.autoScrollviewDataSource.count;
                    if (i < count) {
                        [weakSelf.autoScrollviewDataSource replaceObjectAtIndex:i withObject:info];
                    }else
                    {
                        [weakSelf.autoScrollviewDataSource addObject:info];
                    }
                    
                    [self updateAutoScrollViewItem];
                }
            }];
        }
    }
}

-(void)getScrollingInformation
{
    upperScrollInformationDataSource = [NSMutableArray array];
    [[HttpService sharedInstance]getPublishList:@{@"page": @"1",@"pageSize":@"5"} completionBlock:^(id object) {
        if (object) {
            //拼接滚动信息
            [self extractUserfulInformation:object];
        }
    } failureBlock:^(NSError *error, NSString *responseString) {
        ;
    }];
}

-(void)extractUserfulInformation:(NSArray *)array
{
    NSString * scrollInformationStr = nil;
    for (Publish * object in array) {
        NSString * tempDescriptionStr = nil;
        if ([object.is_buy isEqualToString:@"1"]) {
            tempDescriptionStr = @" 我要买 ";
        }else
        {
            tempDescriptionStr = @" 我要卖 ";
        }
        
        tempDescriptionStr = [tempDescriptionStr stringByAppendingString:object.name];
        tempDescriptionStr = [tempDescriptionStr stringByAppendingString:@" , "];
        tempDescriptionStr = [tempDescriptionStr stringByAppendingString:object.batch];
        tempDescriptionStr = [tempDescriptionStr stringByAppendingString:@" , "];
        tempDescriptionStr = [tempDescriptionStr stringByAppendingFormat:@"%@%@",object.amount,object.unit];
        tempDescriptionStr = [tempDescriptionStr stringByAppendingString:@" , "];
        tempDescriptionStr = [tempDescriptionStr stringByAppendingString:object.business_number];
        tempDescriptionStr = [tempDescriptionStr stringByAppendingString:@" , "];
        tempDescriptionStr = [tempDescriptionStr stringByAppendingFormat:@"%@元",object.price];
        tempDescriptionStr = [tempDescriptionStr stringByAppendingString:@" ; "];
        
//        [upperScrollInformationDataSource addObject:tempDescriptionStr];
        if (scrollInformationStr == nil) {
            scrollInformationStr = [NSString stringWithString:tempDescriptionStr];
        }else
        {
            scrollInformationStr = [scrollInformationStr stringByAppendingString:tempDescriptionStr];
        }
    }
    scrollLabel.text = scrollInformationStr;
}


#pragma mark - Private Methods
- (NSString *)tabImageName
{
	return @"首页（黑）";
}

- (NSString *)tabTitle
{
	return nil;
}

- (void)initUI
{
    
    //[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"顶栏"] forBarMetrics:UIBarMetricsDefault];
    //self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    UIBarButtonItem * flexBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem * searchItem = [self customBarItem:@"顶三儿-搜索（黑）" highLightImageName:@"顶三儿-搜索（白）" action:@selector(gotoSearchViewController:) size:CGSizeMake(20,35)];
    UIImageView * pointImageView_1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 12, 4)];
    pointImageView_1.image = [UIImage imageNamed:@"两点"];
    UIImageView * pointImageView_2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 12, 4)];
    pointImageView_2.image = [UIImage imageNamed:@"两点副本"];
    UIBarButtonItem * pointItem_1 = [[UIBarButtonItem alloc] initWithCustomView:pointImageView_1];
    UIBarButtonItem * pointItem_2 = [[UIBarButtonItem alloc] initWithCustomView:pointImageView_2];
    UIBarButtonItem * squareItem = [self customBarItem:@"顶三儿-广场（黑）" highLightImageName:@"顶三儿-广场（白）" action:@selector(gotoSquareViewController:) size:CGSizeMake(20,35)];
    self.squareItem = squareItem;
    UIBarButtonItem * publicItem = [self customBarItem:@"顶三儿-发布（黑）" highLightImageName:@"顶三儿-发布（白）" action:@selector(gotoPublicViewController:) size:CGSizeMake(20, 35)];
    self.navigationItem.leftBarButtonItems = @[flexBarItem,searchItem,flexBarItem,pointItem_1,flexBarItem,squareItem,flexBarItem,pointItem_2,flexBarItem,publicItem,flexBarItem];

    //顶部的滚动图片
    NSArray * tempArray = @[[UIImage imageNamed:@"广告1"],[UIImage imageNamed:@"广告1"],[UIImage imageNamed:@"整桶（选中状态）"]];
    CGRect tempScrollViewRect = CGRectMake(0, 0, 320, self.adScrollBgView.frame.size.height);
    autoScrollviewDataSource = [NSMutableArray array];
    for (UIImage * image in tempArray) {
        UIImageView * tempImageView = [[UIImageView alloc]initWithImage:image];
        [tempImageView setFrame:tempScrollViewRect];
        [autoScrollviewDataSource addObject:tempImageView];
        tempImageView = nil;
    }
    
    __weak MainViewController * weakSelf = self;
    isPlaceHolderImage = YES;
    autoScrollView = [[CycleScrollView alloc] initWithFrame:tempScrollViewRect animationDuration:2];
    autoScrollView.backgroundColor = [UIColor clearColor];
    
    autoScrollView.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex){
   
        return weakSelf.autoScrollviewDataSource[pageIndex];
    };
    autoScrollView.totalPagesCount = ^NSInteger(void){
        return [weakSelf.autoScrollviewDataSource count];
    };
    autoScrollView.TapActionBlock = ^(NSInteger pageIndex){
        NSLog(@"点击了第%ld个",(long)pageIndex);
        if ([weakSelf.autoScrollviewDataSource count]) {
            UIImageView * imageView = [weakSelf.autoScrollviewDataSource objectAtIndex:pageIndex];
            
            for (Advertisement * object in upperDataSource) {
                if (object.hw_id.integerValue == imageView.tag) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:object.url]];
                }
            }
            
        }
    };

    [self.adScrollBgView addSubview:autoScrollView];
    
    /*
    //中间的品牌浏览
    NSArray * imageArrays = @[[UIImage imageNamed:@"下关沱"],[UIImage imageNamed:@"合和昌"],[UIImage imageNamed:@"大益"],[UIImage imageNamed:@"广隆号"],[UIImage imageNamed:@"斗记"],[UIImage imageNamed:@"中茶"]];
    NSUInteger iconHeight = 65;
    NSUInteger iconWidth  = 65;
    for (int i =0; i<6; i++) {
        UIImageView * imageView = [[UIImageView alloc]initWithImage:[imageArrays objectAtIndex:i]];
        imageView.userInteractionEnabled = YES;
        imageView.tag = i;
        
        //添加点击事件
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBrandImageAction:)];
        [imageView addGestureRecognizer:tap];
        tap = nil;
        
        //调整位置
        [imageView setFrame: CGRectMake(15+(iconWidth+47)*(i%3), 15+(iconHeight+10)*(i/3), iconWidth, iconHeight)];
        [self.brandView addSubview:imageView];
        imageView = nil;
    }
    self.brandView.userInteractionEnabled = YES;
    imageArrays = nil;
    */
    
    
    
    _branchScrollView = [[UIScrollView alloc] initWithFrame:_brandView.bounds];
    _branchScrollView.pagingEnabled = YES;
    _branchScrollView.showsHorizontalScrollIndicator = NO;
    _branchScrollView.showsVerticalScrollIndicator = NO;
    [_brandView addSubview:_branchScrollView];
    
    
    
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
    scrollLabel = [[MarqueeLabel alloc] initWithFrame:CGRectMake(0, 8, 320, 20) duration:25.0 andFadeLength:10.0f];
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
    
    scrollLabel.text = @"暂无信息";
}

-(void)updateAutoScrollViewItem
{
    __weak MainViewController * weakSelf = self;
    autoScrollView.totalPagesCount = ^NSInteger(void){
        return [weakSelf.autoScrollviewDataSource count];
    };
    autoScrollView.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex){
        return weakSelf.autoScrollviewDataSource[pageIndex];
    };
}

- (void)updateBranchScrollView
{
    NSUInteger iconHeight = 65;
    NSUInteger iconWidth  = 65;
    //_branchScrollView.backgroundColor = [UIColor redColor];
    int pages = ceilf([_teaCategorys count]/6.0);
    _branchScrollView.contentSize = CGSizeMake(_branchScrollView.bounds.size.width * pages, _branchScrollView.bounds.size.height);
    for(int i = 0; i < pages; i++)
    {   UIView * pageView = [UIView new];
        pageView.frame = CGRectMake(i * _branchScrollView.bounds.size.width, 0, _branchScrollView.bounds.size.width, _branchScrollView.bounds.size.height);
        [_branchScrollView addSubview:pageView];
        for(int j = 0; j < 6; j++)
        {
            int tag = j + i * 6;
            if(tag >= [_teaCategorys count]) break;
            float offx = 15+(iconWidth+47)*(j%3);
            float offy = 10+(iconHeight+10)*(j/3);
            TeaCategory * teaCategory = _teaCategorys[tag];
            UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(offx, offy, iconWidth, iconHeight)];
            imageView.userInteractionEnabled = YES;
            imageView.tag = tag;
            
            //添加点击事件
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBrandImageAction:)];
            [imageView addGestureRecognizer:tap];
            tap = nil;
            
            //调整位置
            [imageView setImageWithURL:[NSURL URLWithString:teaCategory.image]];
            [pageView addSubview:imageView];
            imageView = nil;
        }
        
    }
    
    /*
    for(int i = 0; i < [_teaCategorys count]; i++)
    {
        float offx = 15+(iconWidth+47)*(i%3);
        float offy = 10+(iconHeight+10)*(i/3);
        TeaCategory * teaCategory = _teaCategorys[i];
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(offx, offy, iconWidth, iconHeight)];
        imageView.userInteractionEnabled = YES;
        imageView.tag = i;
        
        //添加点击事件
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBrandImageAction:)];
        [imageView addGestureRecognizer:tap];
        tap = nil;
        
        //调整位置
        [imageView setImageWithURL:[NSURL URLWithString:teaCategory.image]];
        [_branchScrollView addSubview:imageView];
        imageView = nil;
    }
    */
}

-(void)viewWillDisappear:(BOOL)animated
{
     [autoScrollView stopTimer];
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
        [self updateBranchScrollView];
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
            
            UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(imageView.frame) - 21, CGRectGetWidth(imageView.frame), 21)];
            titleLabel.backgroundColor = [UIColor blackColor];
            titleLabel.alpha = 0.7;
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.textColor = [UIColor whiteColor];
            titleLabel.font = [UIFont systemFontOfSize:13];
            titleLabel.text = news.title;
            [imageView addSubview:titleLabel];
            titleLabel = nil;
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

-(void)gotoSearchViewController:(UIButton *)sender
{
    [self clearSelected];
    sender.selected = YES;
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

-(void)gotoSquareViewController:(UIButton *)sender
{
    [self clearSelected];
    sender.selected = YES;
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


-(void)gotoSquareViewControllerWithKeyword:(NSString *)keyword selectedButton:(UIButton *)sender
{
    [self clearSelected];
    sender.selected = YES;
    [self postNotification];

    NSArray * controllerArrays = self.childViewControllers;
    BOOL isShouldAddSearchViewController = YES;
    for (UIViewController * controller in controllerArrays) {
        if ([controller isKindOfClass:[SquareViewController class]]) {
            ((SquareViewController *) controller).keyword = keyword;
            isShouldAddSearchViewController = NO;
            [self.view bringSubviewToFront:controller.view];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SearchPublish" object:nil];
        }
    }
    if (isShouldAddSearchViewController) {
        SquareViewController * viewController = [[SquareViewController alloc]initWithNibName:@"SquareViewController" bundle:nil];
        viewController.keyword = keyword;
        viewController.view.tag = AddViewTag;
        [self addChildViewController:viewController];
        [self.view addSubview:viewController.view];
        viewController = nil;
        
    }
}


-(void)gotoPublicViewController:(UIButton *)sender
{
    [self clearSelected];
    sender.selected = YES;
    
    NSArray * controllerArrays = self.childViewControllers;
    BOOL isShouldAddSearchViewController = YES;
    for (UIViewController * controller in controllerArrays) {
        if ([controller isKindOfClass:[PublicViewController class]]) {
            isShouldAddSearchViewController = NO;
            [self.view bringSubviewToFront:controller.view];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowNotice" object:nil userInfo:nil];
        }
    }
    if (isShouldAddSearchViewController) {
        PublicViewController * viewController = [[PublicViewController alloc]initWithNibName:@"PublicViewController" bundle:nil];
        viewController.view.tag = AddViewTag;
        [self addChildViewController:viewController];
        [self.view addSubview:viewController.view];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowNotice" object:nil userInfo:nil];
        viewController = nil;
        
    }
}

- (void)clearSelected
{
    for(UIBarButtonItem * item in self.navigationItem.leftBarButtonItems)
    {
        if([item.customView isKindOfClass:[UIButton class]])
        {
            UIButton * btn = (UIButton *)item.customView;
            btn.selected = NO;
        }
        
    }

}

- (void)postNotification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HideKeyboard" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DismissImageView" object:nil];
    
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
    [ControlCenter showMarketNewsWithNews:news withImage:imageView.image];
}

- (void)showCommodityWithTag:(int)tag
{
    if(tag >= [_teaCategorys count])
    {
        NSLog(@"Could not found category");
        return;
    }
    /*
    NSString * categoryName = [_categoryNames objectAtIndex:tag];
    for(TeaCategory * teaCategory in _teaCategorys)
    {
        if([teaCategory.name isEqualToString:categoryName])
        {
            [ControlCenter showTeaMarketWithCatagory:teaCategory];
            break;
        }
    }
    */
    TeaCategory * teaCategory = _teaCategorys[tag];
    [ControlCenter showTeaMarketWithCatagory:teaCategory];
    
    
    //[self showAlertViewWithMessage:@"暂时还没有该品牌."];
}

#pragma  mark - CycleScrollView Delegate
- (void)cycleScrollViewDelegate:(CycleScrollView *)cycleScrollView didSelectImageView:(NSDictionary *)info {
    @autoreleasepool {
        for (Commodity * object in upperDataSource) {
            if ([object.hw_id isEqualToString:[info valueForKey:identifier]]) {
                TeaViewController * viewController = [[TeaViewController alloc]initWithNibName:@"TeaViewController" bundle:nil];
                [viewController setCommodity:object];
                [self push:viewController];
                viewController = nil;
            }
        }
    }
    
}
@end
