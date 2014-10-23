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
#import "HttpService.h"
#import "AlixLibService.h"
#import "PartnerConfig.h"
#import "DataSigner.h"
#import "AlixPayResult.h"
#import "DataVerifier.h"
#import "AlixPayOrder.h"
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
    _result = @selector(paymentResult:);
    _productNameLabel.text = _commodity.name;
    /*
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
     */
    
    _priceLabel.text = [NSString stringWithFormat:@"￥%@",_commodity.hw__price];
    
    _weightLabel.text = [NSString stringWithFormat:@"%@g",_commodity.weight];
    [_productImageView setImageWithURL:[NSURL URLWithString:_commodity.image]];
    _amountLabel.text = @"1";
    _amountLabel_1.text = @"1件商品";
    _allMoneyLabel.text = [NSString stringWithFormat:@"￥%@",_commodity.hw__price];
    
    
    
    
//    id value = objc_getAssociatedObject(_commodity, &amountKey);
//    _amountLabel.text = [value stringValue];
/*    _amountLabel.text = _amount;
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
 */
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
    NSString * consignee = _consigneeLabel.text?_consigneeLabel.text:@"";
    NSString * phone = _phoneNumberLabel.text;
    NSString * consigneeAddress = _addressTextView.text;
    NSString * zip = @"";
    if(address)
    {
        zip =  address.zip;
    }
    NSString * amount = _amountLabel.text?_amountLabel.text:@"";
    NSString * unit = @"单件";
    NSString * price = _commodity.hw__price?_commodity.hw__price:@"";
    NSString * goodsId = _commodity.hw_id?_commodity.hw_id:@"";
    NSString * goodsName = _commodity.name?_commodity.name:@"";

    NSString  *description;
    
    if ([_commodity.hw_description isEqualToString:@""]) {
        description = nil;
        
    }
    else {
        description = _commodity.description;
    }
    

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

    
    NSDictionary * dic = @{@"user_id":userId,@"order_number":orderNumber,@"status":status,@"goods_id":goodsId,@"goods_name":goodsName,@"goods_price":price,@"amount":amount,@"unit":unit,@"consignee":consignee,@"phone":phone,@"zip":zip,@"address":consigneeAddress,@"total_price":totalMoney,@"hw_description":description};
    
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
        hud.labelText = @"提交成功,请联系客服";
        [hud hide:YES afterDelay:.8];
        [self gotoAliPayWithOrders:orders];
        //[self updateOrderStatus:orderNumber];
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




//wap回调函数
-(void)paymentResult:(NSString *)resultd
{
    //结果处理
#if ! __has_feature(objc_arc)
    AlixPayResult* result = [[[AlixPayResult alloc] initWithString:resultd] autorelease];
#else
    AlixPayResult* result = [[AlixPayResult alloc] initWithString:resultd];
#endif
	if (result)
    {
		
		if (result.statusCode == 9000)
        {
			/*
			 *用公钥验证签名 严格验证请使用result.resultString与result.signString验签
			 */
            
            //交易成功
            NSString* key = AlipayPubKey;//签约帐户后获取到的支付宝公钥
			id<DataVerifier> verifier;
            verifier = CreateRSADataVerifier(key);
            
			if ([verifier verifyString:result.resultString withSign:result.signString])
            {
                //验证签名成功，交易结果无篡改
                NSLog(@"验证签名成功，交易结果无篡改");
			}
        }
        else
        {
            //交易失败
            NSLog(@"交易失败");
        }
    }
    else
    {
        //失败
        NSLog(@"失败");
    }
    
}


- (void)gotoAliPayWithOrders:(NSArray *)orders
{
    if([orders count] == 0)
    {
        [self showAlertViewWithMessage:@"付款失败"];
        NSLog(@"The orders is nil");
        return ;
    }
    
    NSString * appScheme = @"TeaMallApp";
    NSString* orderInfo = [self getOrderInfo:[orders objectAtIndex:0]];
    NSString* signedStr = [self doRsa:orderInfo];
    
    NSLog(@"%@",signedStr);
    
    NSString *orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                             orderInfo, signedStr, @"RSA"];
	NSLog(@"%@",orderString);
    [AlixLibService payOrder:orderString AndScheme:appScheme seletor:_result target:self];
}

-(NSString*)getOrderInfo:(NSDictionary *)order
{
    /*
	 *点击获取prodcut实例并初始化订单信息
	 */
    AlixPayOrder *payorder = [[AlixPayOrder alloc] init];
    payorder.partner = PartnerID;
    payorder.seller = SellerID;
    payorder.tradeNO = [order valueForKey:@"order_number"]; //订单ID（由商家自行制定）
	payorder.productName = [order valueForKey:@"goods_name"]; //商品标题
	payorder.productDescription = [order valueForKey:@"hw_description"]; //商品描述
	payorder.amount = [order valueForKey:@"total_price"]; //商品价格
	payorder.notifyURL =@"http%3A%2F%2Fwwww.xxx.com"; //回调URL
	return [payorder description];
}


-(NSString*)doRsa:(NSString*)orderInfo
{
    id<DataSigner> signer;
    signer = CreateRSADataSigner(PartnerPrivKey);
    NSString *signedString = [signer signString:orderInfo];
    return signedString;
}

-(void)paymentResultDelegate:(NSString *)result
{
    NSLog(@"%@",result);
}
/*
partner="2088611289729353"&
 seller_id="2014053497@qq.com"&
 out_trade_no="A4XQDJX1R3EVMIP"&
 subject=""&
 body="<Commodity: 0x14eb1880>"&
 total_fee="30.00"&
 notify_url="http%3A%2F%2Fwwww.xxx.com"&
 service="mobile.securitypay.pay"
 &_input_charset="utf-8"
 &payment_type="1"
 &return_url="www.xxx.com"
 &it_b_pay="1d"
 &show_url="www.xxx.com"
 */



#pragma mark - UIAlertViewDelegate Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [alertView dismissWithClickedButtonIndex:alertView.cancelButtonIndex animated:YES];
    [self pushAddressVC];
}
@end
