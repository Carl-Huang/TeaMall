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
static NSString * cellIdentifier = @"cenIdentifier";
@interface TeaMarketViewController ()
@property (nonatomic , strong) NSMutableArray * commodityList;
@property (nonatomic , assign) int currentPage;
@end

@implementation TeaMarketViewController

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
    NSLog(@"%@",NSStringFromSelector(_cmd));
    [super viewDidLoad];

    self.title = @"茶叶超市";
    [self InterfaceInitailization];
    UINib *cellNib = [UINib nibWithNibName:@"TeaMarketCell" bundle:[NSBundle bundleForClass:[TeaMarketCell class]]];
    [self.contentTable registerNib:cellNib forCellReuseIdentifier:cellIdentifier];
    // Do any additional setup after loading the view from its nib.
    
    [self addObserver:self forKeyPath:@"year" options:NSKeyValueObservingOptionNew context:NULL];
    
//    UIImage * testImage = [UIImage imageNamed:@"茶叶超市-图标（黑）"];
//    if(testImage)
//    {
//        NSData * data = UIImagePNGRepresentation(testImage);
//        NSString * base64String = [GTMBase64 encodeBase64Data:data];
//        NSLog(@"base64:%@",base64String);
//    }
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

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
    [super viewWillAppear:animated];
    if(_commodityList == nil || _teaCategory == nil)
    {
        self.currentPage = 1;
        NSDictionary * params = @{@"page":[NSString stringWithFormat:@"%i",self.currentPage],@"pageSize":@"15"};
        [self getCommodityWithParams:params];
    }
}


-(void)InterfaceInitailization
{
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"顶三儿-底板"]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"顶三儿-底板"] forBarMetrics:UIBarMetricsDefault];
    
    UIBarButtonItem * searchItem = [self customBarItem:@"分类图标" highLightImageName:@"分类图标(选中状态）" action:@selector(showLeftController:) size:CGSizeMake(60,30)];

    self.navigationItem.leftBarButtonItem = searchItem;
    searchItem  = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)tabImageName
{
	return @"茶叶超市-图标（黑）";
}

- (NSString *)tabTitle
{
	return nil;
}

-(void)showLeftController:(id)sender
{
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [myDelegate toggleLeftMenu];

}

-(void)gotoTeaViewController:(Commodity *)commodity
{
    TeaViewController * viewController = [[TeaViewController alloc]initWithNibName:@"TeaViewController" bundle:nil];
    viewController.commodity = commodity;
    [self.navigationController pushViewController:viewController animated:YES];
    viewController = nil;
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
        [_contentTable reloadData];
    } failureBlock:^(NSError *error, NSString *responseString) {
        hud.labelText = @"加载失败!";
        [hud hide:YES afterDelay:2.0];
    }];
}
#pragma mark -
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    Commodity * commodity = [_commodityList objectAtIndex:indexPath.row];
    cell.teaWeight.text = [NSString stringWithFormat:@"%@g",commodity.weight];
    cell.teaName.text = commodity.name;
    cell.currentPrice.text = [NSString stringWithFormat:@"￥%@",commodity.hw__price];
    cell.originalPrice.text = [NSString stringWithFormat:@"￥%@",commodity.price];
    [cell.teaImage setImageWithURL:[NSURL URLWithString:commodity.image] placeholderImage:[UIImage imageNamed:@"关闭交易（选中状态）"]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Commodity * commodity = [_commodityList objectAtIndex:indexPath.row];
    [self gotoTeaViewController:commodity];
}
@end
