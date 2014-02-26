//
//  AppDelegate.m
//  TeaMall
//
//  Created by Carl on 14-1-10.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//


#import "AppDelegate.h"
#import "ControlCenter.h"
#import <ShareSDK/ShareSDK.h>
#import "WXApi.h"
#import "Constants.h"
#import "HttpService.h"
#import "MBProgressHUD.h"
#import "User.h"
#import "AlixPayResult.h"
#import "DataVerifier.h"
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [IO createDirectoryInDocument:Image_Path];
    [ControlCenter makeKeyAndVisible];
    
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"顶栏"] forBarMetrics:UIBarMetricsDefault];
    //配置分享
    [self setupShareStuff];
    [MagicalRecord setupCoreDataStackWithStoreNamed:@"TeaDataSource.sqlite"];
    [self userLogin];
    [self getAllTeaCategory];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
-(void)toggleLeftMenu
{
    if (self.containerViewController.menuState == YDSLideMenuStateLeftMenuOpen)
    {
        [self.containerViewController setMenuState:YDSLideMenuStateClosed];
    }
    else
    {
        [self.containerViewController setMenuState:YDSLideMenuStateLeftMenuOpen];
    }
    
}

-(void)setupShareStuff
{
    [ShareSDK registerApp:@"iosv1103"];
    //新浪微博
    [ShareSDK connectSinaWeiboWithAppKey:@"568898243"
                               appSecret:@"38a4f8204cc784f81f9f0daaf31e02e3"
                             redirectUri:@"http://www.sharesdk.cn"];
    //微信
    [ShareSDK connectWeChatWithAppId:@"wx4868b35061f87885" wechatCls:[WXApi class]];
    [ShareSDK importWeChatClass:[WXApi class]];
    
    //添加QQ空间应用
    [ShareSDK connectQZoneWithAppKey:@"100371282"
                           appSecret:@"aed9b0303e3ed1e27bae87c33761161d"];
    
}

//微信分享配置
- (BOOL)application:(UIApplication *)application  handleOpenURL:(NSURL *)url
{
    
    
    return [ShareSDK handleOpenURL:url
                        wxDelegate:self];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
//    NSLog(@"%@",url.absoluteString);
    
    
    //判断是否是微信的回调
    NSString * weiXinAppID = @"wx4868b35061f87885";
    if ([url.absoluteString rangeOfString:weiXinAppID].location != NSNotFound) {
        return [ShareSDK handleOpenURL:url
                     sourceApplication:sourceApplication
                            annotation:annotation
                            wxDelegate:self];
    }
    
    //支付宝回调
    [self parse:url application:application];
    
    return YES;
}



- (void)parse:(NSURL *)url application:(UIApplication *)application {
    
    //结果处理
    AlixPayResult* result = [self handleOpenURL:url];
    
	if (result)
    {
		
		if (result.statusCode == 9000)
        {
			/*
			 *用公钥验证签名 严格验证请使用result.resultString与result.signString验签
			 */
            
            //交易成功
            //            NSString* key = @"签约帐户后获取到的支付宝公钥";
            //			id<DataVerifier> verifier;
            //            verifier = CreateRSADataVerifier(key);
            //
            //			if ([verifier verifyString:result.resultString withSign:result.signString])
            //            {
            //                //验证签名成功，交易结果无篡改
            //			}
            
        }
        else
        {
            //交易失败
        }
    }
    else
    {
        //失败
    }
    
}


- (AlixPayResult *)resultFromURL:(NSURL *)url {
	NSString * query = [[url query] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
#if ! __has_feature(objc_arc)
    return [[[AlixPayResult alloc] initWithString:query] autorelease];
#else
	return [[AlixPayResult alloc] initWithString:query];
#endif
}

- (AlixPayResult *)handleOpenURL:(NSURL *)url {
	AlixPayResult * result = nil;
	
	if (url != nil && [[url host] compare:@"safepay"] == 0) {
		result = [self resultFromURL:url];
	}
    
	return result;
}

- (void)getAllTeaCategory
{
    [[HttpService sharedInstance] getCategory:@{@"is_system":@"0"} completionBlock:^(id object) {
        self.allTeaCategory = object;
    } failureBlock:^(NSError *error, NSString *responseString) {
        
    }];
}

- (void)fisrtLaunch
{
    if(![[NSUserDefaults standardUserDefaults] boolForKey:First_Launch])
    {
        
    }
}

- (void)userLogin
{
    User * user = [User userFromLocal];
    if(user == nil)
    {
        return ;
    }
    NSLog(@"%@%@",user.account,user.password);
    if(user.account == nil || user.password == nil)
    {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil message:@"用户资料已过期,请重新登录" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        alertView = nil;
        [User deleteUserFromLocal];
        return ;
    }
    [[HttpService sharedInstance] userLogin:@{@"account":user.account,@"password":user.password} completionBlock:^(id object) {
        
        if(object)
        {
            User * user = (User *)object;
            [User saveToLocal:user];

        }

    } failureBlock:^(NSError *error, NSString *responseString) {

        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil message:@"用户资料已过期,请重新登录" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        alertView = nil;
        [User deleteUserFromLocal];
    }];
}

@end
