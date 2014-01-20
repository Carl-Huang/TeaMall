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
@interface LoginViewController ()

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
- (IBAction)loginAction:(id)sender {
}
@end
