//
//  OrderAddressDetailViewController.m
//  TeaMall
//
//  Created by vedon on 15/1/14.
//  Copyright (c) 2014 helloworld. All rights reserved.
//

#import "OrderAddressDetailViewController.h"
#import "UIViewController+BarItem.h"
#import "UIImageView+AFNetworking.h"
#import <objc/runtime.h>
const NSString * typeKey = @"type";
const NSString * amountKey = @"amount";
@interface OrderAddressDetailViewController ()

@end

@implementation OrderAddressDetailViewController

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
    _productNameLabel.text = _commodity.name;
    _priceLabel.text = [NSString stringWithFormat:@"￥%@",_commodity.hw__price];
    _weightLabel.text = [NSString stringWithFormat:@"%@g",_commodity.weight];
    [_productImageView setImageWithURL:[NSURL URLWithString:_commodity.image]];
    id value = objc_getAssociatedObject(_commodity, &amountKey);
    _amountLabel.text = [value stringValue];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addAmountAction:(id)sender
{
    int amount = [_amountLabel.text intValue];
    if(amount == [_commodity.stock intValue])
    {
        [self showAlertViewWithMessage:@"库存不足"];
        return ;
    }
    amount += 1;
    _amountLabel.text = [NSString stringWithFormat:@"%i",amount];
}

- (IBAction)reduceAmountAction:(id)sender
{
    int amount = [_amountLabel.text intValue];
    if(amount == 1)
    {
        return ;
    }
    amount -= 1;
    _amountLabel.text = [NSString stringWithFormat:@"%i",amount];
}
@end
