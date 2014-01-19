//
//  PersonalCenterViewController.m
//  TeaMall
//
//  Created by Carl_Huang on 14-1-12.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "PersonalCenterViewController.h"
#import "UINavigationBar+Custom.h"
#import "MyCollectViewController.h"
#import "MyShoppingCarViewController.h"
#import "MyPublicViewController.h"

//支付宝
#import "AlixPayOrder.h"
#import "AlixPayResult.h"
#import "AlixPay.h"
#import "DataSigner.h"

@implementation Product
@synthesize price = _price;
@synthesize subject = _subject;
@synthesize body = _body;
@synthesize orderId = _orderId;
@end


@interface PersonalCenterViewController ()
{
    NSMutableArray *_products;
}
@end

@implementation PersonalCenterViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)myPersonalDataBtnAciton:(id)sender {
}

- (IBAction)MyPublicBtnAction:(id)sender {
    MyPublicViewController *viewController = [[MyPublicViewController alloc]initWithNibName:@"MyPublicViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
    viewController = nil;
}

- (IBAction)MyCollectBtnAction:(id)sender {
    MyCollectViewController *viewController = [[MyCollectViewController alloc]initWithNibName:@"MyCollectViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
    viewController = nil;
}

- (IBAction)myShoppingCarBtnAction:(id)sender {
    MyShoppingCarViewController *viewController = [[MyShoppingCarViewController alloc]initWithNibName:@"MyShoppingCarViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
    viewController = nil;
}

- (IBAction)ZhifubaoAction:(id)sender {
}

#pragma mark - 支付宝
/*
 *随机生成15位订单号,外部商户根据自己情况生成订单号
 */
- (NSString *)generateTradeNO
{
	const int N = 15;
	
	NSString *sourceString = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
	NSMutableString *result = [[NSMutableString alloc] init];
	srand(time(0));
	for (int i = 0; i < N; i++)
	{
		unsigned index = rand() % [sourceString length];
		NSString *s = [sourceString substringWithRange:NSMakeRange(index, 1)];
		[result appendString:s];
	}
	return result;
}

/*
 *产生商品列表数据,这里的商品信息是写死的,可以修改,仅供测试
 */
- (void)generateData{
	NSArray *subjects = [[NSArray alloc] initWithObjects:@"话费充值",
						 @"魅力香水",@"珍珠项链",@"三星 原装移动硬盘",
						 @"发箍发带",@"台版N97I",@"苹果手机",
						 @"蝴蝶结",@"韩版雪纺",@"五皇纸箱",nil];
	NSArray *body = [[NSArray alloc] initWithObjects:@"[四钻信誉]北京移动30元 电脑全自动充值 1到10分钟内到账",
					 @"新年特惠 adidas 阿迪达斯走珠 香体止汗走珠 多种香型可选",
					 @"[2元包邮]韩版 韩国 流行饰品太阳花小巧雏菊 珍珠项链2M15",
					 @"三星 原装移动硬盘 S2 320G 带加密 三星S2 韩国原装 全国联保",
					 @"[肉来来]超热卖 百变小领巾 兔耳朵布艺发箍发带",
					 @"台版N97I 有迷你版 双卡双待手机 挂QQ JAVA 炒股 来电归属地 同款比价",
					 @"山寨国产红苹果手机 Hiphone I9 JAVA QQ后台 飞信 炒股 UC",
					 @"[饰品实物拍摄]满30包邮 三层绸缎粉色 蝴蝶结公主发箍多色入",
					 @"饰品批发价 韩版雪纺纱圆点布花朵 山茶玫瑰花 发圈胸针两用 6002",
					 @"加固纸箱 会员包快递拍好去运费冲纸箱首个五皇",nil];
	
	if (nil == _products) {
		_products = [[NSMutableArray alloc] init];
	}
	else {
		[_products removeAllObjects];
	}
    
	for (int i = 0; i < [subjects count]; ++i) {
		Product *product = [[Product alloc] init];
		product.subject = [subjects objectAtIndex:i];
		product.body = [body objectAtIndex:i];
		product.price = 0.01f;
		[_products addObject:product];
		product = nil;
	}
	
    subjects = nil;
    body = nil;
}


-(void)payAction
{
    /*
	 *点击获取prodcut实例并初始化订单信息
	 */
	Product *product ;
	
	NSString *partner = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"Partner"];
    NSString *seller = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"Seller"];
	
	//partner和seller获取失败,提示
	if ([partner length] == 0 || [seller length] == 0)
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
														message:@"缺少partner或者seller。"
													   delegate:self
											  cancelButtonTitle:@"确定"
											  otherButtonTitles:nil];
		[alert show];
        alert = nil;
		return;
	}

	//将商品信息赋予AlixPayOrder的成员变量
	AlixPayOrder *order = [[AlixPayOrder alloc] init];
	order.partner = partner;
	order.seller = seller;
	order.tradeNO = [self generateTradeNO]; //订单ID（由商家自行制定）
	order.productName = product.subject; //商品标题
	order.productDescription = product.body; //商品描述
	order.amount = [NSString stringWithFormat:@"%.2f",product.price]; //商品价格
	order.notifyURL =  @"http://www.xxx.com"; //回调URL
	
	//应用注册scheme,在AlixPayDemo-Info.plist定义URL types,用于快捷支付成功后重新唤起商户应用
	NSString *appScheme = @"TeaMailApp";
	
	//将商品信息拼接成字符串
	NSString *orderSpec = [order description];
	NSLog(@"orderSpec = %@",orderSpec);
	
	//获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
	id<DataSigner> signer = CreateRSADataSigner([[NSBundle mainBundle] objectForInfoDictionaryKey:@"RSA private key"]);
	NSString *signedString = [signer signString:orderSpec];
	
	//将签名成功字符串格式化为订单字符串,请严格按照该格式
	NSString *orderString = nil;
	if (signedString != nil) {
		orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        //获取快捷支付单例并调用快捷支付接口
        AlixPay * alixpay = [AlixPay shared];
        int ret = [alixpay pay:orderString applicationScheme:appScheme];
        
        if (ret == kSPErrorAlipayClientNotInstalled) {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                 message:@"您还没有安装支付宝快捷支付，请先安装。"
                                                                delegate:self
                                                       cancelButtonTitle:@"确定"
                                                       otherButtonTitles:nil];
            [alertView setTag:123];
            [alertView show];
            alertView = nil;
        }
        else if (ret == kSPErrorSignError) {
            NSLog(@"签名错误！");
        }
	}
}
@end
