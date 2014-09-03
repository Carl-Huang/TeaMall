//
//  ChangeNameViewController.m
//  TeaMall
//
//  Created by Carl on 14-2-12.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "ChangeShopNameViewController.h"
#import "User.h"
#import "MBProgressHUD.h"
#import "HttpService.h"
#import "Constants.h"
@interface ChangeShopNameViewController ()
@property (nonatomic,strong) User * user;
@end

@implementation ChangeShopNameViewController

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
    [self setLeftCustomBarItem:@"返回" action:@selector(goBack:)];
    _user = [User userFromLocal];
    _nameField.text = _user.shop_name;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [self setView:nil];
}

- (void)goBack:(id)sender
{
    [_nameField resignFirstResponder];
    if([_nameField.text length] == 0)
    {
        [self showAlertViewWithMessage:@"请输入您的商铺名称"];
        return ;
    }
    
    if([_user.shop_name isEqualToString:_nameField.text])
    {
        [self popVIewController];
        return ;
    }
    
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"更新中...";
    NSDictionary * params = @{@"user_id":_user.hw_id,@"shop_name":_nameField.text};
    [[HttpService sharedInstance] addShopName:params completionBlock:^(id object) {
        hud.mode = MBProgressHUDModeText;
        NSString *successStr = (NSString *)object;
        hud.labelText = successStr;//更新成功
        [hud hide:YES afterDelay:1];
        _user.shop_name = _nameField.text;
        [User saveToLocal:_user];
        [self popVIewController];
    } failureBlock:^(NSError *error, NSString *responseString) {
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"更新失败";
        [hud hide:YES afterDelay:1];
        [self popVIewController];
    }];
}

@end
