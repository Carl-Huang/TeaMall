//
//  TeaMarketMainController.m
//  茶叶市场的主界面
//
//  Created by Carl_Huang on 14-8-26.
//  Copyright (c) 2014年 HelloWorld. All rights reserved.
//  茶叶超市主界面demo

#import "TeaMarketMainController.h"
#import "TeaMarketMainCell.h"
#import "TeaMarketSearchController.h"
#import "TeaMarketViewController.h"
#import "HttpService.h"
#import "CommodityZone.h"
#import "MBProgressHUD.h"

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
    
    //导航栏标题
    self.title = @"茶叶超市";
    //添加右边的按钮Item
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithTitle:@"搜索" style:UIBarButtonItemStyleBordered target:self action:@selector(searchItemClick)];
    self.navigationItem.rightBarButtonItem = searchItem;
    
    NSLog(@"self.view%@",self.tableView);
    [self loadData];
    
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
//    [self presentViewController:search animated:YES completion:nil];
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
        //取消cell的选中样式
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setDelegate:self];
    }
    
    CommodityZone *zone = _zoneList[indexPath.section];
    cell.zone = zone;
    
    return cell;
}



#pragma mark -返回每组头部视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    static NSString *HeaderID = @"myHeader";
    UILabel *myHeader = [tableView dequeueReusableHeaderFooterViewWithIdentifier:HeaderID];
    
    if (myHeader == nil) {
        myHeader = [[UILabel alloc]init];
        myHeader.backgroundColor = [UIColor purpleColor];
        myHeader.textColor = [UIColor brownColor];
    }
    
    CommodityZone *zone = _zoneList[section];
    myHeader.text = zone.name;
    
    return myHeader;
}

#pragma mark -返回每个cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.tableView.bounds.size.width;
}

#pragma mark cell的代理方法
- (void)TeaMarketMainCell:(TeaMarketMainCell *)teaMarketMainCell didSelectedWithTag:(NSInteger)tag
{
    NSLog(@"点击了第%d按钮",tag);
//    [self.navigationController pushViewController:[[TeaMarketViewController alloc] init] animated:YES];
    
    
//    [[HttpService sharedInstance] post:@"http://115.29.248.57:8080/admin/api/get_zone_with_goods" withParams:params completionBlock:^(id obj) {
//        
//        NSArray *result = obj;
//        
//        NSLog(@"%@",result);
//        
//    } failureBlock:^(NSError *error, NSString *responseString) {
//        NSLog(@"请求失败");
//    }];
//    [[HttpService sharedInstance] getCommodity:params completionBlock:^(id object) {
//        _zoneList = object;
//        [self.tableView reloadData];
//        
//    } failureBlock:^(NSError *error, NSString *responseString) {
//        NSLog(@"%@%@",error,responseString);
//    }];
    
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
