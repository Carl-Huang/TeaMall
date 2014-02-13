//
//  AddAddressViewController.m
//  TeaMall
//
//  Created by Carl on 14-2-13.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "AddAddressViewController.h"
#import "MBProgressHUD.h"
#import "HttpService.h"
#import "User.h"
@interface AddAddressViewController ()<UITextFieldDelegate>

@end

@implementation AddAddressViewController

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
    
    if(self.address)
    {
        _nameField.text = _address.name;
        _phoneField.text = _address.phone;
        _zipField.text = _address.zip;
        _addressField.text = _address.address;
    }
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveAction:)];
    rightItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightItem;
        rightItem = nil;

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)saveAction:(id)sender
{
    [self setEditing:NO];
    [self resignFirstResponder];
    if([_nameField.text length] == 0)
    {
        [self showAlertViewWithMessage:@"请填写收货人的名字"];
        return ;
    }
    
    if([_phoneField.text length] == 0)
    {
        [self showAlertViewWithMessage:@"请填写手机号码"];
        return ;
    }
    
    if([_zipField.text length] == 0)
    {
        [self showAlertViewWithMessage:@"请填写邮政编码"];
        return ;
    }
    
    if([_addressField.text length] == 0)
    {
        [self showAlertViewWithMessage:@"请填写收货地址"];
        return ;
    }
    User * user = [User userFromLocal];
    if(self.address)
    {
        NSDictionary * params = @{@"id":_address.hw_id,@"user_id":user.hw_id,@"name":_nameField.text,@"phone":_phoneField.text,@"zip":_zipField.text,@"address":_addressField.text};
        MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"提交中...";
        [[HttpService sharedInstance] updateAddress:params completionBlock:^(id object) {
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"更新成功";
            [hud hide:YES afterDelay:1];
            _nameField.text = nil;
            _phoneField.text = nil;
            _zipField.text = nil;
            _addressField.text = nil;
            
            
        } failureBlock:^(NSError *error, NSString *responseString) {
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"更新失败,请重试";
            [hud hide:YES afterDelay:1];
        }];
    }
    else
    {
        NSDictionary * params = @{@"user_id":user.hw_id,@"name":_nameField.text,@"phone":_phoneField.text,@"zip":_zipField.text,@"address":_addressField.text};
        MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"提交中...";
        [[HttpService sharedInstance] addAddress:params completionBlock:^(id object) {
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"添加成功";
            [hud hide:YES afterDelay:1];
            _nameField.text = nil;
            _phoneField.text = nil;
            _zipField.text = nil;
            _addressField.text = nil;
            
            
        } failureBlock:^(NSError *error, NSString *responseString) {
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"添加失败,请重试";
            [hud hide:YES afterDelay:1];
        }];

    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == _nameField)
    {
        [_phoneField becomeFirstResponder];
        return NO;
    }
    else if(textField == _phoneField)
    {
        [_zipField becomeFirstResponder];
        return NO;
    }
    else if(textField == _zipField)
    {
        [_addressField becomeFirstResponder];
        return NO;
    }
    [textField resignFirstResponder];
    return YES;
}
@end
