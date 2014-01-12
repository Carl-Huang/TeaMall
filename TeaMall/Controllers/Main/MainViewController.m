//
//  MainViewController.m
//  TeaMall
//
//  Created by Carl on 14-1-10.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "MainViewController.h"
#import "UIViewController+AKTabBarController.h"
#import "UINavigationBar+Custom.h"
#import "HWSDK.h"
@interface MainViewController ()

@end

@implementation MainViewController
#pragma mark - Life Cycle
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
    [self initUI];
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

#pragma mark - Private Methods
- (NSString *)tabImageName
{
	return @"首页-图标（黑）";
}

- (NSString *)tabTitle
{
	return nil;
}

- (void)initUI
{
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"顶三儿-底板"]];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    UIBarButtonItem * flexBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem * searchItem = [self customBarItem:@"顶三儿-搜索（黑）" highLightImageName:@"顶三儿-搜索（白）" action:nil size:CGSizeMake(20,30)];
    UIImageView * pointImageView_1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 12, 4)];
    pointImageView_1.image = [UIImage imageNamed:@"两点"];
    UIImageView * pointImageView_2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 12, 4)];
    pointImageView_2.image = [UIImage imageNamed:@"两点副本"];
    UIBarButtonItem * pointItem_1 = [[UIBarButtonItem alloc] initWithCustomView:pointImageView_1];
    UIBarButtonItem * pointItem_2 = [[UIBarButtonItem alloc] initWithCustomView:pointImageView_2];
    UIBarButtonItem * squareItem = [self customBarItem:@"顶三儿-广场（黑）" highLightImageName:@"顶三儿-广场（白）" action:nil size:CGSizeMake(20,30)];
    UIBarButtonItem * publicItem = [self customBarItem:@"顶三儿-发布（黑）" highLightImageName:@"顶三儿-发布（白）" action:nil size:CGSizeMake(20, 35)];
    self.navigationItem.leftBarButtonItems = @[flexBarItem,searchItem,flexBarItem,pointItem_1,flexBarItem,squareItem,flexBarItem,pointItem_2,flexBarItem,publicItem,flexBarItem];
    

}

@end
