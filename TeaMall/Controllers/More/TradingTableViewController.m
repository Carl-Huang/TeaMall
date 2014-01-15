//
//  TradingTableViewController.m
//  TeaMall
//
//  Created by omi on 14-1-14.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "TradingTableViewController.h"
#import "TradingTableCell.h"

@interface TradingTableViewController ()

@end

@implementation TradingTableViewController

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
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - tableView -
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 180;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifer = @"tradingTableCell";
    TradingTableCell *cell = (TradingTableCell*)[tableView dequeueReusableCellWithIdentifier:identifer];
    if (cell == nil)
    {
        cell= (TradingTableCell *)[[[NSBundle  mainBundle]  loadNibNamed:@"TradingTableCell" owner:self options:nil]  lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return (UITableViewCell *)cell;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
