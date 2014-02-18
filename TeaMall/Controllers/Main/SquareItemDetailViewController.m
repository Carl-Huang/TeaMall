//
//  SquareItemDetailViewController.m
//  TeaMall
//
//  Created by vedon on 13/1/14.
//  Copyright (c) 2014 helloworld. All rights reserved.
//

#import "SquareItemDetailViewController.h"
#import "starView.h"
#import "UIViewController+BarItem.h"
#import "CustomiseServiceViewController.h"
@interface SquareItemDetailViewController ()

@end

@implementation SquareItemDetailViewController

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
    [self.littleStarView setStarNum:5];
    [self setLeftCustomBarItem:@"返回" action:nil];
    _userName.text = _publish.account;
    _description.text = _publish.name;
    _transactionNum.text = _publish.business_number;
    NSString * publishDate = [[NSDate dateFromString:_publish.publish_time withFormat:@"yyyy-MM-dd hh:mm:ss"] formatDateString:@"yyyy-MM-dd"];
    _transactionDate.text = publishDate;
    _productNameLabel.text = _publish.name;
    _priceLabel.text = [NSString stringWithFormat:@"￥%@",_publish.price];
    _brandLabel.text = _publish.brand;
    _amountLabel.text = _publish.amount;
    if([_publish.is_buy isEqualToString:@"0"])
    {
        _transactionType.text = @"我要卖";
    }
    else
    {
        _transactionType.text = @"我要买";
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)contactCustomerServiceAction:(id)sender
{
    [self gotoContactServiceViewController];
}

-(void)gotoContactServiceViewController
{
    CustomiseServiceViewController * viewController = [[CustomiseServiceViewController alloc]initWithNibName:@"CustomiseServiceViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
    viewController = nil;
}
@end
