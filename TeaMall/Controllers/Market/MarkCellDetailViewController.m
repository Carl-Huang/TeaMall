//
//  MarkCellDetailViewController.m
//  TeaMall
//
//  Created by vedon on 15/1/14.
//  Copyright (c) 2014 helloworld. All rights reserved.
//

#import "MarkCellDetailViewController.h"
#import "CycleScrollView.h"
#import "UIViewController+BarItem.h"
#import "CustomiseServiceViewController.h"
static NSString * cellIdentifier = @"cellIdentifier";
@interface MarkCellDetailViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation MarkCellDetailViewController

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
#ifdef iOS7_SDK
    if ([OSHelper iOS7]) {
        self.contentTable.separatorInset = UIEdgeInsetsZero;
    }
#endif
    [self setLeftCustomBarItem:@"返回" action:nil];
    //顶部的滚动图片
    NSArray * tempArray = @[[UIImage imageNamed:@"广告1"],[UIImage imageNamed:@"广告1"],[UIImage imageNamed:@"整桶（选中状态）"]];
    CGRect tempScrollViewRect = CGRectMake(0, 0, 320, self.productScrollView.frame.size.height);
    CycleScrollView *scrollView = [[CycleScrollView alloc]initWithFrame:tempScrollViewRect
                                                         cycleDirection:CycleDirectionLandscape
                                                               pictures:tempArray
                                                             autoScroll:YES];
    [self.productScrollView addSubview:scrollView];
    scrollView = nil;

    // Do any additional setup after loading the view from its nib.
}

-(void)viewDidDisappear:(BOOL)animated
{
    for (UIView * view in self.productScrollView.subviews) {
        if ([view isKindOfClass:[CycleScrollView class]]) {
            CycleScrollView * cycleView = (CycleScrollView *)view;
            if ([cycleView.timer isValid]) {
                [cycleView.timer invalidate];
            }
        }
    }
    self.productScrollView = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
    }
    
    if(indexPath.row == 0)
    {
        cell.textLabel.text = @"【品名】";
    }
    else if(indexPath.row == 1)
    {
        cell.textLabel.text = @"【生产工艺】";
    }
    else if(indexPath.row == 2)
    {
        cell.textLabel.text = @"【规格】";
    }
    else if(indexPath.row == 3)
    {
        cell.textLabel.text = @"【配料】";
    }
    else if(indexPath.row == 4)
    {
        cell.textLabel.text = @"【生产日期】";
    }
    else if(indexPath.row == 5)
    {
        cell.textLabel.text = @"【出品商】";
    }
    else
    {
        cell.textLabel.text = @"【储存方式】";
    }
    
    return cell;
}

- (IBAction)callAction:(id)sender
{
    CustomiseServiceViewController * vc = [[CustomiseServiceViewController alloc] initWithNibName:nil bundle:nil];
    [self push:vc];
    vc = nil;
}
@end
