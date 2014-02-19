//
//  MyAddressViewController.m
//  TeaMall
//
//  Created by Carl on 14-2-12.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "MyAddressViewController.h"
#import "MyAddressCell.h"
#import "AddAddressViewController.h"
#import "Address.h"
#import "HttpService.h"
#import "MBProgressHUD.h"
#import "MJRefresh.h"
#import "User.h"
#import <QuartzCore/QuartzCore.h>
@interface MyAddressViewController ()
{
    MJRefreshHeaderView * refreshHeaderView;
}
@property (nonatomic,strong) NSMutableArray * addressList;
@property (nonatomic,strong) NSString * currentPage;
@property (nonatomic,strong) NSIndexPath * selectedIndexPath;
@end

@implementation MyAddressViewController
#pragma mark - Life Cycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.currentPage = @"1";
        _selectedIndexPath = [[NSIndexPath alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setLeftCustomBarItem:@"返回" action:nil];
    UINib * nib = [UINib nibWithNibName:@"MyAddressCell" bundle:[NSBundle bundleForClass:[MyAddressCell class]]];
    [_tableView registerNib:nib forCellReuseIdentifier:@"Cell"];
    [_tableView setBackgroundColor:[UIColor clearColor]];
    
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(addAddressAction:)];
    rightItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightItem;
    rightItem = nil;
    
    refreshHeaderView = [[MJRefreshHeaderView alloc] initWithScrollView:_tableView];
    __weak MyAddressViewController * vc = self;
    refreshHeaderView.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
        
        [vc initData];
        
    };
    
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [refreshHeaderView beginRefreshing];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [refreshHeaderView endRefreshing];
}

- (void)dealloc
{
    _tableView.delegate = nil;
    _tableView.dataSource = nil;
    _tableView = nil;
    [self setView:nil];
}


#pragma mark - Action Methods
- (IBAction)sureAction:(id)sender
{
    
}

- (void)addAddressAction:(id)sender
{
    AddAddressViewController * vc = [[AddAddressViewController alloc] initWithNibName:nil bundle:nil];
    [self push:vc];
    vc = nil;
}


- (void)initData
{
    self.currentPage = @"1";
    User * user = [User userFromLocal];
    [[HttpService sharedInstance] getAddressList:@{@"user_id":user.hw_id,@"page":self.currentPage,@"pageSize":@"15"} completionBlock:^(id object) {
        _addressList = object;
        [_tableView reloadData];
        [refreshHeaderView endRefreshing];
    } failureBlock:^(NSError *error, NSString *responseString) {
        [refreshHeaderView endRefreshing];
    }];
}

- (void)checkAction:(UIButton *)sender
{
    
}

#pragma mark - UITableViewDataSource Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_addressList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 111.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyAddressCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.bgView.layer.cornerRadius = 6.0f;
    cell.bgView.layer.borderWidth = 1.0f;
    cell.bgView.layer.borderColor = [UIColor grayColor].CGColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    Address * address = [_addressList objectAtIndex:indexPath.row];
    cell.addressLabel.text = address.address;
    cell.nameLabel.text = address.name;
    cell.phoneLabel.text = address.phone;
    [cell.checkboxBtn addTarget:self action:@selector(checkAction:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

#pragma mark - UITableViewDelegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Address * address = [_addressList objectAtIndex:indexPath.row];
    AddAddressViewController * vc = [[AddAddressViewController alloc] initWithNibName:nil bundle:nil];
    vc.address = address;
    [self push:vc];
    vc = nil;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    Address * address = [_addressList objectAtIndex:indexPath.row];
    
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"删除中...";
    [[HttpService sharedInstance] deleteAddress:@{@"id":address.hw_id} completionBlock:^(id object) {
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"删除成功";
        [hud hide:YES afterDelay:1];
        [_addressList removeObjectAtIndex:indexPath.row];
        [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } failureBlock:^(NSError *error, NSString *responseString) {
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"删除失败,请重试";
        [hud hide:YES afterDelay:1];
        [_tableView endEditing:YES];

    }];
}

@end
