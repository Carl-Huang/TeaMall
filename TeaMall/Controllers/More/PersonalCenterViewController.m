//
//  PersonalCenterViewController.m
//  TeaMall
//
//  Created by Carl_Huang on 14-1-12.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "PersonalCenterViewController.h"
#import "UINavigationBar+Custom.h"
#import "MyCollectViewController.h"
#import "MyShoppingCarViewController.h"
#import "MyPublicViewController.h"


@interface PersonalCenterViewController ()

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)myPersonalDataBtnAciton:(id)sender {
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
@end
