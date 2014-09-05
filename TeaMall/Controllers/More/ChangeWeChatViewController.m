//
//  ChangeWeChatViewController.m
//  TeaMall
//
//  Created by Carl on 14-3-20.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "ChangeWeChatViewController.h"
#import "User.h"
#import "MBProgressHUD.h"
#import "HttpService.h"
@interface ChangeWeChatViewController ()
@property (nonatomic,strong) User * user;
@end

@implementation ChangeWeChatViewController

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
    [self setLeftCustomBarItem:@"返回" action:nil];
    _user = [User userFromLocal];
    _wechatField.text = _user.wechat;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)sure:(id)sender
{
    [_wechatField resignFirstResponder];
    if([_wechatField.text length] == 0)
    {
        [self popVIewController];
        //[self showAlertViewWithMessage:@"请输入您的手机号码"];
        return ;
    }
    
    
    
    if([_user.wechat isEqualToString:_wechatField.text])
    {
        [self popVIewController];
        return ;
    }
    
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"更新中...";
    NSDictionary * params = @{@"id":_user.hw_id,@"wechat":_wechatField.text};
    [[HttpService sharedInstance] updateUserInfo:params completionBlock:^(id object) {
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"更新成功";
        [hud hide:YES afterDelay:1];
        User * newUser = (User *)object;
        _user.wechat = newUser.wechat;
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
