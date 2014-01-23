//
//  MarketViewController.m
//  TeaMall
//
//  Created by vedon on 13/1/14.
//  Copyright (c) 2014 helloworld. All rights reserved.
//

#import "MarketViewController.h"
#import "UIViewController+AKTabBarController.h"
#import "MarketCell.h"
#import "MarkCellDetailViewController.h"
#import "UINavigationBar+Custom.h"

static NSString * cellIdentifier = @"cellIdentifier";
@interface MarketViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger cellHeight;
}
@end

@implementation MarketViewController

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
    self.title = @"市场行情";
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"顶三儿-底板"]];
    
    [self.priceDownBtn addTarget:self action:@selector(priceDownAction) forControlEvents:UIControlEventTouchUpInside];
    [self.priceUpBtn addTarget:self action:@selector(priceUpAction) forControlEvents:UIControlEventTouchUpInside];
    
    UINib *cellNib = [UINib nibWithNibName:@"MarketCell" bundle:[NSBundle  bundleForClass:[MarketCell class]]];
    [self.contentTable registerNib:cellNib forCellReuseIdentifier:cellIdentifier];
    
    MarketCell * cell = [[[NSBundle mainBundle]loadNibNamed:@"MarketCell" owner:self options:nil]objectAtIndex:0];
    cellHeight = cell.frame.size.height;
    cell = nil;
    
    [self.priceUpBtn setSelected:YES];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)priceDownAction
{
    NSLog(@"%s",__func__);
    [self.priceDownBtn setSelected:YES];
    [self.priceUpBtn setSelected:NO];
    
}

-(void)priceUpAction
{
    NSLog(@"%s",__func__);
    [self.priceUpBtn setSelected:YES];
    [self.priceDownBtn setSelected:NO];

}
#pragma mark - Private Methods
- (NSString *)tabImageName
{
	return @"市场行情-图标（黑）";
}

- (NSString *)tabTitle
{
	return nil;
}

- (void)initUI
{
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return cellHeight;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MarketCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MarkCellDetailViewController * viewController = [[MarkCellDetailViewController alloc]initWithNibName:@"MarkCellDetailViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
    viewController = nil;
     
}

@end
