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
#import "PopupTagViewController.h"
#import "AppDelegate.h"
#import "TeaCategory.h"
#import "ControlCenter.h"
static NSString * cellIdentifier = @"cellIdentifier";
@interface MarketViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger cellHeight;
    MJRefreshFooterView * refreshFooterView;
    PopupTagViewController * popupTagViewController;
}
//@property (nonatomic,strong) NSString * type;
@property (nonatomic,strong) NSString * currentPage;
@property (nonatomic,strong) NSMutableArray * commodityList;
@property (nonatomic,strong) TeaCategory * selectedCategory;
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
    //[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"顶栏"]];
    UIBarButtonItem * searchItem = [self customBarItem:@"分类图标" highLightImageName:@"分类图标(选中状态）" action:@selector(showBranch:) size:CGSizeMake(60,30)];
    self.navigationItem.leftBarButtonItem = searchItem;
    
    [self.priceDownBtn addTarget:self action:@selector(priceDownAction) forControlEvents:UIControlEventTouchUpInside];
    [self.priceUpBtn addTarget:self action:@selector(priceUpAction) forControlEvents:UIControlEventTouchUpInside];
    
    UINib *cellNib = [UINib nibWithNibName:@"MarketCell" bundle:[NSBundle  bundleForClass:[MarketCell class]]];
    [self.contentTable registerNib:cellNib forCellReuseIdentifier:cellIdentifier];
    
    MarketCell * cell = [[[NSBundle mainBundle]loadNibNamed:@"MarketCell" owner:self options:nil]objectAtIndex:0];
    cellHeight = cell.frame.size.height;
    cell = nil;
    
    if([_type isEqualToString:@"0"])
    {
        [self.priceDownBtn setSelected:YES];
    }
    else
    {
        [self.priceUpBtn setSelected:YES];
    }
    //_type = @"1";
    
    //[self addObserver:self forKeyPath:@"type" options:NSKeyValueObservingOptionPrior context:nil];
    //上拉加载更多
    __weak MarketViewController * vc = self;
    refreshFooterView = [[MJRefreshFooterView alloc] initWithScrollView:self.contentTable];
    refreshFooterView.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
    
        [vc loadMoreData];
    };
    
    [self initData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if(popupTagViewController)
    {
        [popupTagViewController.view removeFromSuperview];
        [popupTagViewController removeFromParentViewController];
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

/*
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
*/

- (void)setType:(NSString *)type keyword:(NSString *)keyword
{
    _type = type;
    _keyword = keyword;
    _selectedCategory = nil;
    if([_type isEqualToString:@"1"])
    {
        [self.priceUpBtn setSelected:YES];
        [self.priceDownBtn setSelected:NO];
        [self initData];
    }
    else if([_type isEqualToString:@"0"])
    {
        [self.priceDownBtn setSelected:YES];
        [self.priceUpBtn setSelected:NO];
        [self initData];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)priceDownAction
{
    NSLog(@"%s",__func__);
    [self.priceDownBtn setSelected:YES];
    [self.priceUpBtn setSelected:NO];
    _type = @"0";
    _keyword = nil;
    _selectedCategory = nil;
    [self initData];
    
}

-(void)priceUpAction
{
    NSLog(@"%s",__func__);
    [self.priceUpBtn setSelected:YES];
    [self.priceDownBtn setSelected:NO];
    _type = @"1";
    _keyword = nil;
    _selectedCategory = nil;
    [self initData];
}


- (void)initData
{
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.currentPage = @"1";
    hud.labelText = @"加载中...";
    if(_type == nil) _type = @"1";
    NSMutableDictionary * params = [@{@"type":self.type,@"page":self.currentPage,@"pageSize":@"15"} mutableCopy];
    if(_keyword)
    {
        [params setValue:_keyword forKey:@"keyword"];
    }
    
    if(_selectedCategory)
    {
        [params setValue:_selectedCategory.hw_id forKey:@"cate_id"];
    }
    
    NSLog(@"%@",params);
    
    [[HttpService sharedInstance] getMarketCommodity:params completionBlock:^(id object) {
        if(object == nil || [object count] == 0)
        {
            if([self.type isEqualToString:@"1"])
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
    NSMutableDictionary * params = [@{@"type":self.type,@"page":self.currentPage,@"pageSize":@"15"} mutableCopy];
    if(_keyword)
    {
        [params setValue:_keyword forKey:@"keyword"];
    }
    
    if(_selectedCategory)
    {
        [params setValue:_selectedCategory.hw_id forKey:@"cate_id"];
    }
    [[HttpService sharedInstance] getMarketCommodity:params completionBlock:^(id object) {
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


- (void)showBranch:(id)sender
{
    UIButton * btn = (UIButton *)sender;
    [btn setSelected:!btn.selected];
    AppDelegate * appDelegate = [ControlCenter appDelegate];
    if (btn.selected) {
        if (!popupTagViewController) {
            
            popupTagViewController = [[PopupTagViewController alloc]initWithNibName:@"PopupTagViewController" bundle:nil];
            NSMutableArray * array = [NSMutableArray array];
            for(TeaCategory * category in appDelegate.allTeaCategory)
            {
                [array addObject:category.name];
            }
            [popupTagViewController setDataSource:array];
            //设置位置
            CGRect originalRect = popupTagViewController.view.frame;
            originalRect.origin.x = btn.frame.origin.x + btn.frame.size.width - originalRect.size.width/2-15;
            originalRect.origin.y = btn.frame.origin.y + btn.frame.size.height + (15);
            [popupTagViewController.view setFrame:originalRect];
            __weak MarketViewController * weakSelf = self;
            [popupTagViewController setBlock:^(NSString * item){
                [btn setSelected:NO];
                //[btn setTitle:item forState:UIControlStateNormal];
                NSLog(@"%@",item);
                
                for(TeaCategory * category in appDelegate.allTeaCategory)
                {
                    if([category.name isEqualToString:item])
                    {
                        weakSelf.selectedCategory = category;
                        break;
                    }
                }
                weakSelf.keyword = nil;
                
                if(weakSelf.selectedCategory == nil) return ;
                [weakSelf initData];
                
            }];

            [self.navigationController.view addSubview:popupTagViewController.view];
            return;
        }
        [self.navigationController.view addSubview:popupTagViewController.view];
    }else
    {
        [popupTagViewController.view removeFromSuperview];
        //[popupTagViewController removeFromParentViewController];
    }
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
    //cell.weightLabel.text = [NSString stringWithFormat:@"%@g",commodity.weight];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if([self.type isEqualToString:@"1"])
    {
        cell.arrowImageView.image = [UIImage imageNamed:@"升价小图标"];
        cell.weightLabel.text = [NSString stringWithFormat:@"涨￥%i",abs([commodity.hw__price intValue] - [commodity.price intValue])];
    }
    else
    {
        cell.arrowImageView.image = [UIImage imageNamed:@"降价小图标"];
        cell.weightLabel.text = [NSString stringWithFormat:@"跌￥%i",abs([commodity.hw__price intValue] - [commodity.price intValue])];
    }
    cell.addCollectionButton.tag = indexPath.row;
    [cell.callButton addTarget:self action:@selector(callAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.addCollectionButton addTarget:self action:@selector(addToFavorite:) forControlEvents:UIControlEventTouchUpInside];
    [cell.teaImageView setImageWithURL:[NSURL URLWithString:commodity.image] placeholderImage:[UIImage imageNamed:@"关闭交易（选中状态）"]];
    
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
