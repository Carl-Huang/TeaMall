//
//  TeaMarketMainController.m
//  茶叶市场的主界面
//
//  Created by Carl_Huang on 14-8-26.
//  Copyright (c) 2014年 HelloWorld. All rights reserved.
//  茶叶超市主界面demo

//头部背景
#define kHeaderViewBg kColor(232, 233, 232)
#define kHeaderTextBg kColor(44,18,12)


#import "TeaMarketMainController.h"
#import "TeaMarketMainCell.h"
#import "TeaMarketSearchController.h"
#import "TeaMarketViewController.h"
#import "HttpService.h"
#import "CommodityZone.h"
#import "MBProgressHUD.h"
#import "Commodity.h"
#import "TeaViewController.h"

@interface TeaMarketMainController () <TeaMarketMainCellDelegate>

{
    NSMutableArray * _zoneList;
}

@end

@implementation TeaMarketMainController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //初始化数组
    _zoneList = [NSMutableArray array];
    //初始化UI
    [self buildUI];
    //加载数据
    [self loadData];
    
}

#pragma mark 初始化UI
- (void)buildUI
{
    //导航栏标题
    self.title = @"茶叶超市";
    //添加右边的按钮Item
    UIBarButtonItem *searchItem = [self customBarItem:@"search.png" action:@selector(searchItemClick) size:CGSizeMake(24.0, 24.0)];
    self.navigationItem.rightBarButtonItem = searchItem;
    
    //取消tableView滚动条
    self.tableView.showsVerticalScrollIndicator = NO;
}

#pragma mark 加载网络数据
- (void)loadData
{
    NSDictionary *params = @{@"page":@"1",
                             @"pageSize":@"5",
                             @"goodsSize":@"5"
                             };
    [self getCommodityWithParams:params];
}

- (NSString *)tabImageName
{
	return @"茶叶超市-图标（黑）";
}

- (NSString *)tabTitle
{
	return nil;
}


#pragma mark 搜索按钮监听放法，显示搜索控制器
 - (void)searchItemClick
{
    NSLog(@"来搜索");
    TeaMarketSearchController *search = [[TeaMarketSearchController alloc] init];
    [self.navigationController pushViewController:search animated:YES];
}

#pragma mark - Table view 数据源方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _zoneList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    TeaMarketMainCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[TeaMarketMainCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        [cell setDelegate:self];
    }
    
    CommodityZone *zone = _zoneList[indexPath.section];
    cell.zone = zone;
    cell.indexPath = indexPath;//告诉cell自己所在的indexPath
    
    return cell;
}



#pragma mark -返回每组头部视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    static NSString *HeaderID = @"myHeader";
    UILabel *myHeader = [tableView dequeueReusableHeaderFooterViewWithIdentifier:HeaderID];
    
    if (myHeader == nil) {
        myHeader = [[UILabel alloc]init];
        myHeader.backgroundColor = kHeaderViewBg;
        myHeader.textColor = kHeaderTextBg;
    }
    
    CommodityZone *zone = _zoneList[section];
    NSString *str = [NSString stringWithFormat:@"   -%@",zone.name];
    myHeader.text = str;
    
    return myHeader;
}

#pragma mark -返回每个cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.tableView.bounds.size.width;
}

#pragma mark -返回每个section头部的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44.0;
}

#pragma mark cell的代理方法
- (void)TeaMarketMainCellDidSelectedWithTag:(NSInteger)tag indexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"点击了第%d行,第%d按钮",indexPath.section,tag);
    CommodityZone *zone = _zoneList[indexPath.section];//取出专区模型
    NSLog(@"有%d个商品",zone.goods_list.count);
#warning 根据专区获取商品列表
    if (tag == 0) {//说明点了第一个的那个大图片
        TeaMarketViewController *vc = [[TeaMarketViewController alloc] init];
        vc.isFromZone = YES;
        vc.zoneID = zone.hw_id;
        [self push:vc];
    }
    if (tag - 1 <= zone.goods_list.count - 1) {   //因为第一个大的imageView是用来存专区的，因此tag-1
        
        Commodity *commdity = zone.goods_list[tag - 1];  //取出商品模型
        //控制器跳转
        TeaViewController *vc = [[TeaViewController alloc] init];
        vc.commodity = commdity;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark 网络请求
- (void)getCommodityWithParams:(NSDictionary *)params
{
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"加载中...";
    [[HttpService sharedInstance] getZone:params completionBlock:^(id object) {
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
        _zoneList = object;
        
        NSLog(@"%@",_zoneList);
        
        [self.tableView reloadData];
        
    } failureBlock:^(NSError *error, NSString *responseString) {
        hud.labelText = @"加载失败!";
        [hud hide:YES afterDelay:2.0];
    }];
}

@end
