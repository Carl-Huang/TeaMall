//
//  HttpService.h
//  HWSDK
//
//  Created by Carl on 13-11-28.
//  Copyright (c) 2013年 helloworld. All rights reserved.
//

#import "AFHttp.h"
#define URL_PREFIX @"http://teamall880.sinaapp.com/api/"
#define User_Login                                  @"login"
#define User_Register                               @"user_register"
#define Get_Market_News                             @"news"
#define Get_Market                                  @"market"
@interface HttpService : AFHttp

+ (HttpService *)sharedInstance;
/**
 @desc 用户登录
 */
- (void)userLogin:(NSDictionary *)params completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure;
/**
 @desc 用户注册
 */

- (void)userRegister:(NSDictionary *)params completionBlock:(void (^)(BOOL isSuccess))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure;

/**
 @desc 获取市场资讯(顶部滚动)
 */
- (void)getMarketNewsTopWithCompletionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure;

/**
 @desc 获取市场资讯(非顶部滚动)
 */
- (void)getMarketNewsWithCompletionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure;


/**
 @desc 市场行情:获取升价商品
 */
- (void)getAddPriceCommodity:(NSDictionary *)params  completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure;
/**
 @desc 市场行情:获取降价商品
 */
- (void)getReducePriceCommodity:(NSDictionary *)params completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure;

@end
