//
//  TeaMarketViewController.m
//  TeaMall
//
//  Created by Carl on 14-1-10.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "TeaMarketViewController.h"
#import "UIViewController+AKTabBarController.h"
#import "AppDelegate.h"
#import "LeftMenuViewController.h"
#import "UINavigationBar+Custom.h"
#import "TeaMarketCell.h"
#import "TeaViewController.h"
static NSString * cellIdentifier = @"cenIdentifier";
@interface TeaMarketViewController ()

@end

@implementation TeaMarketViewController

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
    [self InterfaceInitailization];
    UINib *cellNib = [UINib nibWithNibName:@"TeaMarketCell" bundle:[NSBundle bundleForClass:[TeaMarketCell class]]];
    [self.contentTable registerNib:cellNib forCellReuseIdentifier:cellIdentifier];
    // Do any additional setup after loading the view from its nib.
}

-(void)InterfaceInitailization
{
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"顶三儿-底板"]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"顶三儿-底板"] forBarMetrics:UIBarMetricsDefault];
    
    UIBarButtonItem * searchItem = [self customBarItem:@"分类图标" highLightImageName:@"分类图标(选中状态）" action:@selector(showLeftController:) size:CGSizeMake(50,30)];

    self.navigationItem.leftBarButtonItem = searchItem;
    searchItem  = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)tabImageName
{
	return @"茶叶超市-图标（黑）";
}

- (NSString *)tabTitle
{
	return nil;
}

-(void)showLeftController:(id)sender
{
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [myDelegate toggleLeftMenu];

}

-(void)gotoTeaViewController
{
    TeaViewController * viewController = [[TeaViewController alloc]initWithNibName:@"TeaViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
    viewController = nil;
}
#pragma mark -
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TeaMarketCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.teaImage.image = [UIImage imageNamed:@"关闭交易（选中状态）"];
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self gotoTeaViewController];
}
@end
