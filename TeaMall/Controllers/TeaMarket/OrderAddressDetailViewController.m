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
#import "MyAddressViewController.h"
#import <objc/runtime.h>
#import "User.h"
#import "Address.h"
const NSString * typeKey = @"type";
const NSString * amountKey = @"amount";
@interface OrderAddressDetailViewController ()<UIAlertViewDelegate>
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    Address * address = [Address addressFromLocal];
    if(address == nil)
    {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil message:@"您还没有添加默认的收货地址." delegate:self cancelButtonTitle:@"去添加" otherButtonTitles:nil, nil];
        [alertView show];
        alertView = nil;
    }
    else
    {
        _consigneeLabel.text = address.name;
        _phoneNumberLabel.text = address.phone;
        _addressTextView.text = address.address;
    }
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
    _allMoneyLabel.text = [NSString stringWithFormat:@"￥%0.2f",allMoney];
    _amountLabel_1.text = [NSString stringWithFormat:@"%i件商品",amount];
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
    _allMoneyLabel.text = [NSString stringWithFormat:@"￥%0.2f",allMoney];
    _amountLabel_1.text = [NSString stringWithFormat:@"%i件商品",amount];

}

- (IBAction)changeAddressAction:(id)sender
{
    [self pushAddressVC];
}


- (void)pushAddressVC
{
    MyAddressViewController * vc = [[MyAddressViewController alloc] initWithNibName:nil bundle:nil];
    [self push:vc];
    vc = nil;
}
#pragma mark - UIAlertViewDelegate Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [alertView dismissWithClickedButtonIndex:alertView.cancelButtonIndex animated:YES];
    [self pushAddressVC];
}
@end
