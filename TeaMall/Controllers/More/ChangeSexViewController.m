//
//  ChangeSexViewController.m
//  TeaMall
//
//  Created by Carl on 14-2-12.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "ChangeSexViewController.h"
#import "User.h"
#import "MBProgressHUD.h"
#import "HttpService.h"
@interface ChangeSexViewController ()
@property (nonatomic,strong) NSArray * dataSource;
@property (nonatomic,strong) NSString * selectedSex;
@property (nonatomic,strong) User * user;
@end

@implementation ChangeSexViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _dataSource = @[@"男",@"女"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setLeftCustomBarItem:@"返回" action:@selector(goBack:)];
    _user = [User userFromLocal];
    if(_user.sex)
    {
        if([_user.sex isEqualToString:@"1"])
        {
            self.selectedSex = @"男";
        }
        else
        {
            self.selectedSex = @"女";
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    
    

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
    [self setView:nil];
}


- (void)goBack:(id)sender
{
    if(self.selectedSex == nil)
    {
        [self popVIewController];
        return ;
    }
    NSString * sex;
    if([self.selectedSex isEqualToString:@"男"])
    {
        sex = @"1";
    }
    else if([self.selectedSex isEqualToString:@"女"])
    {
        sex = @"0";
    }
    
    if([_user.sex isEqualToString:sex])
    {
        [self popVIewController];
        return ;
    }
    
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"更新中...";
    NSDictionary * params = @{@"id":_user.hw_id,@"sex":sex};
    [[HttpService sharedInstance] updateUserInfo:params completionBlock:^(id object) {
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"更新成功";
        [hud hide:YES afterDelay:1];
        User * newUser = (User *)object;
        _user.sex = newUser.sex;
        [User saveToLocal:_user];
        [self popVIewController];
    } failureBlock:^(NSError *error, NSString *responseString) {
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"更新失败";
        [hud hide:YES afterDelay:1];
        [self popVIewController];
    }];

}

#pragma mark - UITableViewDataSource Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataSource count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    if([self.selectedSex isEqualToString:[_dataSource objectAtIndex:indexPath.row]])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell.textLabel.text = [_dataSource objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedSex = [_dataSource objectAtIndex:indexPath.row];
    [tableView reloadData];
}

@end
