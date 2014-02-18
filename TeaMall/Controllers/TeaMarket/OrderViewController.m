//
//  OrderViewController.m
//  TeaMall
//
//  Created by vedon on 15/1/14.
//  Copyright (c) 2014 helloworld. All rights reserved.
//

#import "OrderViewController.h"
#import "UIViewController+BarItem.h"
#import "OrderAddressDetailViewController.h"
#import "UIImageView+AFNetworking.h"
@interface OrderViewController ()

@end

@implementation OrderViewController

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
    _productName.text = _commodity.name;
    _priceLabel.text = [NSString stringWithFormat:@"￥%@",_commodity.hw__price];
    _weightLabel.text = [NSString stringWithFormat:@"%@g",_commodity.weight];
    [_productImageView setImageWithURL:[NSURL URLWithString:_commodity.image]];
    [_priceBtn_1 setTitle:[NSString stringWithFormat:@"￥%@",_commodity.hw__price] forState:UIControlStateNormal];
    [_priceBtn_2 setTitle:[NSString stringWithFormat:@"￥%@",_commodity.price] forState:UIControlStateNormal];
    [_priceBtn_3 setTitle:[NSString stringWithFormat:@"￥%@",_commodity.price] forState:UIControlStateNormal];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)comfirmAction:(id)sender {
    OrderAddressDetailViewController * viewController = [[OrderAddressDetailViewController alloc]initWithNibName:@"OrderAddressDetailViewController" bundle:nil];
    [self.navigationController pushViewController: viewController animated:YES];
    viewController = nil;
}

- (IBAction)addAmountAction:(id)sender
{
    int amount = [_amountLabel.text intValue];
}

- (IBAction)reduceAmountAction:(id)sender
{
    
}
@end
