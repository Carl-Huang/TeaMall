//
//  SquareViewController.m
//  TeaMall
//
//  Created by vedon on 13/1/14.
//  Copyright (c) 2014 helloworld. All rights reserved.
//

#import "SquareViewController.h"
#import "SquareItemCell.h"
#import "SquareItemDetailViewController.h"
#import "CustomiseServiceViewController.h"
#import "HttpService.h"
#import "MBProgressHUD.h"
#import "Publish.h"
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>
#import "starView.h"
static NSString * cellIdentifier = @"cellIdentifier";
@interface SquareViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSUInteger cellItemHeight;

}
@property (nonatomic,strong) MJRefreshHeaderView * refreshHeaderView;
@property (nonatomic,strong) MJRefreshFooterView * refreshFooterView;
@property (nonatomic,assign) int currentPage;
@property (nonatomic,strong) NSMutableArray * publishList;
@end

@implementation SquareViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData:) name:@"ShowPublish" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeImageView:) name:@"DismissImageView" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchPublish:) name:@"SearchPublish" object:nil];
        _publishList = [NSMutableArray array];
        self.currentPage = 1;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect rect = self.view.frame;
    if(![OSHelper iPhone5])
    {
        rect.size.height = 367;
        [self.view setFrame:rect];
    }

    cellItemHeight = 0;
    SquareItemCell * cell = [[[NSBundle mainBundle]loadNibNamed:@"SquareItemCell" owner:self options:nil]objectAtIndex:0];
    cellItemHeight = cell.frame.size.height;
    cell = nil;
    
    UINib *cellNib = [UINib nibWithNibName:@"SquareItemCell" bundle:[NSBundle bundleForClass:[SquareItemCell class]]];
    [self.contentTable registerNib:cellNib forCellReuseIdentifier:cellIdentifier];
#ifdef iOS7_SDK
    if ([OSHelper iOS7]) {
        self.contentTable.separatorInset = UIEdgeInsetsZero;
    }
#endif
        
//    _refreshHeaderView = [[MJRefreshHeaderView alloc] initWithScrollView:self.contentTable];
    _refreshFooterView = [[MJRefreshFooterView alloc] initWithScrollView:self.contentTable];
    __weak SquareViewController * vc = self;
//    _refreshHeaderView.beginRefreshingBlock = ^(MJRefreshBaseView * refreshBaseView){
//        vc.currentPage = 1;
//        
//    };
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
    _contentTable.delegate = nil;
    _contentTable.dataSource = nil;
    _contentTable = nil;
    _refreshHeaderView.beginRefreshingBlock = nil;
    _refreshFooterView.beginRefreshingBlock = nil;
    _refreshFooterView = nil;
    _refreshHeaderView = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - Private Methods
-(void)gotoContactServiceViewController
{
    CustomiseServiceViewController * viewController = [[CustomiseServiceViewController alloc]initWithNibName:@"CustomiseServiceViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
    viewController = nil;
}

- (void)refreshData:(NSNotification *)notification
{
    _keyword = nil;
    self.currentPage = 1;
    [self loadData];
}

- (void)searchPublish:(NSNotification *)notification
{
    self.currentPage = 1;
    [self loadData];    
}

- (void)loadData
{
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"加载中...";
    NSDictionary * params = [@{@"page":[NSString stringWithFormat:@"%i",_currentPage],@"pageSize":@"15"} mutableCopy];
    if(_keyword != nil)
    {
        [params setValue:_keyword forKey:@"keyword"];
    }
    [[HttpService sharedInstance] getPublishList:params completionBlock:^(id object) {
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
        [_contentTable reloadData];
    } failureBlock:^(NSError *error, NSString *responseString) {
        [_refreshFooterView endRefreshing];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"加载失败";
        [hud hide:YES afterDelay:1];
    }];
}



#pragma mark - UITableViewDataSource Methods
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return cellItemHeight;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_publishList count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SquareItemCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    [cell.contactServiceBtn addTarget:self action:@selector(gotoContactServiceViewController) forControlEvents:UIControlEventTouchUpInside];
    Publish * publish = [_publishList objectAtIndex:indexPath.row];
    cell.description.text = publish.name;
    cell.productName.text = publish.brand;
    cell.productBatch.text = [NSString stringWithFormat:@"批次:%@",publish.batch];
    cell.productNumber.text = [NSString stringWithFormat:@"%@%@",publish.amount,publish.unit];
    cell.productPrice.text = [NSString stringWithFormat:@"￥%@",publish.price];
    cell.tractionNumber.text = publish.business_number;
    NSString * publishDate = [[NSDate dateFromString:publish.publish_time withFormat:@"yyyy-MM-dd HH:mm:ss"] formatDateString:@"yyyy-MM-dd"];
    cell.tranctionDate.text = publishDate;
    cell.userImage.layer.cornerRadius = 10.0;
    cell.userImage.layer.masksToBounds = YES;
    int level = [publish.level intValue] == 0 ? 1 : [publish.level intValue];
    [cell.littleStarView setStarNum:level];
    [cell.userImage setImageWithURL:[NSURL URLWithString:publish.avatar] placeholderImage:[UIImage imageNamed:@"胡先生-客服头像4"]];
    
    if([publish.is_distribute isEqualToString:@"1"])
    {
        cell.sanchuLabel.text = @"可散出";
    }
    else
    {
        cell.sanchuLabel.text = @"不可散出";
    }
    
    if([publish.is_buy isEqualToString:@"0"])
    {
        cell.userActionType.text = @"我要出";
    }
    else
    {
        cell.userActionType.text = @"我要找";
    }
    cell.imageView_1.tag = 1;
    cell.imageView_2.tag = 2;
    cell.imageView_3.tag = 3;
    
    if(publish.image_1)
    {
        cell.imageView_1.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageAction:)];
        [cell.imageView_1 addGestureRecognizer:tap];
        tap = nil;
    }
    else
    {
        cell.imageView_1.userInteractionEnabled = NO;
    }
    if(publish.image_2)
    {
        cell.imageView_2.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageAction:)];
        [cell.imageView_2 addGestureRecognizer:tap];
        tap = nil;
    }
    else
    {
        cell.imageView_2.userInteractionEnabled = NO;
    }
    
    if(publish.image_3)
    {
        cell.imageView_3.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageAction:)];
        [cell.imageView_3 addGestureRecognizer:tap];
        tap = nil;
    }
    else
    {
        cell.imageView_3.userInteractionEnabled = NO;
    }
    
    [cell.imageView_1 setBackgroundColor:[UIColor whiteColor]];
    [cell.imageView_2 setBackgroundColor:[UIColor whiteColor]];
    [cell.imageView_3 setBackgroundColor:[UIColor whiteColor]];
    [cell.imageView_1 setImageWithURL:[NSURL URLWithString:publish.image_1]];
    [cell.imageView_2 setImageWithURL:[NSURL URLWithString:publish.image_2]];
    [cell.imageView_3 setImageWithURL:[NSURL URLWithString:publish.image_3]];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Publish * publish = [_publishList objectAtIndex:indexPath.row];
    SquareItemDetailViewController * viewController = [[SquareItemDetailViewController alloc]initWithNibName:@"SquareItemDetailViewController" bundle:nil];
    viewController.publish = publish;
    [self.navigationController pushViewController:viewController animated:YES];
    viewController = nil;
    
}

- (void)tapImageAction:(UITapGestureRecognizer *)gesture
{
    UIImageView * imageView = (UIImageView *)gesture.view;
    SquareItemCell* cell;
    if([imageView.superview.superview isKindOfClass:[SquareItemCell class]])
    {
        cell = (SquareItemCell *)imageView.superview.superview;
    }
    else if([imageView.superview.superview.superview isKindOfClass:[SquareItemCell class]])
    {
        cell = (SquareItemCell *)imageView.superview.superview.superview;
    }
    //NSIndexPath * indexPath = [_contentTable indexPathForCell:cell];
    //Publish * publish = [_publishList objectAtIndex:indexPath.row];
    UIView * view = [[[NSBundle mainBundle] loadNibNamed:@"ImageView" owner:nil options:nil] objectAtIndex:0];
    UIImageView * imagev = (UIImageView *)[view viewWithTag:1];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissImageView:)];
    [imagev addGestureRecognizer:tap];
    tap = nil;
    if(imageView.tag == 1)
    {
        imagev.image = cell.imageView_1.image;
    }
    else if(imageView.tag == 2)
    {
        imagev.image = cell.imageView_2.image;
    }
    else if(imageView.tag == 3)
    {
        imagev.image = cell.imageView_3.image;
    }
    view.frame = CGRectMake(0, 0, self.view.frame.size.width, 455);
    if(![OSHelper iPhone5])
    {
        view.frame = CGRectMake(0, 0, self.view.frame.size.width, 367);
    }
    //view.center = self.view.center;
    view.tag = 1000;
    [self.view addSubview:view];
}

- (void)dismissImageView:(id)sender
{
    [[self.view viewWithTag:1000] removeFromSuperview];
}

- (void)removeImageView:(NSNotification *)notification
{
    [[self.view viewWithTag:1000] removeFromSuperview];
}

@end
