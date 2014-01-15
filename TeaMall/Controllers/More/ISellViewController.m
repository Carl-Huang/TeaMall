//
//  ISellViewController.m
//  TeaMall
//
//  Created by omi on 14-1-13.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "ISellViewController.h"
#import "ISellCell.h"

@interface ISellViewController ()

@end

@implementation ISellViewController

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
    return 90;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifer = @"iSellCell";
    ISellCell *cell = (ISellCell*)[tableView dequeueReusableCellWithIdentifier:identifer];
    if (cell == nil)
    {
        cell= (ISellCell *)[[[NSBundle  mainBundle]  loadNibNamed:@"ISellCell" owner:self options:nil]  lastObject];
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
