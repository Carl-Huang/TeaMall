//
//  CustomiseServiceViewController.m
//  TeaMall
//
//  Created by vedon on 13/1/14.
//  Copyright (c) 2014 helloworld. All rights reserved.
//

#import "CustomiseServiceViewController.h"
#import "CustomiseServiceCell.h"
#import "UIViewController+BarItem.h"
#import "CustomerService.h"
#import "User.h"
#import "HttpService.h"
#import "MBProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "starView.h"
#import <PersonalInfoViewController.h>

static NSString * cellIdentifier = @"cellIdentifier";
@interface CustomiseServiceViewController ()
{
    NSUInteger cellItemHeight;
}
@end

@implementation CustomiseServiceViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _plistArray = @[];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"TeamPList" ofType:@"plist"];
//    self.plistArray = [[NSArray alloc]initWithContentsOfFile:plistPath];
    
    [self setLeftCustomBarItem:@"返回" action:nil];
#ifdef iOS7_SDK
    if ([OSHelper iOS7]) {
        self.contentTable.separatorInset = UIEdgeInsetsZero;
    }
#endif
    cellItemHeight = 0;
    CustomiseServiceCell * cell = [[[NSBundle mainBundle]loadNibNamed:@"CustomiseServiceCell" owner:self options:nil]objectAtIndex:0];
    cellItemHeight = cell.frame.size.height;
    cell = nil;

    
    UINib *cellNib = [UINib nibWithNibName:@"CustomiseServiceCell" bundle:[NSBundle bundleForClass:[CustomiseServiceCell class]]];
    [self.contentTable registerNib:cellNib forCellReuseIdentifier:cellIdentifier];
    
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"加载中...";
    [[HttpService sharedInstance] getCustomerService:@{@"page":@"1",@"pageSize":@"100"} completionBlock:^(id object) {
        [hud hide:YES];
        self.plistArray = object;
        [_contentTable reloadData];
    } failureBlock:^(NSError *error, NSString *responseString) {
        if(error == nil)
        {
            hud.labelText = responseString;
            
        }
        else
        {
            hud.labelText = @"加载失败";
        }
        [hud hide:YES afterDelay:1];
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return cellItemHeight;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.plistArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomiseServiceCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    CustomerService * cs = [self.plistArray objectAtIndex:indexPath.row];
    [cell.imageV setImageWithURL:[NSURL URLWithString:cs.image] placeholderImage:[UIImage imageNamed:@"刘先生-客服头像7.png"]];
    cell.phoneNum.text = cs.phone;
    cell.name.text = cs.contact;
    [cell.starView setStarNum:[cs.level integerValue]];

    [cell.call addTarget:self action:@selector(callAction:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if ([self.myParentController isKindOfClass:[PersonalInfoViewController class]]) {
        CustomerService * cs = _plistArray[indexPath.row];
        [self addService:cs.hw_id indexPath:indexPath];
    }
}

#pragma mark  -添加客服
- (void)addService:(NSString *)service_id indexPath:(NSIndexPath *)indexPath
{
   
    User *user = [User userFromLocal];
    CustomerService *cs = _plistArray[indexPath.row];
    if ([user.serviceName isEqualToString:cs.contact]) {
        [self popVIewController];
    }
    
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"更新中...";
    NSDictionary * params = @{@"user_id":user.hw_id,@"service_id":service_id};
    [[HttpService sharedInstance] addService:params completionBlock:^(id object) {
        hud.mode = MBProgressHUDModeText;
        hud.labelText = object;
        [hud hide:YES afterDelay:1];
        user.serviceName = cs.contact;
        [User saveToLocal:user];
        
        [self popVIewController];
    } failureBlock:^(NSError *error, NSString *responseString) {
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"更新失败";
        [hud hide:YES afterDelay:1];
        [self popVIewController];
    }];
}

- (void)callAction:(UIButton *)button
{
    CustomiseServiceCell * cell;
    if([button.superview.superview isKindOfClass:[CustomiseServiceCell class]])
    {
        cell = (CustomiseServiceCell *)button.superview.superview;
    }
    else if([button.superview.superview.superview isKindOfClass:[CustomiseServiceCell class]])
    {
        cell = (CustomiseServiceCell *)button.superview.superview.superview;
    }
    else
    {
        return ;
    }
    
    NSIndexPath * indexPath = [_contentTable indexPathForCell:cell];
    CustomerService * cs = [self.plistArray objectAtIndex:indexPath.row];
    NSString * telString = [NSString stringWithFormat:@"tel://%@",cs.phone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telString]];
    
}


@end
