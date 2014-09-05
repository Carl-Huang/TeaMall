//
//  PersonalCenterViewController.m
//  TeaMall
//
//  Created by Vedon on 16-1-12.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "PersonalCenterViewController.h"
#import "UINavigationBar+Custom.h"
#import "MyCollectViewController.h"
#import "MyShoppingCarViewController.h"
#import "MyPublicViewController.h"
#import "UIViewController+BarItem.h"
#import "PersonalInfoViewController.h"
#import "MyAddressViewController.h"
#import "UIImageView+WebCache.h"
#import "Constants.h"
#import <QuartzCore/QuartzCore.h>
#import "User.h"
#import "myBidViewController.h"



@interface PersonalCenterViewController ()
{
    NSMutableArray *_products;
    User * _user;
}
@end

@implementation PersonalCenterViewController

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

    _photeImageView.layer.cornerRadius = 10.0;
    _photeImageView.layer.masksToBounds = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //NSURL * URL = [IO URLForResource:Avatar_Name inDirectory:Image_Path];
//    if([IO isFileExistAtPath:[URL path]])
//    {
//        _photeImageView.image = [UIImage imageWithContentsOfFile:[URL path]];
//    }
    _user = [User userFromLocal];
    _userNameLabel.text = _user.account;
    if(_user.avatar)
    {
        [_photeImageView setImageWithURL:[NSURL URLWithString:_user.avatar]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)myPersonalDataBtnAciton:(id)sender
{
    PersonalInfoViewController * vc = [[PersonalInfoViewController alloc] initWithNibName:nil bundle:nil];
    [self push:vc];
    vc = nil;
}

- (IBAction)MyPublicBtnAction:(id)sender {
    MyPublicViewController *viewController = [[MyPublicViewController alloc]initWithNibName:@"MyPublicViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
    viewController = nil;
}

- (IBAction)MyCollectBtnAction:(id)sender {
    MyCollectViewController *viewController = [[MyCollectViewController alloc]initWithNibName:@"MyCollectViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
    viewController = nil;
}

- (IBAction)myShoppingCarBtnAction:(id)sender {
    MyShoppingCarViewController *viewController = [[MyShoppingCarViewController alloc]initWithNibName:@"MyShoppingCarViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
    viewController = nil;
}

- (IBAction)showAddressAction:(id)sender
{
    MyAddressViewController * vc = [[MyAddressViewController alloc] initWithNibName:nil bundle:nil];
    [self push:vc];
    vc = nil;
}

- (IBAction)myBidBtnAction:(id)sender {
    myBidViewController * vc = [[myBidViewController alloc] initWithNibName:nil bundle:nil];
    [self push:vc];
    vc = nil;
}

- (IBAction)ZhifubaoAction:(id)sender
{
    
}



@end
