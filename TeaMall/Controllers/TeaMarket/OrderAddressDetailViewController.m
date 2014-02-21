//
//  OrderAddressDetailViewController.m
//  TeaMall
//
//  Created by vedon on 15/1/14.
//  Copyright (c) 2014 helloworld. All rights reserved.
//

#import "OrderAddressDetailViewController.h"
#import "UIViewController+BarItem.h"
#import "UIImageView+WebCache.h"
#import "MyAddressViewController.h"
#import <objc/runtime.h>
#import "User.h"
#import "Address.h"
#import "MBProgressHUD.h"
#import <HttpService.h>
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

- (IBAction)commitOrderAction:(id)sender
{
    if([_consigneeLabel.text length] == 0)
    {
        [self showAlertViewWithMessage:@"收货人不能为空."];
        return ;
    }
    
    if([_phoneNumberLabel.text length] == 0)
    {
        [self showAlertViewWithMessage:@"手机号码不能为空."];
        return ;
    }
    
    if([_addressTextView.text length] == 0)
    {
        [self showAlertViewWithMessage:@"收货地址不能为空."];
        return ;
    }
    
    Address * address = [Address addressFromLocal];
    NSString * userId = _user.hw_id;
    NSString * status = @"0";
    NSString * orderNumber = [NSString generateTradeNO];
    NSString * consignee = _consigneeLabel.text;
    NSString * phone = _phoneNumberLabel.text;
    NSString * consigneeAddress = _addressTextView.text;
    NSString * zip = @"";
    if(address)
    {
        zip =  address.zip;
    }
    NSString * amount = _amountLabel.text;
    NSString * unit = @"单件";
    NSString * price = _commodity.hw__price;
    NSString * goodsId = _commodity.hw_id;
    NSString * goodsName = _commodity.name;
    if([_commodityType isEqualToString:@"2"])
    {
        unit = @"整桶";
        price = _commodity.price_b;
    }
    else if([_commodityType isEqualToString:@"3"])
    {
        unit = @"整件";
        price = _commodity.price_p;
    }
    
    float menoy = [amount intValue] * [price floatValue];
    NSString * totalMoney = [NSString stringWithFormat:@"%0.2f",menoy];
    
    NSDictionary * dic = @{@"user_id":userId,@"order_number":orderNumber,@"status":status,@"goods_id":goodsId,@"goods_name":goodsName,@"goods_price":price,@"amount":amount,@"unit":unit,@"consignee":consignee,@"phone":phone,@"zip":zip,@"address":consigneeAddress,@"total_price":totalMoney};
    
    NSArray * orders = @[dic];
    NSError * error;
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:orders options:NSJSONWritingPrettyPrinted error:&error];
    if(error != nil)
    {
        NSLog(@"%@",error);
        [self showAlertViewWithMessage:@"提交失败,请重试"];
        return ;
    }
    NSString * jsonString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
    NSLog(@"%@",jsonString);
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在提交订单";
    [[HttpService sharedInstance] addOrder:@{@"order":jsonString} completionBlock:^(id object) {
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"提交成功,正在跳转到支付宝";
        [hud hide:YES afterDelay:.8];
        [self updateOrderStatus:orderNumber];
    } failureBlock:^(NSError *error, NSString *responseString) {
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"提交订单失败";
        [hud hide:YES afterDelay:1];
    }];
    
}


- (void)updateOrderStatus:(NSString *)orderNumber;
{
    //NSLog(@"%@",orderNumber);
    [[HttpService sharedInstance] updateOrder:@{@"order_number":orderNumber,@"status":@"1"} completionBlock:^(id object) {
        NSLog(@"success");
    } failureBlock:^(NSError *error, NSString *responseString) {
        NSLog(@"failure");
    }];
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
