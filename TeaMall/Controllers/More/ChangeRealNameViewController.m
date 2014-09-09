//
//  ChangeNameViewController.m
//  TeaMall
//
//  Created by Carl on 14-2-12.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "ChangeRealNameViewController.h"
#import "User.h"
#import "MBProgressHUD.h"
#import "HttpService.h"
#import "Constants.h"
@interface ChangeRealNameViewController ()
@property (nonatomic,strong) User * user;
@end

@implementation ChangeRealNameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setLeftCustomBarItem:@"返回" action:nil];
    _user = [User userFromLocal];
    _nameField.text = _user.real_name;
}

- (void)dealloc
{
    [self setView:nil];
}

#pragma mark 确定按钮监听方法
- (IBAction)sure:(id)sender {
    [_nameField resignFirstResponder];
    if([_nameField.text length] == 0)
    {
        [self showAlertViewWithMessage:@"请输入您的真实姓名"];
        return ;
    }
    
    if([_nameField.text length] > 30)
    {
        [self showAlertViewWithMessage:@"真实姓名不能超过10个中文字符，不能超过30个英文字符"];
        return ;
    }
    
    if([_user.real_name isEqualToString:_nameField.text])
    {
        [self popVIewController];
        return ;
    }
    
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"更新中...";
    NSDictionary * params = @{@"user_id":_user.hw_id,@"real_name":_nameField.text};
    [[HttpService sharedInstance] addUserRealName:params completionBlock:^(id object) {
        hud.mode = MBProgressHUDModeText;
        NSString *successStr = (NSString *)object;
        hud.labelText = successStr;//更新成功
        [hud hide:YES afterDelay:1];
#warning 暂时没有判断字符串的长度
        _user.real_name = _nameField.text;
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
