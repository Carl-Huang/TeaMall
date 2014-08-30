//
//  TeaListViewController.m
//  TeaMall
//
//  Created by Carl on 14-3-5.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "TeaListViewController.h"
#import "UINavigationBar+Custom.h"
#import "TeaMarketCell.h"
#import "Constants.h"
#import "TeaCategory.h"
#import "HttpService.h"
#import "MBProgressHUD.h"
#import "Commodity.h"
#import "GTMBase64.h"
#import "UIImageView+AFNetworking.h"
#import "MJRefresh.h"
#import "MarkCellDetailViewController.h"
#import "AppDelegate.h"
static NSString * cellIdentifier = @"cenIdentifier";
@interface TeaListViewController ()
@property (nonatomic , strong) NSMutableArray * commodityList;
@property (nonatomic, strong) MJRefreshFooterView * refreshFooterView;
@property (nonatomic , assign) int currentPage;
@end

@implementation TeaListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _commodityList = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //[self setLeftCustomBarItem:@"返回" action:nil];
    UIBarButtonItem * searchItem = [self customBarItem:@"分类图标" highLightImageName:@"分类图标(选中状态）" action:@selector(showLeftController:) size:CGSizeMake(60,30)];
    self.navigationItem.leftBarButtonItem = searchItem;
    UINib *cellNib = [UINib nibWithNibName:@"TeaMarketCell" bundle:[NSBundle bundleForClass:[TeaMarketCell class]]];
    [self.contentTable registerNib:cellNib forCellReuseIdentifier:cellIdentifier];
    _refreshFooterView = [[MJRefreshFooterView alloc] initWithScrollView:self.contentTable];
    __weak TeaListViewController * vc = self;
    _refreshFooterView.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
        [vc loadMoreData];
    };
    
    if(_keyword)
    {
        [self searchCommodity];
    }
    else
    {
        [self showCommodityByCategory];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"view will appear");
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)showLeftController:(id)sender
{
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [myDelegate toggleLeftMenu:NO];
}

-(void)showCommodityByCategory
{

    //self.teaCategory = category;
    self.currentPage = 1;
    NSDictionary * params = @{@"page":[NSString stringWithFormat:@"%i",self.currentPage],@"pageSize":@"15",@"cate_id":_teaCategory.hw_id,@"is_sell":@"0"};
    [self getCommodityWithParams:params];
}

- (void)showCommodityByCategoryAndYear
{
    self.currentPage = 1;
    NSDictionary * params = @{@"page":[NSString stringWithFormat:@"%i",self.currentPage],@"pageSize":@"15",@"cate_id":_teaCategory.hw_id,@"is_sell":@"0",@"year":_year};
    [self getCommodityWithParams:params];

}


- (void)getCommodityWithParams:(NSDictionary *)params
{
    _keyword = nil;
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
        [_contentTable reloadData];
    } failureBlock:^(NSError *error, NSString *responseString) {
        hud.labelText = @"加载失败!";
        [hud hide:YES afterDelay:2.0];
    }];
}

- (void)searchCommodity
{
    self.currentPage = 1;
    NSDictionary * params = @{@"page":[NSString stringWithFormat:@"%i",self.currentPage],@"pageSize":@"15",@"keyword":_keyword,@"is_sell":@"0"};
    [self searchCommodity:params];
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
        self.currentPage += 1;
        [_commodityList addObjectsFromArray:object];
        [_contentTable reloadData];
    } failureBlock:^(NSError *error, NSString *responseString) {
        [_refreshFooterView endRefreshing];
        hud.labelText = @"加载失败!";
        [hud hide:YES afterDelay:2.0];
    }];
    
}



- (void)loadMoreData
{
    /*
    self.currentPage += 1;
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params setValue:[NSString stringWithFormat:@"%i",self.currentPage] forKey:@"page"];
    [params setValue:@"15" forKey:@"pageSize"];
    [params setValue:_teaCategory.hw_id forKey:@"cate_id"];
    [params setValue:@"0" forKey:@"is_sell"];
    [self loadMoreCommodityWithParams:params];
    */
    self.currentPage += 1;
    if(_keyword != nil)
    {
        NSDictionary * params = @{@"page":[NSString stringWithFormat:@"%i",self.currentPage],@"pageSize":@"15",@"keyword":_keyword,@"is_sell":@"0"};
        [self searchCommodity:params];
    }
    else if(_teaCategory != nil)
    {
        NSMutableDictionary * params = [NSMutableDictionary dictionary];
        [params setValue:[NSString stringWithFormat:@"%i",self.currentPage] forKey:@"page"];
        [params setValue:@"15" forKey:@"pageSize"];
        [params setValue:_teaCategory.hw_id forKey:@"cate_id"];
        [params setValue:@"0" forKey:@"is_sell"];
        if(_year != nil)
        {
            [params setValue:_year forKey:@"year"];
        }
        [self loadMoreCommodityWithParams:params];
    }
    

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
        [_contentTable reloadData];
    } failureBlock:^(NSError *error, NSString *responseString) {
        [_refreshFooterView endRefreshing];
        hud.labelText = @"加载失败!";
        [hud hide:YES afterDelay:2.0];
    }];
}

#pragma mark - UITableViewDataSource Methods
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_commodityList count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TeaMarketCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    //cell.teaImage.image = [UIImage imageNamed:@"关闭交易（选中状态）"];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    Commodity * commodity = [_commodityList objectAtIndex:indexPath.row];
    cell.teaWeight.text = [NSString stringWithFormat:@"%@g",commodity.weight];
    cell.teaName.text = commodity.name;
    cell.currentPrice.text = [NSString stringWithFormat:@"￥%@",commodity.hw__price];
    cell.originalPrice.text = [NSString stringWithFormat:@"￥%@",commodity.price];
    cell.originalPrice.hidden = YES;
    cell.seperateLine.hidden = YES;
    [cell.teaImage setImageWithURL:[NSURL URLWithString:commodity.image] placeholderImage:[UIImage imageNamed:@"关闭交易（选中状态）"]];
    //计算百分比
    float originPrice = [commodity.price floatValue];
    float currentPrice = [commodity.hw__price floatValue];
    float percent = 0;
    if(originPrice == 0.0)
    {
        percent = 0.1;
    }
    else
    {
        percent = (abs(originPrice - currentPrice)/originPrice) * 100;
    }
    
    cell.percentLabel.text = [NSString stringWithFormat:@"%0.1f%@",percent,@"%"];
    if(currentPrice >= originPrice)
    {
        cell.arrowImageView.image = [UIImage imageNamed:@"升价小图标"];
        //cell.teaWeight.text = [NSString stringWithFormat:@"涨￥%i",abs([commodity.hw__price intValue] - [commodity.price intValue])];
    }
    else
    {
        cell.arrowImageView.image = [UIImage imageNamed:@"降价小图标"];
        //cell.teaWeight.text = [NSString stringWithFormat:@"跌￥%i",abs([commodity.hw__price intValue] - [commodity.price intValue])];
    }
    cell.arrowImageView.hidden = NO;
    cell.percentLabel.hidden = NO;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MarkCellDetailViewController * vc = [[MarkCellDetailViewController alloc] initWithNibName:nil bundle:nil];
    Commodity * commodity = [_commodityList objectAtIndex:indexPath.row];
    vc.commodity = commodity;
    [self push:vc];
    vc = nil;
}

@end
