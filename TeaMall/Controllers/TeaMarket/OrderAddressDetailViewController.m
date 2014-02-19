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
#import "User.h"
const NSString * typeKey = @"type";
const NSString * amountKey = @"amount";
@interface OrderAddressDetailViewController ()
@property (nonatomic,strong) User * user;
@end

@implementation OrderAddressDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _user = [User userFromLocal];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setLeftCustomBarItem:@"返回" action:nil];
    _productNameLabel.text = _commodity.name;
    if([_commodityType isEqualToString:@"1"])
    {
        _priceLabel.text = [NSString stringWithFormat:@"￥%@",_commodity.hw__price];
    }
    else if([_commodityType isEqualToString:@"2"])
    {
        _priceLabel.text = [NSString stringWithFormat:@"￥%@",_commodity.price_b];
    }
    else if([_commodityType isEqualToString:@"3"])
    {
        _priceLabel.text = [NSString stringWithFormat:@"￥%@",_commodity.price_p];
    }
    _weightLabel.text = [NSString stringWithFormat:@"%@g",_commodity.weight];
    [_productImageView setImageWithURL:[NSURL URLWithString:_commodity.image]];
//    id value = objc_getAssociatedObject(_commodity, &amountKey);
//    _amountLabel.text = [value stringValue];
    _amountLabel.text = _amount;
    _amountLabel_1.text = [NSString stringWithFormat:@"%@件商品",_amount];
    float price = [_commodity.hw__price floatValue];
    if ([_commodityType isEqualToString:@"2"])
    {
        price = [_commodity.price_b floatValue];
    }
    else if ([_commodityType isEqualToString:@"3"])
    {
        price = [_commodity.price_p floatValue];
    }
    
    float allMoney = price * [_amount intValue];
    _allMoneyLabel.text = [NSString stringWithFormat:@"￥%0.2f",allMoney];
    
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
    
    float price = [_commodity.hw__price floatValue];
    if ([_commodityType isEqualToString:@"2"])
    {
        price = [_commodity.price_b floatValue];
    }
    else if ([_commodityType isEqualToString:@"3"])
    {
        price = [_commodity.price_p floatValue];
    }
    
    float allMoney = price * amount;
    _allMoneyLabel.text = [NSString stringWithFormat:@"￥%f",allMoney];
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
    float price = [_commodity.hw__price floatValue];
    if ([_commodityType isEqualToString:@"2"])
    {
        price = [_commodity.price_b floatValue];
    }
    else if ([_commodityType isEqualToString:@"3"])
    {
        price = [_commodity.price_p floatValue];
    }
    
    float allMoney = price * amount;
    _allMoneyLabel.text = [NSString stringWithFormat:@"￥%f",allMoney];

}
@end
