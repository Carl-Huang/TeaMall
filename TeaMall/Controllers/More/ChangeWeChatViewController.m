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
    [self setLeftCustomBarItem:@"返回" action:@selector(goBack:)];
    _user = [User userFromLocal];
    _wechatField.text = _user.phone;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)goBack:(id)sender
{
    [self popVIewController];
}

@end
