//
//  MoreViewController.m
//  TeaMall
//
//  Created by Carl on 14-1-10.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "MoreViewController.h"
#import "UIViewController+AKTabBarController.h"
#import "UINavigationBar+Custom.h"
#import "LoginViewController.h"
#import "PersonalCenterViewController.h"
#import "TeamViewController.h"
#import "RegisteredViewController.h"
#import "ISellViewController.h"
#import "TableViewController.h"
#import "TradingTableViewController.h"
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
    [self _initUI];
    // Do any additional setup after loading the view from its nib.
}


- (void)_initUI
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"顶三儿-底板"]];
    
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(0, 0, 40, 30);
    [back setTitle:@"返回" forState:0];
    [back setTitleColor:[UIColor whiteColor] forState:0];
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc]initWithCustomView:back];
    self.navigationItem.leftBarButtonItem = backBarButton;
}
- (IBAction)login:(id)sender
{
    LoginViewController *loginViewController = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
    [self.navigationController pushViewController:loginViewController animated:YES];
}

- (IBAction)personalCenter:(id)sender
{
    PersonalCenterViewController *personalCenterVC = [[PersonalCenterViewController alloc]initWithNibName:@"PersonalCenterViewController" bundle:nil];
    [self.navigationController pushViewController:personalCenterVC animated:YES];
}

- (IBAction)team:(id)sender
{
    TeamViewController *teamViewController = [[TeamViewController alloc]initWithNibName:@"TeamViewController" bundle:nil];
    [self.navigationController pushViewController:teamViewController animated:YES];
}

- (IBAction)aboutUs:(id)sender
{
    ISellViewController *iSellViewController = [[ISellViewController alloc]initWithNibName:@"ISellViewController" bundle:nil];
    [self.navigationController pushViewController:iSellViewController animated:YES];
}
- (IBAction)versionUpdate:(id)sender
{
    TableViewController *tableViewController = [[TableViewController alloc]initWithNibName:@"TableViewController" bundle:nil];
    [self.navigationController pushViewController:tableViewController animated:YES];
}
- (IBAction)feedback:(id)sender
{
    TradingTableViewController *tradingTableViewController = [[TradingTableViewController alloc]initWithNibName:@"TradingTableViewController" bundle:nil];
    [self.navigationController pushViewController:tradingTableViewController animated:YES];
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
