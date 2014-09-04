//
//  RegisteredViewController.m
//  TeaMall
//
//  Created by Carl_Huang on 14-1-12.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "RegisteredViewController.h"
#import "MBProgressHUD.h"
#import "HttpService.h"
@interface RegisteredViewController ()
@property (nonatomic,assign) BOOL isShowing;
@end

@implementation RegisteredViewController

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)dealloc
{
    [self setView:nil];
    _userName.delegate = nil;
    _password.delegate = nil;
    _confirmPwd.delegate = nil;
    _phone.delegate = nil;
    _userName = nil;
    _password = nil;
    _confirmPwd = nil;
    _phone = nil;
}

#pragma mark - Action Methods
- (IBAction)registerAction:(id)sender
{
    [self resignFirstResponder];
    if([_userName.text length] == 0)
    {
        [self showAlertViewWithMessage:@"请填写您的用户名"];
        return ;
    }
    
    if([_password.text length] == 0)
    {
        [self showAlertViewWithMessage:@"请输入您的密码"];
        return;
    }
    
    if([_confirmPwd.text length] == 0)
    {
        [self showAlertViewWithMessage:@"请输入您的验证密码"];
        return ;
    }
    
    if(![_password.text isEqualToString:_confirmPwd.text])
    {
        [self showAlertViewWithMessage:@"两次密码不一致"];
        return ;
    }
    
    if([_phone.text length] == 0)
    {
        [self showAlertViewWithMessage:@"请输入您的手机号码"];
        return ;
    }
    
    if([_phone.text length] != 11)
    {
        [self showAlertViewWithMessage:@"手机号码长度不正确"];
        return ;
    }
    
    
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"提交中...";
    NSDictionary * params = @{@"account":_userName.text,@"password":_password.text,@"phone":_phone.text,@"type":_type,@"open_id":_openID};
    [[HttpService sharedInstance] userRegister:params completionBlock:^(BOOL isSuccess) {
        hud.mode = MBProgressHUDModeText;
        if(isSuccess)
        {
            hud.labelText = @"注册成功，请登录";
            [hud hide:YES afterDelay:1.2];
            [self performSelector:@selector(backToLogin) withObject:nil afterDelay:1.4];
        }
        else
        {
            hud.labelText = @"用户名已存在";
        }
        [hud hide:YES afterDelay:1];
    } failureBlock:^(NSError *error, NSString *responseString) {
        hud.labelText = @"注册失败，请重试";
        [hud hide:YES afterDelay:1];
    }];
}

- (void)backToLogin
{
    [self popVIewController];
}

#pragma mark - UITextFieldDelegate Methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == _userName)
    {
        [_password becomeFirstResponder];
        return NO;
    }
    else if(textField == _password)
    {
        [_confirmPwd becomeFirstResponder];
        return NO;
    }
    else if(textField == _confirmPwd)
    {
        [_phone becomeFirstResponder];
        return NO;
    }
    [textField resignFirstResponder];
    return YES;
}


- (void)keyboardShow:(NSNotification *)notification
{
    if(_isShowing) return;
    _isShowing = YES;
    if ([OSHelper iPhone5])
    {
       self.view.frame = CGRectOffset(self.view.frame, 0, -15);
    }
    else
    {
      self.view.frame = CGRectOffset(self.view.frame, 0, -100);
    }
}

- (void)keyboardHide:(NSNotification *)notification
{
    _isShowing = NO;
    if ([OSHelper iPhone5])
    {
        self.view.frame = CGRectOffset(self.view.frame, 0, 15);
    }
    else
    {
        self.view.frame = CGRectOffset(self.view.frame, 0, 100);
    }
}
@end
