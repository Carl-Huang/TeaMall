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
#define User_Register                               @"register"
#define Get_Market_News                             @"news"
#define Get_Market                                  @"market"
#define Search_Commodity                            @"ksearch"
#define Get_Customer_Service                        @"service"
#define Get_Publish                                 @"publish_list"
#define Get_User_Publish                            @"my_publish"
#define Get_Commodity                               @"goods"
@interface HttpService : AFHttp

+ (HttpService *)sharedInstance;

/**
 @desc 用户登录
 */
//TODO:用户登录
- (void)userLogin:(NSDictionary *)params completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure;
/**
 @desc 用户注册
 */
//TODO:用户注册
- (void)userRegister:(NSDictionary *)params completionBlock:(void (^)(BOOL isSuccess))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure;

/**
 @desc 获取市场资讯(顶部滚动)
 */
//TODO:获取市场资讯(顶部滚动)
- (void)getMarketNewsTopWithCompletionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure;

/**
 @desc 获取市场资讯(非顶部滚动)
 */
//TODO:获取市场资讯(非顶部滚动)
- (void)getMarketNewsWithCompletionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure;


/**
 @desc 市场行情:获取升价商品
 */
//TODO:市场行情:获取升价商品
- (void)getAddPriceCommodity:(NSDictionary *)params  completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure;
/**
 @desc 市场行情:获取降价商品
 */
//TODO:市场行情:获取降价商品
- (void)getReducePriceCommodity:(NSDictionary *)params completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure;

/**
 @desc 搜索商品
 */
//TODO:搜索商品
- (void)searchCommodity:(NSDictionary *)params  completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure;

/**
 @desc 获取客服列表
 */
//TODO:获取客服列表
- (void)getCustomerService:(NSDictionary *)params  completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure;

/**
 @desc 获取用户发布列表
 */
//TODO:获取用户发布列表
- (void)getPublishList:(NSDictionary *)params  completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure;

/**
 @desc 获取个人发布列表
 */
//TODO:获取个人发布列表
- (void)getUserPublish:(NSDictionary *)params  completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure;

/**
 @desc 获取商品
 */
- (void)getCommodity:(NSDictionary *)params  completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure;


@end
