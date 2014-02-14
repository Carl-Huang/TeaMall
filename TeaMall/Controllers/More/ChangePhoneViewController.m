//
//  ChangePhoneViewController.m
//  TeaMall
//
//  Created by Carl on 14-2-12.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "ChangePhoneViewController.h"
#import "User.h"
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
    if([_phoneField.text length] == 0)
    {
        [self showAlertViewWithMessage:@"请输入您的手机号码"];
        return ;
    }
    
    _user.phone = _phoneField.text;
    [User saveToLocal:_user];
    [self popVIewController];
}


@end
