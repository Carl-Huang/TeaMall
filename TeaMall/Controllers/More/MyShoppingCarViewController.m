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
#import "TeaCommodity.h"
#import "PersistentStore.h"
#import "UIImageView+WebCache.h"
@interface MyShoppingCarViewController ()
{
    NSMutableArray * dataSource;
}
@end

@implementation MyShoppingCarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        dataSource = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect rect = self.view.frame;
    if(![OSHelper iPhone5])
    {
        rect.size.height = 367;
        [self.view setFrame:rect];
    }

    [self setLeftCustomBarItem:@"返回" action:nil];
    //dataSource = [PersistentStore getAllObjectWithType:[TeaCommodity class]];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    dataSource = [NSMutableArray arrayWithArray:[PersistentStore getAllObjectWithType:[TeaCommodity class]]];
    [_tableView reloadData];
    [self reCalculate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    _tableView.delegate = nil;
    _tableView.dataSource = nil;
    _tableView = nil;
    dataSource = nil;
    _allMoneyLabel = nil;
    [self setView:nil];
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
    
    TeaCommodity * teaCommodity = [dataSource objectAtIndex:indexPath.row];
    [cell.commodityImageView setImageWithURL:[NSURL URLWithString:teaCommodity.image]];
    cell.commodityNameLabel.text = teaCommodity.name;
    cell.currentPriceLabel.text = [NSString stringWithFormat:@"￥%@",teaCommodity.hw__price];
    cell.amountLabel.text = [NSString stringWithFormat:@"x%@",teaCommodity.amount];
    cell.priceLabel_1.text = [NSString stringWithFormat:@"￥%@",teaCommodity.hw__price];
    cell.priceLabel_2.text = [NSString stringWithFormat:@"￥%@",teaCommodity.price_b];
    cell.priceLabel_3.text = [NSString stringWithFormat:@"￥%@",teaCommodity.price_p];
    float money = [teaCommodity.amount intValue] * [teaCommodity.hw__price floatValue];
    cell.allMoneyLabel.text = [NSString stringWithFormat:@"￥%0.2f",money];

    [cell.checkBtn addTarget:self action:@selector(checkAction:) forControlEvents:UIControlEventTouchUpInside];
    if ([teaCommodity.selected isEqualToString:@"1"]) {
        [cell.checkBtn setSelected:YES];
    }else
    {
       [cell.checkBtn setSelected:NO];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return (UITableViewCell *)cell;
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    @autoreleasepool {
        TeaCommodity * teaCommodity = [dataSource objectAtIndex:indexPath.row];
        
        if ([teaCommodity.selected isEqualToString:@"0"]) {
            teaCommodity.selected = @"1";
        }else
        {
            teaCommodity.selected = @"0";
        }
        [[NSManagedObjectContext MR_defaultContext]MR_saveOnlySelfAndWait];
        [tableView reloadData];
        [self reCalculate];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    TeaCommodity * teaCommodity = [dataSource objectAtIndex:indexPath.row];
    [PersistentStore deleteObje:teaCommodity];
    [dataSource removeObject:teaCommodity];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    [self reCalculate];
    //dataSource = [PersistentStore getAllObjectWithType:[TeaCommodity class]];
    //[tableView reloadData];
    
}


- (IBAction)seletedAllItemAction:(id)sender {
    
    UIButton * btn = (UIButton *)sender;
    [btn setSelected:!btn.selected];
    NSString * isSelected;
    
    if (btn.selected) {
        isSelected = @"1";
    }else
    {
        isSelected = @"0";
    }
    
    for(TeaCommodity * teaCommodity in dataSource)
    {
        teaCommodity.selected = isSelected;
    }
    
    [[NSManagedObjectContext MR_defaultContext]MR_saveOnlySelfAndWait];
    [self.tableView reloadData];
}

- (void)checkAction:(UIButton *)button
{
    @autoreleasepool {
        MyCarTableCell * cell ;
        if([button.superview.superview isKindOfClass:[MyCarTableCell class]])
        {
            cell = (MyCarTableCell *)button.superview.superview;
        }
        else if([button.superview.superview.superview isKindOfClass:[MyCarTableCell class]])
        {
            cell = (MyCarTableCell *)button.superview.superview.superview;
        }
        else
        {
            return ;
        }
        NSIndexPath * indexPath = [_tableView indexPathForCell:cell];
        TeaCommodity * teaCommodity = [dataSource objectAtIndex:indexPath.row];
        
        if ([teaCommodity.selected isEqualToString:@"0"]) {
            teaCommodity.selected = @"1";
        }else
        {
            teaCommodity.selected = @"0";
        }
        [[NSManagedObjectContext MR_defaultContext]MR_saveOnlySelfAndWait];
        [_tableView reloadData];
    }
}

- (void)reCalculate
{
    if([dataSource count] == 0) return;
    float allMoney = 0.00f;
    for(TeaCommodity * teaCommodity in dataSource)
    {
        if([teaCommodity.selected isEqualToString:@"0"])
        {
            continue ;
        }
        
        float money = [teaCommodity.hw__price floatValue] * [teaCommodity.amount intValue];
        allMoney += money;
    }
    
    _allMoneyLabel.text = [NSString stringWithFormat:@"￥%0.2f元",allMoney];
}
@end
