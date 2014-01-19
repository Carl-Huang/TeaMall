//
//  MyShoppingCarViewController.m
//  TeaMall
//
//  Created by Vedon on 14-1-13.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "MyShoppingCarViewController.h"
#import "MyCarTableCell.h"
#import "UIViewController+BarItem.h"
@interface MyShoppingCarViewController ()
{
    NSArray * dataSource;
    NSMutableDictionary * itemInfoDic;
}
@end

@implementation MyShoppingCarViewController

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
    dataSource = @[@"1",@"2",@"3",@"4",@"5"];
    itemInfoDic  = [NSMutableDictionary dictionary];
    for (int i =0; i < [dataSource count]; i++) {
        [itemInfoDic setValue:@"0" forKey:[NSString stringWithFormat:@"%d",i]];
    }
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - tableView -
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 113;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifer = @"singleCell";
    MyCarTableCell *cell = (MyCarTableCell*)[tableView dequeueReusableCellWithIdentifier:identifer];
    if (cell == nil)
    {
        cell= (MyCarTableCell *)[[[NSBundle  mainBundle]  loadNibNamed:@"MyCarTableCell" owner:self options:nil]  lastObject];
    }
    NSString * key = [NSString stringWithFormat:@"%d",indexPath.row];
    if ([[itemInfoDic valueForKey:key]isEqualToString:@"1"]) {
        [cell.checkBtn setSelected:YES];
    }else
    {
       [cell.checkBtn setSelected:NO];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return (UITableViewCell *)cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    @autoreleasepool {
        NSString * key = [NSString stringWithFormat:@"%d",indexPath.row];
        NSString * value = [itemInfoDic valueForKey:key];
        
        if ([value isEqualToString:@"0"]) {
            [itemInfoDic setValue:@"1" forKey:key];
        }else
        {
            [itemInfoDic setValue:@"0" forKey:key];
        }
        [tableView reloadData];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)seletedAllItemAction:(id)sender {
    
    UIButton * btn = (UIButton *)sender;
    [btn setSelected:!btn.selected];
    NSArray * allKeys = [itemInfoDic allKeys];
    if (btn.selected) {
        for (NSString * key in allKeys) {
            [itemInfoDic setValue:@"1" forKey:key];
        }
    }else
    {
        for (NSString * key in allKeys) {
            [itemInfoDic setValue:@"0" forKey:key];
        }
    }
    [self.tableView reloadData];
}
@end
