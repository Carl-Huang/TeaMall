//
//  ChangePhoneViewController.m
//  TeaMall
//
//  Created by Carl on 14-2-12.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "ChangePhoneViewController.h"
#import "User.h"
#import "MBProgressHUD.h"
#import "HttpService.h"
@interface ChangePhoneViewController ()
@property (nonatomic,strong) User * user;
@end

@implementation ChangePhoneViewController

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
    _phoneField.text = _user.phone;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)goBack:(id)sender
{
    [_phoneField resignFirstResponder];
    if([_phoneField.text length] == 0)
    {
        [self showAlertViewWithMessage:@"请输入您的手机号码"];
        return ;
    }
    
    
    
    if([_user.phone isEqualToString:_phoneField.text])
    {
        [self popVIewController];
        return ;
    }
    
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"更新中...";
    NSDictionary * params = @{@"id":_user.hw_id,@"phone":_phoneField.text};
    [[HttpService sharedInstance] updateUserInfo:params completionBlock:^(id object) {
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"更新成功";
        [hud hide:YES afterDelay:1];
        User * newUser = (User *)object;
        _user.phone = newUser.phone;
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
