//
//  MarketViewController.m
//  TeaMall
//
//  Created by vedon on 13/1/14.
//  Copyright (c) 2014 helloworld. All rights reserved.
//

#import "MarketViewController.h"
#import "UIViewController+AKTabBarController.h"
#import "MarketCell.h"
#import "MarkCellDetailViewController.h"
#import "UINavigationBar+Custom.h"
#import "MBProgressHUD.h"
#import "HttpService.h"
#import "Commodity.h"
#import "UIImageView+AFNetworking.h"
#import "MJRefresh.h"
#import "CustomiseServiceViewController.h"
#import "User.h"
#import "PersistentStore.h"
#import "ProductCollection.h"
#import "HttpService.h"

static NSString * cellIdentifier = @"cellIdentifier";
@interface MarketViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger cellHeight;
    MJRefreshFooterView * refreshFooterView;
}
@property (nonatomic,strong) NSString * commodityType;
@property (nonatomic,strong) NSString * currentPage;
@property (nonatomic,strong) NSMutableArray * commodityList;
@end

@implementation MarketViewController

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
    self.title = @"市场行情";
    CGRect rect = self.contentTable.frame;
    if(![OSHelper iPhone5])
    {
        rect.size.height = 316;
        [self.contentTable setFrame:rect];
    }
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"顶三儿-底板"]];
    
    [self.priceDownBtn addTarget:self action:@selector(priceDownAction) forControlEvents:UIControlEventTouchUpInside];
    [self.priceUpBtn addTarget:self action:@selector(priceUpAction) forControlEvents:UIControlEventTouchUpInside];
    
    UINib *cellNib = [UINib nibWithNibName:@"MarketCell" bundle:[NSBundle  bundleForClass:[MarketCell class]]];
    [self.contentTable registerNib:cellNib forCellReuseIdentifier:cellIdentifier];
    
    MarketCell * cell = [[[NSBundle mainBundle]loadNibNamed:@"MarketCell" owner:self options:nil]objectAtIndex:0];
    cellHeight = cell.frame.size.height;
    cell = nil;
    
    [self.priceUpBtn setSelected:YES];
    self.commodityType = @"1";
    
    [self addObserver:self forKeyPath:@"type" options:NSKeyValueObservingOptionNew context:nil];
    //上拉加载更多
    __weak MarketViewController * vc = self;
    refreshFooterView = [[MJRefreshFooterView alloc] initWithScrollView:self.contentTable];
    refreshFooterView.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
    
        [vc loadMoreData];
    };
    
    [self initData];
}


- (void)addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context
{
    if(![keyPath isEqualToString:@"type"]) return;
    if([_type isEqualToString:@"1"])
    {
        [self priceUpAction];
    }
    else if([_type isEqualToString:@"0"])
    {
        [self priceDownAction];
    }
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

-(void)priceDownAction
{
    NSLog(@"%s",__func__);
    [self.priceDownBtn setSelected:YES];
    [self.priceUpBtn setSelected:NO];
    self.commodityType = @"0";
    [self initData];
    
}

-(void)priceUpAction
{
    NSLog(@"%s",__func__);
    [self.priceUpBtn setSelected:YES];
    [self.priceDownBtn setSelected:NO];
    self.commodityType = @"1";
    [self initData];
}


- (void)initData
{
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.currentPage = @"1";
    hud.labelText = @"加载中...";
    [[HttpService sharedInstance] getMarketCommodity:@{@"type":self.commodityType,@"page":self.currentPage,@"pageSize":@"15"} completionBlock:^(id object) {
        if(object == nil || [object count] == 0)
        {
            if([self.commodityType isEqualToString:@"1"])
            {
                hud.labelText = @"暂时没有升价商品";
            }
            else
            {
                hud.labelText = @"暂时没有降价商品";
            }
            [hud hide:YES afterDelay:1.5];
            //return ;
        }
        else
        {
            [hud hide:YES];
        }
        
        
        _commodityList = object;
        [_contentTable reloadData];
        
    } failureBlock:^(NSError *error, NSString *responseString) {
        hud.labelText = @"加载失败";
        [hud hide:YES afterDelay:1.5];
        
    }];
}


- (void)loadMoreData
{
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    int page = [self.currentPage integerValue] + 1;
    self.currentPage = [NSString stringWithFormat:@"%i",page];
    hud.labelText = @"加载中...";
    [[HttpService sharedInstance] getMarketCommodity:@{@"type":self.commodityType,@"page":self.currentPage,@"pageSize":@"15"} completionBlock:^(id object) {
        [refreshFooterView endRefreshing];
        if(object == nil || [object count] == 0)
        {
            hud.labelText = @"暂时没有商品";
            [hud hide:YES afterDelay:1.5];
            return ;
        }
        [hud hide:YES];
        
        [_commodityList addObjectsFromArray:object];
        [_contentTable reloadData];
        

    } failureBlock:^(NSError *error, NSString *responseString) {
        hud.labelText = @"加载失败";
        [hud hide:YES afterDelay:1.5];
        [refreshFooterView endRefreshing];
    }];
    
}
#pragma mark - Private Methods

- (NSString *)tabImageName
{
	return @"市场行情-图标（黑）";
}

- (NSString *)tabTitle
{
	return nil;
}

- (void)callAction:(UIButton *)button
{
    CustomiseServiceViewController * vc = [[CustomiseServiceViewController alloc] initWithNibName:nil bundle:nil];
    [self push:vc];
    vc = nil;
}

-(void)addToFavorite:(id)sender
{
    User * user = [User userFromLocal];
    UIButton * btn = (UIButton *)sender;
    Commodity * commodity = [_commodityList objectAtIndex:btn.tag];
    if (user) {
        NSLog(@"%s",__func__);
        NSArray * collections = [PersistentStore getAllObjectWithType:[ProductCollection class]];
        BOOL isShouldAdd = YES;
        for (ProductCollection * obj in collections) {
            if ([obj.collectionID isEqualToString:commodity.hw_id]) {
                isShouldAdd = NO;
                break;
            }
        }
        
        if (isShouldAdd) {
            MBProgressHUD * hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hub.labelText = @"添加收藏";
            __weak MarketViewController * weakSelf = self;
            [[HttpService sharedInstance]addCollection:@{@"user_id":user.hw_id,@"collection_id":commodity.hw_id,@"type":@"1"} completionBlock:^(id object) {
                
                hub.mode = MBProgressHUDModeText;
                hub.labelText = object;
                [weakSelf saveToLocalWithObject:commodity];
                [hub hide:YES afterDelay:1];
                
            } failureBlock:^(NSError *error, NSString *responseString) {
                hub.mode = MBProgressHUDModeText;
                hub.labelText = @"添加失败";
                [hub hide:YES afterDelay:1];
            }];
        }else
        {
            //已经保存
            [self showAlertViewWithMessage:@"已经收藏"];
        }
        
    }else
    {
        //请登录
        [self showAlertViewWithMessage:@"请登录"];
    }
}

-(void)saveToLocalWithObject:(Commodity *)object
{
    ProductCollection * collection = [ProductCollection MR_createEntity];
    collection.collectionID = object.hw_id;
    [[NSManagedObjectContext MR_defaultContext]MR_saveOnlySelfAndWait];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_commodityList count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return cellHeight;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MarketCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    Commodity * commodity = [_commodityList objectAtIndex:indexPath.row];
    cell.nameLabel.text = commodity.name;
    cell.currentPriceLabel.text = [NSString stringWithFormat:@"现价:￥%@",commodity.hw__price];
    cell.originPriceLabel.text = [NSString stringWithFormat:@"￥%@",commodity.price];
    cell.weightLabel.text = [NSString stringWithFormat:@"%@g",commodity.weight];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if([self.commodityType isEqualToString:@"1"])
    {
        cell.arrowImageView.image = [UIImage imageNamed:@"升价小图标"];
    }
    else
    {
        cell.arrowImageView.image = [UIImage imageNamed:@"降价小图标"];
    }
    cell.addCollectionButton.tag = indexPath.row;
    [cell.callButton addTarget:self action:@selector(callAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.addCollectionButton addTarget:self action:@selector(addToFavorite:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.teaImageView setImageWithURL:[NSURL URLWithString:commodity.image] placeholderImage:[UIImage imageNamed:@"关闭交易（选中状态）"]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Commodity * commodity = [_commodityList objectAtIndex:indexPath.row];
    MarkCellDetailViewController * viewController = [[MarkCellDetailViewController alloc]initWithNibName:@"MarkCellDetailViewController" bundle:nil];
    viewController.commodity = commodity;
    [self.navigationController pushViewController:viewController animated:YES];
    viewController = nil;
     
}

@end
