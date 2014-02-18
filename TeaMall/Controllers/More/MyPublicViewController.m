//
//  TradingTableViewController.m
//  TeaMall
//
//  Created by omi on 14-1-14.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "MyPublicViewController.h"
#import "MyPublicCell.h"
#import "UIViewController+BarItem.h"
#import "HttpService.h"
#import "Publish.h"
#import "MBProgressHUD.h"
#import "MJRefresh.h"
#import "User.h"
#import "UIImageView+AFNetworking.h"
@interface MyPublicViewController ()
@property (nonatomic,strong) MJRefreshFooterView * refreshFooterView;
@property (nonatomic,strong) NSMutableArray * publishList;
@property (nonatomic,assign) int currentPage;
@property (nonatomic,strong) User * user;
@end

@implementation MyPublicViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.currentPage = 1;
        _publishList = [NSMutableArray array];
        _user = [User userFromLocal];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setLeftCustomBarItem:@"返回" action:nil];
    UINib * nib = [UINib nibWithNibName:@"MyPublicCell" bundle:[NSBundle bundleForClass:[MyPublicCell class]]];
    [_tableView registerNib:nib forCellReuseIdentifier:@"Cell"];
    _refreshFooterView = [[MJRefreshFooterView alloc] initWithScrollView:_tableView];
    __weak MyPublicViewController * vc = self;
    _refreshFooterView.beginRefreshingBlock = ^(MJRefreshBaseView * refreshBaseView){
        vc.currentPage += 1;
        [vc loadData];
    };
    
    [self loadData];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dealloc
{
    _tableView.delegate = nil;
    _tableView.dataSource = nil;
    _tableView = nil;
}

#pragma mark - Private Methods
- (void)loadData
{
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"加载中...";
    NSDictionary * params = @{@"user_id":_user.hw_id,@"page":[NSString stringWithFormat:@"%i",_currentPage],@"pageSize":@"15"};
    [[HttpService sharedInstance] getUserPublish:params completionBlock:^(id object) {
        [_refreshFooterView endRefreshing];
        if(object == nil || [object count] == 0)
        {
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"暂时没有数据";
            [hud hide:YES afterDelay:1];
            return ;
        }
        [hud hide:YES];
        if(self.currentPage == 1) [_publishList removeAllObjects];
        [_publishList addObjectsFromArray:object];
        [_tableView reloadData];
    } failureBlock:^(NSError *error, NSString *responseString) {
        [_refreshFooterView endRefreshing];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"加载失败";
        [hud hide:YES afterDelay:1];
    }];
}

- (void)closeAction:(UIButton *)button
{
    MyPublicCell * cell;
    if([button.superview.superview isKindOfClass:[MyPublicCell class]])
    {
        cell = (MyPublicCell *)button.superview.superview;
    }
    else if([button.superview.superview.superview isKindOfClass:[MyPublicCell class]])
    {
        cell = (MyPublicCell *)button.superview.superview.superview;
    }
    else
    {
        return ;
    }

    NSIndexPath * indexPath = [_tableView indexPathForCell:cell];
    NSLog(@"%i",indexPath.row);
    Publish * publish = [_publishList objectAtIndex:indexPath.row];
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在删除...";
    [[HttpService sharedInstance] deletePublish:@{@"id":publish.hw_id} completionBlock:^(id object) {
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"删除成功";
        [hud hide:YES afterDelay:1];
        [_publishList removeObject:publish];
        [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    } failureBlock:^(NSError *error, NSString *responseString) {
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"删除失败";
        [hud hide:YES afterDelay:1];
    }];
}

#pragma mark - tableView -
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 180;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_publishList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    MyPublicCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"Cell"];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    Publish * publish = [_publishList objectAtIndex:indexPath.row];
    cell.productNameLabel.text = publish.name;
    cell.priceLabel.text = [NSString stringWithFormat:@"￥%@",publish.price];
    cell.amountLabel.text = publish.amount;
    cell.businessNumberLabel.text = publish.business_number;
    cell.brandLabel.text = publish.brand;
    NSString * publishDate = [[NSDate dateFromString:publish.publish_time withFormat:@"yyyy-MM-dd hh:mm:ss"] formatDateString:@"yyyy-MM-dd"];
    cell.publishDateLabel.text = publishDate;
    if([publish.is_buy isEqualToString:@"0"])
    {
        cell.userActionType.text = @"我要卖";
    }
    else
    {
        cell.userActionType.text = @"我要买";
    }
    
    [cell.imageView_1 setImageWithURL:[NSURL URLWithString:publish.image_1]];
    [cell.imageView_2 setImageWithURL:[NSURL URLWithString:publish.image_2]];
    [cell.imageView_3 setImageWithURL:[NSURL URLWithString:publish.image_3]];
    [cell.closeBtn addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.closeBtn.hidden = NO;
    return (UITableViewCell *)cell;
}




@end
