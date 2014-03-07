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
#import "Address.h"
#import "User.h"
#import "MBProgressHUD.h"
#import "HttpService.h"
#import "AlixLibService.h"
#import "PartnerConfig.h"
#import "DataSigner.h"
#import "AlixPayResult.h"
#import "DataVerifier.h"
#import "AlixPayOrder.h"
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
    _result = @selector(paymentResult:);
    CGRect rect = self.view.frame;
    if(![OSHelper iPhone5])
    {
        rect.size.height = 367;
        [self.view setFrame:rect];
        CGRect tableRect = self.tableView.frame;
        tableRect.size.height = 327;
        _tableView.frame = tableRect;
        _bottomView.frame = CGRectMake(0, 327, 320, 40);
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
#pragma mark - TableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 133;
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
    NSLog(@"%@",teaCommodity.unit);
    /*
    if([teaCommodity.unit isEqualToString:@"1"])
    {
        [cell.priceBtn_1 setBackgroundImage:[UIImage imageNamed:@"单位框（选中状态）.png"] forState:UIControlStateNormal];
        [cell.priceBtn_2 setBackgroundImage:[UIImage imageNamed:@"单位框（未选中状态）.png"] forState:UIControlStateNormal];
        [cell.priceBtn_3 setBackgroundImage:[UIImage imageNamed:@"单位框（未选中状态）.png"] forState:UIControlStateNormal];
        cell.priceBtn_1.enabled = YES;
        cell.priceBtn_2.enabled = NO;
        cell.priceBtn_3.enabled = NO;
    }
    else if([teaCommodity.unit isEqualToString:@"2"])
    {
        [cell.priceBtn_1 setBackgroundImage:[UIImage imageNamed:@"单位框（未选中状态）.png"] forState:UIControlStateNormal];
        [cell.priceBtn_2 setBackgroundImage:[UIImage imageNamed:@"单位框（选中状态）.png"] forState:UIControlStateNormal];
        [cell.priceBtn_3 setBackgroundImage:[UIImage imageNamed:@"单位框（未选中状态）.png"] forState:UIControlStateNormal];
        cell.priceBtn_1.enabled = NO;
        cell.priceBtn_2.enabled = YES;
        cell.priceBtn_3.enabled = NO;


    }
    else if([teaCommodity.unit isEqualToString:@"3"])
    {
        [cell.priceBtn_1 setBackgroundImage:[UIImage imageNamed:@"单位框（未选中状态）.png"] forState:UIControlStateNormal];
        [cell.priceBtn_2 setBackgroundImage:[UIImage imageNamed:@"单位框（未选中状态）.png"] forState:UIControlStateNormal];
        [cell.priceBtn_3 setBackgroundImage:[UIImage imageNamed:@"单位框（选中状态）.png"] forState:UIControlStateNormal];
        cell.priceBtn_1.enabled = NO;
        cell.priceBtn_2.enabled = NO;
        cell.priceBtn_3.enabled = YES;

        
    }
    else
    {
        [cell.priceBtn_1 setBackgroundImage:[UIImage imageNamed:@"单位框（未选中状态）.png"] forState:UIControlStateNormal];
        [cell.priceBtn_2 setBackgroundImage:[UIImage imageNamed:@"单位框（未选中状态）.png"] forState:UIControlStateNormal];
        [cell.priceBtn_3 setBackgroundImage:[UIImage imageNamed:@"单位框（未选中状态）.png"] forState:UIControlStateNormal];
        cell.priceBtn_1.enabled = NO;
        cell.priceBtn_2.enabled = NO;
        cell.priceBtn_3.enabled = NO;
    }
    
    */
    cell.priceBtn_1.enabled = NO;
    cell.priceBtn_2.enabled = NO;
    cell.priceBtn_3.enabled = NO;
    
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


- (IBAction)buyAction:(id)sender
{
    if([dataSource count] == 0) return;
    int amount = 0;
    for(TeaCommodity * teaCommodity in dataSource)
    {
        if([teaCommodity.selected isEqualToString:@"1"])
        {
            amount += 1;
        }
    }
    
    if(amount == 0)
    {
        [self showAlertViewWithMessage:@"请选择商品!"];
        return ;
    }
    
    Address * address = [Address addressFromLocal];
    if(address == nil)
    {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil message:@"您还没有添加默认的收货地址." delegate:self cancelButtonTitle:@"去添加" otherButtonTitles:nil, nil];
        [alertView show];
        alertView = nil;
    }
    NSString * orderNumber = [NSString generateTradeNO];
    User * user = [User userFromLocal];
    NSMutableArray * orders = [NSMutableArray array];
    for(TeaCommodity * teaCommodity in dataSource)
    {
        if(![teaCommodity.selected isEqualToString:@"1"])
        {
            continue ;
        }
        NSMutableDictionary * order = [NSMutableDictionary dictionary];
        [order setValue:user.hw_id forKey:@"user_id"];
        [order setValue:orderNumber forKey:@"order_number"];
        [order setValue:@"0" forKey:@"status"];
        [order setValue:teaCommodity.hw_id forKey:@"goods_id"];
        [order setValue:teaCommodity.name forKey:@"goods_name"];
        //[order setValue:teaCommodity.hw__price forKey:@"goods_price"];
        [order setValue:teaCommodity.amount forKey:@"amount"];
        NSString * unit = @"单件";
        NSString * price = teaCommodity.hw__price;
        if([teaCommodity.unit isEqualToString:@"2"])
        {
            unit = @"整桶";
            price = teaCommodity.price_b;
        }
        else if ([teaCommodity.unit isEqualToString:@"3"])
        {
           unit = @"整件";
            price = teaCommodity.price_p;
        }
        [order setValue:price forKey:@"goods_price"];
        [order setValue:unit forKey:@"unit"];
        [order setValue:address.name forKey:@"consignee"];
        [order setValue:address.phone forKey:@"phone"];
        [order setValue:address.zip forKey:@"zip"];
        [order setValue:address.address forKey:@"address"];
        float totalMoney = [teaCommodity.amount intValue] * [price floatValue];
        [order setValue:[NSString stringWithFormat:@"%0.2f",totalMoney] forKey:@"total_Money"];
        [orders addObject:order];
    }
    
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
        
        [self deleteAllCommodity];
        
        [self gotoAliPayWithOrders:orders];
        
    } failureBlock:^(NSError *error, NSString *responseString) {
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"提交订单失败";
        [hud hide:YES afterDelay:1];
    }];
    
}


- (void)deleteAllCommodity
{
    for(TeaCommodity * teaCommodity in dataSource)
    {
        [PersistentStore deleteObje:teaCommodity];
    }
    dataSource = [NSMutableArray arrayWithArray:[PersistentStore getAllObjectWithType:[TeaCommodity class]]];
    [_tableView reloadData];
    [self reCalculate];
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
        [self reCalculate];
    }
}

- (void)reCalculate
{
    //if([dataSource count] == 0) return;
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



#pragma mark - 支付部分

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
    NSString* orderInfo = [self getOrderInfo:orders];
    NSString* signedStr = [self doRsa:orderInfo];
    
    NSLog(@"%@",signedStr);
    
    NSString *orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                             orderInfo, signedStr, @"RSA"];
	
    [AlixLibService payOrder:orderString AndScheme:appScheme seletor:_result target:self];
}

-(NSString*)getOrderInfo:(NSArray *)orders
{
    /*
	 *点击获取prodcut实例并初始化订单信息
	 */
    AlixPayOrder *payorder = [[AlixPayOrder alloc] init];
    payorder.partner = PartnerID;
    payorder.seller = SellerID;
    payorder.tradeNO = [[orders objectAtIndex:0] valueForKey:@"order_number"]; //订单ID（由商家自行制定）
    NSMutableArray * productNames = [NSMutableArray arrayWithCapacity:[orders count]];
    float totalMoney = 0.0f;
    for(NSDictionary * order in orders)
    {
        [productNames addObject:[order valueForKey:@"goods_name"]];
        totalMoney += [[order valueForKey:@"total_money"] floatValue];
    }
	payorder.productName = [productNames componentsJoinedByString:@","]; //商品标题
	payorder.productDescription = [productNames componentsJoinedByString:@","]; //商品描述
	payorder.amount = [NSString stringWithFormat:@"%0.2f",totalMoney]; //商品价格
	payorder.notifyURL =  nil; //回调URL
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

@end
