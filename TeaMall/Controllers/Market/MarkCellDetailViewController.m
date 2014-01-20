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
    if ([OSHelper iOS7]) {
        self.contentTable.separatorInset = UIEdgeInsetsZero;
    }
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
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    return cell;
}

@end
