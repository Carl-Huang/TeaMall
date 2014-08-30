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
#import "UIImageView+AFNetworking.h"
#import "MJRefresh.h"

static NSString * cellIdentifier = @"cenIdentifier";
static NSString * cellIdentifier2 = @"cenIdentifier2";
@interface TeaMarketViewController ()<UIScrollViewDelegate,UISearchBarDelegate,UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

{
    BOOL _showStyle;   //点击导航栏rightBarButtonItem控制列表显示方式，YES显示两列
    
    UINib *_cellNib;   //记录应加载的xib文件
}

@property (nonatomic , strong) NSMutableArray * commodityList;
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
    
    self.title = @"茶叶超市";
    [self InterfaceInitailization];
    UINib *cellNib = [UINib nibWithNibName:@"TeaMarketCell" bundle:[NSBundle bundleForClass:[TeaMarketCell class]]];
    _cellNib = cellNib;
    [self.contentCollection registerNib:_cellNib forCellWithReuseIdentifier:cellIdentifier];
    //[self.contentCollection registerNib:cellNib forCellReuseIdentifier:cellIdentifier];
    
    //设置数据源与代理
    [self.contentCollection setDataSource:self];
    [self.contentCollection setDelegate:self];
    //取消滚动条
    [self.contentCollection setShowsVerticalScrollIndicator:NO];
//    [self.contentCollection setBackgroundColor:[UIColor orangeColor]];

#warning 搜索栏
//    if(![OSHelper iOS7])
//    {
//        _searchBar.backgroundColor = [UIColor clearColor];
//        _searchBar.tintColor = [UIColor colorWithRed:183.0f/255.0f green:183.0/255.0 blue:183.0/255.0 alpha:1.0];
//        //[[_searchBar.subviews objectAtIndex:0] removeFromSuperview];
//    }
//    _searchBar.placeholder = @"请输入关键字";
//
    
//    CGRect tableRect = self.contentCollection.frame;
//    NSLog(@"%f",tableRect.size.height);
//    if([OSHelper iPhone5])
//    {
//        tableRect.size.height =  tableRect.size.height;
//    }
//    else
//    {
//        tableRect.size.height = tableRect.size.height;
//    }
//    [self.contentCollection setFrame:tableRect];
    
    _refreshFooterView = [[MJRefreshFooterView alloc] initWithScrollView:self.contentCollection];
    __weak TeaMarketViewController * vc = self;
    _refreshFooterView.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
        [vc loadMoreData];
    };
    [self addObserver:self forKeyPath:@"year" options:NSKeyValueObservingOptionNew context:NULL];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
    [super viewWillAppear:animated];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

-(void)InterfaceInitailization
{

    //[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"顶栏"] forBarMetrics:UIBarMetricsDefault];
    
    UIBarButtonItem * searchItem = [self customBarItem:@"分类图标" highLightImageName:@"分类图标(选中状态）" action:@selector(showLeftController:) size:CGSizeMake(60,30)];
    
    self.navigationItem.leftBarButtonItem = searchItem;
    searchItem  = nil;
    
    //添加右边的按钮Item
    UIBarButtonItem *layoutItem = [[UIBarButtonItem alloc] initWithTitle:@"点我" style:UIBarButtonItemStyleBordered target:self action:@selector(layoutItemClick)];
    self.navigationItem.rightBarButtonItem = layoutItem;
}

- (void)loadMoreData
{
    
    self.currentPage += 1;
    if(_keyword != nil)
    {
        NSDictionary * params = @{@"page":[NSString stringWithFormat:@"%i",self.currentPage],@"pageSize":@"15",@"keyword":_keyword,@"is_sell":@"1"};
        [self searchCommodity:params];
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
//    [_searchBar resignFirstResponder];
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [myDelegate toggleLeftMenu:YES];

}

#pragma mark 点击右边按钮监听方法
-(void)layoutItemClick
{
    NSLog(@"come here");
    NSLog(@"%@",NSStringFromCGRect(self.contentCollection.frame));
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

//- (IBAction)tapTableView:(id)sender
//{
//    [_searchBar resignFirstResponder];
//
//}

//- (IBAction)sureAction:(id)sender
//{
//    [_searchBar resignFirstResponder];
//    if([_searchBar.text length] == 0)
//    {
//        return ;
//    }
//    
//    self.currentPage = 1;
//    _keyword = _searchBar.text;
//    _teaCategory = nil;
//    _year = nil;
//    NSDictionary * params = @{@"page":[NSString stringWithFormat:@"%i",self.currentPage],@"pageSize":@"15",@"keyword":_searchBar.text,@"is_sell":@"1"};
//    [self searchCommodity:params];
//    _searchBar.text = @"";
//
//}

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

/*
#pragma mark - UITableViewDataSource Methods
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
*/
/*
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_commodityList count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TeaMarketCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    //cell.teaImage.image = [UIImage imageNamed:@"关闭交易（选中状态）"];
#warning 得这里没必要再设置（以下这行）
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    Commodity * commodity = [_commodityList objectAtIndex:indexPath.row];
    cell.teaWeight.text = [NSString stringWithFormat:@"%@g",commodity.weight];
    cell.teaName.text = commodity.name;
    cell.currentPrice.text = [NSString stringWithFormat:@"￥%@",commodity.hw__price];
    cell.originalPrice.text = [NSString stringWithFormat:@"￥%@",commodity.price];
    [cell.teaImage setImageWithURL:[NSURL URLWithString:commodity.image] placeholderImage:[UIImage imageNamed:@"关闭交易（选中状态）"]];
    return cell;
}
 */

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
    if (_showStyle) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier2 forIndexPath:indexPath];
    }else{
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    }
    
    //cell.teaImage.image = [UIImage imageNamed:@"关闭交易（选中状态）"];

    Commodity * commodity = [_commodityList objectAtIndex:indexPath.row];
    cell.teaWeight.text = [NSString stringWithFormat:@"%@g",commodity.weight];
//#warning 临时数据测试
//    cell.teaWeight.text = [NSString stringWithFormat:@"%d行",indexPath.section];
    cell.teaName.text = commodity.name;
    cell.currentPrice.text = [NSString stringWithFormat:@"￥%@",commodity.hw__price];
    cell.originalPrice.text = [NSString stringWithFormat:@"￥%@",commodity.price];
    [cell.teaImage setImageWithURL:[NSURL URLWithString:commodity.image] placeholderImage:[UIImage imageNamed:@"关闭交易（选中状态）"]];
    
//    cell.backgroundColor = [UIColor lightGrayColor];
    
    return cell;
}

/*
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_searchBar resignFirstResponder];
    Commodity * commodity = [_commodityList objectAtIndex:indexPath.row];
    [self gotoTeaViewController:commodity];
}
*/

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    [_searchBar resignFirstResponder];
    Commodity * commodity = [_commodityList objectAtIndex:indexPath.row];
    [self gotoTeaViewController:commodity];
}

#pragma mark -UICollectionViewLayout代理方法
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_showStyle) {
        return CGSizeMake(150, 170);
    }
    return CGSizeMake(320, 90);
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
//    if (_showStyle) {
//        UIEdgeInsetsMake(5, 5, 5, 5);//单列显示的时候
//    }
    return UIEdgeInsetsMake(5, 5, 5, 5);//双列显示
}

//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
//{
//    return 10.0;
//}
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
//{
//    return 10.0;
//}


//#pragma mark - UIScrollViewDelegate Methods
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
//{
//    [_searchBar resignFirstResponder];
//}


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
