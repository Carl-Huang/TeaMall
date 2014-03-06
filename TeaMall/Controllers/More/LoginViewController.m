//
//  LoginViewController.m
//  TeaMall
//
//  Created by Carl_Huang on 14-1-12.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "LoginViewController.h"
#import "UINavigationBar+Custom.h"
#import "RegisteredViewController.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "HttpService.h"
#import "User.h"
#import "PersonalCenterViewController.h"
@interface LoginViewController ()
@property (nonatomic,assign) BOOL isShowing;
@end

@implementation LoginViewController

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
    _isShowing = NO;
    [self setLeftCustomBarItem:@"返回" action:nil];
    if(![OSHelper iPhone5])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
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

- (IBAction)registered:(id)sender
{
    RegisteredViewController *registeredVC = [[RegisteredViewController alloc]initWithNibName:@"RegisteredViewController" bundle:nil];
    [self.navigationController pushViewController:registeredVC animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)gotoMainView:(id)sender {
    AppDelegate * myDelegate  = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    UIViewController * viewController =[myDelegate.akTabBarController.viewControllers objectAtIndex:0];
    myDelegate.akTabBarController.selectedViewController = viewController;;
}
- (IBAction)loginAction:(id)sender
{
    [_userName resignFirstResponder];
    [_passWord resignFirstResponder];
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
            [self performSelector:@selector(showPersonalCenter) withObject:nil afterDelay:1.4];
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


@end
