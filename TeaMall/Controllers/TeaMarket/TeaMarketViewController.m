//
//  TeaMarketViewController.m
//  TeaMall
//
//  Created by Carl on 14-1-10.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "TeaMarketViewController.h"
#import "UIViewController+AKTabBarController.h"
#import "AppDelegate.h"
#import "LeftMenuViewController.h"
#import "UINavigationBar+Custom.h"
#import "TeaMarketCell.h"
#import "TeaViewController.h"
#import "Constants.h"
#import "TeaCategory.h"
#import "HttpService.h"
#import "MBProgressHUD.h"
#import "Commodity.h"
#import "GTMBase64.h"
#import "MJRefresh.h"

static NSString * cellIdentifier = @"cenIdentifier";
static NSString * cellIdentifier2 = @"cenIdentifier2";
@interface TeaMarketViewController ()<UIScrollViewDelegate,UISearchBarDelegate,UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

{
    BOOL _showStyle;   //点击导航栏rightBarButtonItem控制列表显示方式，YES显示两列
    
    UINib *_cellNib;   //记录应加载的xib文件
}


@property (nonatomic , strong) MJRefreshFooterView * refreshFooterView;
@property (nonatomic , assign) int currentPage;

@end

@implementation TeaMarketViewController



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _commodityList = [NSMutableArray array];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAllCommodity:) name:@"ShowAllCommodity" object:nil];

    }
    return self;
}

- (void)viewDidLoad
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
    [super viewDidLoad];
    
    //加载数据
    [self loadData];
    
    //初始化界面
    [self InterfaceInitailization];
    UINib *cellNib = [UINib nibWithNibName:@"TeaMarketCell" bundle:[NSBundle bundleForClass:[TeaMarketCell class]]];
    _cellNib = cellNib;
    [self.contentCollection registerNib:_cellNib forCellWithReuseIdentifier:cellIdentifier];
    
    //设置数据源与代理
    [self.contentCollection setDataSource:self];
    [self.contentCollection setDelegate:self];
    //取消滚动条
    [self.contentCollection setShowsVerticalScrollIndicator:NO];
    
    _refreshFooterView = [[MJRefreshFooterView alloc] initWithScrollView:self.contentCollection];
    __weak TeaMarketViewController * vc = self;
    _refreshFooterView.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
        [vc loadMoreData];
    };
    [self addObserver:self forKeyPath:@"year" options:NSKeyValueObservingOptionNew context:NULL];
    
}

- (void)loadData
{
    if (_keyword.length > 0 ) {
        self.currentPage = 1;     //来自搜索控制器
        _teaCategory = nil;
        _year = nil;
        NSDictionary * params = @{@"page":[NSString stringWithFormat:@"%i",self.currentPage],@"pageSize":@"15",@"keyword":_keyword,@"is_sell":@"1"};
        [self searchCommodity:params];
    }else if (self.isFromZone){
        NSDictionary * params = @{@"zone":self.zoneID,@"page":@"1",@"pageSize":@"15"};
        [self getCommoditiesWithZone:params];
    }
    else{
        [self loadAllCommodity];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
    [super viewWillAppear:animated];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - Private Methods
- (NSString *)tabImageName
{
	return @"茶叶超市-图标（黑）";
}

- (NSString *)tabTitle
{
	return nil;
}

#pragma mark 初始化界面
-(void)InterfaceInitailization
{
     //建立ui界面
    [self setupUI];
    
}

#pragma mark 建立ui界面
- (void)setupUI
{
    if (_keyword == nil) {
        self.title = @"茶叶超市";
        UIBarButtonItem * searchItem = [self customBarItem:@"分类图标" highLightImageName:@"分类图标(选中状态）" action:@selector(showLeftController:) size:CGSizeMake(60,30)];
        self.navigationItem.leftBarButtonItem = searchItem;
        searchItem  = nil;
    }
    
    //添加右边的按钮Item
    UIBarButtonItem *layoutItem = [self customBarItem:@"list_image.png" action:@selector(layoutItemClick) size:CGSizeMake(24.0, 24.0)];
    self.navigationItem.rightBarButtonItem = layoutItem;
}

#pragma mark 加载更多数据
- (void)loadMoreData
{
    
    self.currentPage += 1;
    if(_keyword != nil)
    {
        NSDictionary * params = @{@"page":[NSString stringWithFormat:@"%i",self.currentPage],@"pageSize":@"15",@"keyword":_keyword,@"is_sell":@"1"};
        [self searchCommodity:params];
    }else if (self.isFromZone){
        NSDictionary * params = @{@"zone":self.zoneID,@"page":[NSString stringWithFormat:@"%i",self.currentPage],@"pageSize":@"15"};
        [self getCommoditiesWithZone:params];
    }
    else if(_teaCategory != nil)
    {
        NSMutableDictionary * params = [NSMutableDictionary dictionary];
        [params setValue:[NSString stringWithFormat:@"%i",self.currentPage] forKey:@"page"];
        [params setValue:@"15" forKey:@"pageSize"];
        [params setValue:_teaCategory.hw_id forKey:@"cate_id"];
        if(_year != nil)
        {
            [params setValue:_year forKey:@"year"];
        }
        [self loadMoreCommodityWithParams:params];
    }
    else
    {
        [self loadMoreCommodityWithParams:@{@"page":[NSString stringWithFormat:@"%i",self.currentPage],@"pageSize":@"15"}];
    }
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if(![keyPath isEqualToString:@"year"]) return;
    self.keyword = nil;
    if(_teaCategory == nil) return;
    if(_year == nil) return;
    self.currentPage = 1;
    NSDictionary * params = @{@"page":[NSString stringWithFormat:@"%i",self.currentPage],@"pageSize":@"15",@"cate_id":_teaCategory.hw_id,@"year":_year};
    [self getCommodityWithParams:params];
}



-(void)showLeftController:(id)sender
{
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [myDelegate toggleLeftMenu:YES];

}

#pragma mark 点击右边按钮监听方法
-(void)layoutItemClick
{
    NSLog(@"come here");
    _showStyle = !_showStyle;
    
    //根据_showStyle的状态分别加载不同的xib文件
    NSString *xibStr = _showStyle?@"TeaMarketCell2":@"TeaMarketCell";
    _cellNib = [UINib nibWithNibName:xibStr bundle:[NSBundle bundleForClass:[TeaMarketCell class]]];
    [self.contentCollection registerNib:_cellNib forCellWithReuseIdentifier:cellIdentifier2];

    //刷新表格
    [self.contentCollection reloadData];
}
- (void)loadAllCommodity
{
    _teaCategory = nil;
    _year = nil;
    _keyword = nil;
    self.currentPage = 1;
    NSDictionary * params = @{@"page":[NSString stringWithFormat:@"%i",self.currentPage],@"pageSize":@"15"};
    [self getCommodityWithParams:params];
}

- (void)showAllCommodity:(NSNotification *)notification
{
    if(_commodityList != nil && [_commodityList count] != 0)
    {
        return ;
    }
    [self loadAllCommodity];
}

-(void)gotoTeaViewController:(Commodity *)commodity
{
    TeaViewController * viewController = [[TeaViewController alloc]initWithNibName:@"TeaViewController" bundle:nil];
    viewController.commodity = commodity;
    [self.navigationController pushViewController:viewController animated:YES];
    viewController = nil;
}

- (void)searchCommodityWithKeyword:(NSString *)keyword
{
    _keyword = keyword;
    _teaCategory = nil;
    _year = nil;
    self.currentPage = 1;
    NSDictionary * params = @{@"page":[NSString stringWithFormat:@"%i",self.currentPage],@"pageSize":@"15",@"keyword":_keyword};
    [self searchCommodity:params];
    
}

-(void)showCommodityByCategory:(TeaCategory * )category
{
    _year = nil;
    _keyword = nil;
    self.teaCategory = category;
    self.currentPage = 1;
    NSDictionary * params = @{@"page":[NSString stringWithFormat:@"%i",self.currentPage],@"pageSize":@"15",@"cate_id":category.hw_id};
    [self getCommodityWithParams:params];
}

- (void)getCommodityWithParams:(NSDictionary *)params
{
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"加载中...";
    [[HttpService sharedInstance] getCommodity:params completionBlock:^(id object) {
        if(object == nil || [object count] == 0)
        {
            hud.labelText = @"暂时没有商品";
            [hud hide:YES afterDelay:2];
            //return ;
        }
        else
        {
            [hud hide:YES];
            
        }
        _commodityList = object;
        
        [_contentCollection reloadData];
    } failureBlock:^(NSError *error, NSString *responseString) {
        hud.labelText = @"加载失败!";
        [hud hide:YES afterDelay:2.0];
    }];
}

- (void)loadMoreCommodityWithParams:(NSDictionary *)params
{
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[HttpService sharedInstance] getCommodity:params completionBlock:^(id object) {
        [_refreshFooterView endRefreshing];
        if(object == nil || [object count] == 0)
        {
            hud.labelText = @"没有更多商品";
            [hud hide:YES afterDelay:2];
            return ;
        }
        else
        {
            [hud hide:YES];
            
        }
        [_commodityList addObjectsFromArray:object];
        [_contentCollection reloadData];
    } failureBlock:^(NSError *error, NSString *responseString) {
        [_refreshFooterView endRefreshing];
        hud.labelText = @"加载失败!";
        [hud hide:YES afterDelay:2.0];
    }];
}

- (void)searchCommodity:(NSDictionary *)params
{
    _teaCategory = nil;
    _year = nil;
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在搜索...";
    [[HttpService sharedInstance] searchCommodity:params completionBlock:^(id object) {
        [_refreshFooterView endRefreshing];
        if(object == nil || [object count] == 0)
        {
            hud.labelText = @"暂时没有商品";
            [hud hide:YES afterDelay:2];
            //return ;
        }
        else
        {
            [hud hide:YES];
            
        }
        if(self.currentPage == 1)
        {
            [_commodityList removeAllObjects];
        }
        //self.currentPage += 1;
        [_commodityList addObjectsFromArray:object];
        [_contentCollection reloadData];
    } failureBlock:^(NSError *error, NSString *responseString) {
        [_refreshFooterView endRefreshing];
        hud.labelText = @"加载失败!";
        [hud hide:YES afterDelay:2.0];
    }];
    
}

#pragma mark -根据专区获取对应的商品
- (void)getCommoditiesWithZone:(NSDictionary *)params
{
    _teaCategory = nil;
    _year = nil;
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在加载...";
    [[HttpService sharedInstance] getGoodsByZone:params completionBlock:^(id object) {
        [_refreshFooterView endRefreshing];
        if(object == nil || [object count] == 0)
        {
            hud.labelText = @"暂时没有商品";
            [hud hide:YES afterDelay:2];
        }
        else
        {
           [hud hide:YES];
            
        }
        if(self.currentPage == 1)
        {
            [_commodityList removeAllObjects];
        }
        [_commodityList addObjectsFromArray:object];
        [_contentCollection reloadData];
    } failureBlock:^(NSError *error, NSString *responseString) {
        [_refreshFooterView endRefreshing];
        hud.labelText = @"获取商品错误";
        [hud hide:YES afterDelay:2];
    }];
}

#pragma mark collection代理放法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    NSLog(@"总数据量：%d",_commodityList.count);
    if (_showStyle) {
        return (int)((float)_commodityList.count/2 + 0.5); //四舍五入
    }
    return [_commodityList count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (_showStyle) {                        //YES的时候显示两列
        if (_commodityList.count % 2 == 0) {     //偶数
            return 2;
        }else if(section == _commodityList.count / 2){  //最后一行
            return 1;
        }else
        return 2;
    }
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TeaMarketCell * cell = nil;
    Commodity * commodity = nil;
    if (_showStyle) {  //判断当前的显示方式
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier2 forIndexPath:indexPath];
        if (indexPath.row == 0 ) {
            commodity = [_commodityList objectAtIndex:(indexPath.section * 2)];
        }else{
            commodity = [_commodityList objectAtIndex:(indexPath.section * 2 + 1)];
        }
    }else{
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
        commodity = [_commodityList objectAtIndex:indexPath.section];
    }
    [cell setCommodity:commodity];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    Commodity * commodity = [_commodityList objectAtIndex:indexPath.row];
    [self gotoTeaViewController:commodity];
}

#pragma mark -UICollectionViewLayout代理方法
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_showStyle) {
        return CGSizeMake(150, 170);
    }
    return CGSizeMake(310, 90);
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (_showStyle) {
        UIEdgeInsetsMake(5, 0, 5, 0);//单列显示的时候
    }
    return UIEdgeInsetsMake(5, 5, 5, 5);//双列显示
}

#pragma mark - UISearchBarDelegate Methods
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
    [searchBar resignFirstResponder];
    self.currentPage = 1;
    _keyword = searchBar.text;
    _teaCategory = nil;
    _year = nil;
    NSDictionary * params = @{@"page":[NSString stringWithFormat:@"%i",self.currentPage],@"pageSize":@"15",@"keyword":searchBar.text};
    [self searchCommodity:params];
    searchBar.text = @"";
}
@end
