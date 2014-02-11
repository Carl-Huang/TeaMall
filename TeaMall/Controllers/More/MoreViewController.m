//
//  MoreViewController.m
//  TeaMall
//
//  Created by Vedon on 14-1-10.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "MoreViewController.h"
#import "UIViewController+AKTabBarController.h"
#import "UINavigationBar+Custom.h"
#import "LoginViewController.h"
#import "PersonalCenterViewController.h"
#import "CustomiseServiceViewController.h"
#import "RegisteredViewController.h"
#import "FeedBackViewController.h"
#import "AboutUsViewController.h"
#import "User.h"
@interface MoreViewController ()

@end

@implementation MoreViewController

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
    self.title = @"更多";
    [self _initUI];
//    [self setLeftCustomBarItem:@"返回" action:nil];
    // Do any additional setup after loading the view from its nib.
}


- (void)_initUI
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"顶三儿-底板"]];
    
//    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
//    back.frame = CGRectMake(0, 0, 40, 30);
//    [back setTitle:@"返回" forState:0];
//    [back setTitleColor:[UIColor whiteColor] forState:0];
//    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc]initWithCustomView:back];
//    self.navigationItem.leftBarButtonItem = backBarButton;
}
- (IBAction)login:(id)sender
{
    LoginViewController *loginViewController = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
    [self.navigationController pushViewController:loginViewController animated:YES];
}

- (IBAction)personalCenter:(id)sender
{
    User * user = [User userFromLocal];
    if(user == nil)
    {
        [self login:nil];
        return ;
    }
    PersonalCenterViewController *viewController = [[PersonalCenterViewController alloc]initWithNibName:@"PersonalCenterViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
    viewController = nil;
}

- (IBAction)team:(id)sender
{
    CustomiseServiceViewController *viewController = [[CustomiseServiceViewController alloc]initWithNibName:@"CustomiseServiceViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
    viewController = nil;
}

- (IBAction)aboutUs:(id)sender
{
    AboutUsViewController *viewController = [[AboutUsViewController alloc]initWithNibName:@"AboutUsViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
    viewController = nil;
}
- (IBAction)versionUpdate:(id)sender
{
    [self showAlertViewWithMessage:@"您的版本已经是最新"];
}
- (IBAction)feedback:(id)sender
{
    FeedBackViewController *viewController = [[FeedBackViewController alloc]initWithNibName:@"FeedBackViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
    viewController = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)tabImageName
{
	return @"更多-图标（黑）";
}

- (NSString *)tabTitle
{
	return nil;
}

@end
