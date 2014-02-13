//
//  ChangeNameViewController.m
//  TeaMall
//
//  Created by Carl on 14-2-12.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "ChangeNameViewController.h"
#import "User.h"
@interface ChangeNameViewController ()
@property (nonatomic,strong) User * user;
@end

@implementation ChangeNameViewController

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
    _nameField.text = _user.account;
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
    if([_nameField.text length] == 0)
    {
        [self showAlertViewWithMessage:@"请输入您的用户名"];
        return ;
    }
    
    _user.account = _nameField.text;
    [User saveToLocal:_user];
    [self popVIewController];
}

@end
