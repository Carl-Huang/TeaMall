//
//  LoginViewController.m
//  TeaMall
//
//  Created by Carl_Huang on 14-1-12.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//  weibo uid  @"2147485894"
//  QQ    uid  @"1405461F1E86576AA21B042A3AEB9FB6"

#import "LoginViewController.h"
#import "UINavigationBar+Custom.h"
#import "RegisteredViewController.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "HttpService.h"
#import "User.h"
#import <ShareSDK/ShareSDK.h>
#import "ShareManager.h"
#import "PersonalCenterViewController.h"
#import "SSCheckBoxView.h"
#import "RegisteredViewController.h"
#define Is_Remember_Pass @"remember_pass"
@interface LoginViewController ()<UIAlertViewDelegate>
{
    SSCheckBoxView * checkbox;
    NSString *_oprenID;//第三方登陆的uid
    NSString *_type;   //登陆类型
}
@property (nonatomic,assign) BOOL isShowing;

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _isNeedGoBack = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _isShowing = NO;
    [self setLeftCustomBarItem:@"返回" action:nil];
    if(![OSHelper iPhone5])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    //是否记住密码
    checkbox = [[SSCheckBoxView alloc] initWithFrame:CGRectMake(195, 205, 117, 21) style:kSSCheckBoxViewStyleGlossy checked:[[NSUserDefaults standardUserDefaults] boolForKey:Is_Remember_Pass]];
    [checkbox setText:@"记住密码"];
    checkbox.textLabel.textColor = [UIColor whiteColor];
    [checkbox setStateChangedTarget:self selector:@selector(checkboxStateChanged:)];
    [self.view addSubview:checkbox];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if([[NSUserDefaults standardUserDefaults] boolForKey:Is_Remember_Pass])
    {
        User * user = [User userFromLocal];
        if (user) {
            _userName.text = user.account;
            _passWord.text =user.password;
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dealloc
{
    _userName.delegate = nil;
    _passWord.delegate = nil;
    _userName = nil;
    _passWord = nil;
    [self setView:nil];
}

- (void)checkboxStateChanged:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setBool:checkbox.checked forKey:Is_Remember_Pass];
}

- (IBAction)registered:(id)sender
{
    RegisteredViewController *registeredVC = [[RegisteredViewController alloc]initWithNibName:@"RegisteredViewController" bundle:nil];
    [self.navigationController pushViewController:registeredVC animated:YES];
}

- (IBAction)gotoMainView:(id)sender {
    AppDelegate * myDelegate  = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    UIViewController * viewController =[myDelegate.akTabBarController.viewControllers objectAtIndex:0];
    myDelegate.akTabBarController.selectedViewController = viewController;;
}

#pragma mark --登陆按钮监听方法
- (IBAction)loginAction:(id)sender
{
    [_userName resignFirstResponder];
    [_passWord resignFirstResponder];
    //判断用户是否登陆
    if ([User userFromLocal]) {
        [self showAlertViewWithMessage:@"您已经登陆了，请先退出再登陆"];
        return;
    }
    
    if([_userName.text length] == 0)
    {
        [self showAlertViewWithMessage:@"请填写您的用户名"];
        return ;
    }
    
    if([_passWord.text length] == 0)
    {
        [self showAlertViewWithMessage:@"请输入您的密码"];
        return;
    }

    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"登录中...";
    [[HttpService sharedInstance] userLogin:@{@"account":_userName.text,@"password":_passWord.text} completionBlock:^(id object) {
        hud.mode = MBProgressHUDModeText;
        if(object)
        {
            User * user = (User *)object;
            [User saveToLocal:user];
            hud.labelText = @"登录成功";
            [hud hide:YES afterDelay:1.2];
            _userName.text = nil;
            _passWord.text = nil;
            if(_isNeedGoBack)
            {
                [self popVIewController];
            }
            else
            {
                [self performSelector:@selector(showPersonalCenter) withObject:nil afterDelay:1.4];
            }
        }
        else
        {
            hud.labelText = @"登录失败,请重试";
            
        }
        [hud hide:YES afterDelay:1];
    } failureBlock:^(NSError *error, NSString *responseString) {
        hud.mode = MBProgressHUDModeText;
        if(error == nil && [responseString integerValue]== 0)
        {
            hud.labelText = @"用户名或密码错误";
            [hud hide:YES afterDelay:1];
            return ;
        }
        
        
        hud.labelText = @"登录失败,请重试";
        [hud hide:YES afterDelay:1];

    }];
    
}

- (void)showPersonalCenter
{
    PersonalCenterViewController * vc = [[PersonalCenterViewController alloc] initWithNibName:nil bundle:nil];
    [self push:vc];
    vc = nil;
}

#pragma mark - UITextFieldDelegate Methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == _userName)
    {
        [_passWord becomeFirstResponder];
        return NO;
    }

    [textField resignFirstResponder];
    return YES;
}

- (void)keyboardShow:(NSNotification *)notification
{
    if(_isShowing) return;
    _isShowing = YES;
    self.view.frame = CGRectOffset(self.view.frame, 0, -28);
}

- (void)keyboardHide:(NSNotification *)notification
{
    _isShowing = NO;
    self.view.frame = CGRectOffset(self.view.frame, 0, 28);
}

//判断账号的uid是否已绑定
/*
 *******返回成功并且账号已绑定：
 result =     (
 {
 account = "XXXXXXXXXXX";
 avatar = "<null>";
 id = 228;
 "last_time" = "2014-09-04 10:04:09";
 password = "<null>";
 phone = 02087905282;
 "register_time" = "2014-09-04 10:03:59";
 sex = "<null>";
 wechat = "<null>";
 }
 );
 status = 1;
 ｝
 
 ********返回成功并且账号没绑定：
 {
 status: 1
 result: 0
 }
 
 ********返回失败：
 {
 status: 0
 result: "参数错误"
 }
 */
#pragma mark 第三方登陆登陆
- (IBAction)openLogin:(UIButton *)sender {
    //判断用户是否登陆
    if ([User userFromLocal]) {
        [self showAlertViewWithMessage:@"您已经登陆了，请先退出再登陆"];
        return;
    }
    //tag等于1为QQ登陆，2为新浪微博登陆
    NSString *loginType = [NSString stringWithFormat:@"%d",sender.tag];
    _type = loginType;
    ShareType shareType;
    //根据tag来判断登陆类型
    if (sender.tag == 1) {
        shareType = ShareTypeQQSpace;
    }else
    {
        shareType = ShareTypeSinaWeibo;
    }
    
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"登录中...";
    [ShareSDK getUserInfoWithType:shareType authOptions:nil result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
        if (result)
        {
            NSLog(@"uid = %@",[userInfo uid]);
            NSLog(@"name = %@",[userInfo nickname]);
            NSLog(@"icon = %@",[userInfo profileImage]);
            
            _oprenID = [userInfo uid];
            //判断是否第三方登陆账号
            [[HttpService sharedInstance] isOpenLogin:@{@"type":loginType,@"open_id":[userInfo uid]} completionBlock:^(id object) {
                
                NSLog(@"%@",object);
                //是的话保存账号
                if ([object isKindOfClass:[User class]]) {
                    User *user = (User *)object;
                    [User saveToLocal:user];
                    hud.mode = MBProgressHUDModeText;
                    hud.labelText = @"登录成功";
                    [self performSelector:@selector(showPersonalCenter) withObject:nil afterDelay:1.4];
                    
                }else{
                    NSLog(@"%@",object);
                    //否的话询问用户是否注册并且绑定
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:object message:@"是否注册并且绑定" delegate:self cancelButtonTitle:@"不了" otherButtonTitles:@"好的", nil];
                    [alert show];
                }
                [hud hide:YES afterDelay:1.2];
            } failureBlock:^(NSError *error, NSString *responseString) {
                NSLog(@"%@",responseString);
                [self showAlertViewWithMessage:@"登陆失败，请重试"];
            }];
        }
        
    }];
}

#pragma mark alertView代理方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        alertView = nil;
    }else
    {
        RegisteredViewController *registeredVC = [[RegisteredViewController alloc]initWithNibName:@"RegisteredViewController" bundle:nil];
        registeredVC.openID = _oprenID;
        registeredVC.type = _type;
        [self.navigationController pushViewController:registeredVC animated:YES];
        alertView = nil;
    }
}

@end
