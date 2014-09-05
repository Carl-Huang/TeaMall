//
//  HttpService.h
//  HWSDK
//
//  Created by Carl on 13-11-28.
//  Copyright (c) 2013年 helloworld. All rights reserved.
//

#import "AFHttp.h"
//#define URL_PREFIX @"http://www.yichatea.com/admin/api/"
//#define URL_PREFIX @"http://192.168.1.106/api/"
#define URL_PREFIX @"http://115.29.248.57:8080/admin/api/"
#define User_Login                                  @"login"
#define User_Register                               @"register"
#define Get_Market_News                             @"news"
#define Get_Market                                  @"market"
#define Search_Commodity                            @"ksearch"
#define Get_Customer_Service                        @"service"
#define Get_Publish                                 @"publish_list"
#define Get_User_Publish                            @"my_publish"
#define Get_Commodity                               @"goods"
#define Get_Category                                @"category"
#define Add_Collection                              @"addCollection"
#define Delete_Collection                           @"delete_collection"
#define Delete_Publish                              @"delete_publish"
#define Add_Publish                                 @"publish"
#define Add_Feedback                                @"feedback"
#define Get_Address_List                            @"address_list"
#define Add_Address                                 @"add_address"
#define Delete_Address                              @"delete_address"
#define Update_Address                              @"update_address"
#define Get_My_Collection                           @"my_collection"
#define Update_Member                               @"update_member"
#define Add_Order                                   @"add_order"
#define Update_Order                                @"update_order"
#define Add_Goods_Comment                           @"add_comment"
#define Goods_Comment_List                          @"goods_comment_list"
#define Add_News_Comment                            @"add_news_comment"
#define News_Comment_List                           @"news_comment_list"
#define Get_Launch_Image                            @"get_cover"
#define Get_Advertisement                           @"advertisement_list"
#define Get_Zone_List                               @"get_zone_list"      //获取专区列表
#define Get_Goods_By_Zone                           @"get_goods_by_zone"  //根据专区获取商品列表
#define Get_Zone_With_Goods                        @"get_zone_with_goods"//根据专区列表附带专区商品
#define Add_Real_Name                               @"add_real_name"//获取真实姓名
#define Add_Service                                 @"add_service"//获取客服
#define Add_Shop_Name                               @"add_shop_name"//添加店铺名称
#define Open_Login                                  @"open_login"//判断是否第三方登陆
#define Add_Shopping_List                           @"add_shopping_list"//拍下用户发布
#define Get_Shopping_List                           @"get_shopping_list"//获取用户拍下的发布列表

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
 @desc 市场行情
 */
- (void)getMarketCommodity:(NSDictionary *)params completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure;

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
//TODO:获取商品
- (void)getCommodity:(NSDictionary *)params  completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure;

/**
 @desc 获取商品分类
 */
//TODO:获取商品分类
- (void)getCategory:(NSDictionary *)params  completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure;

/**
 @desc 添加收藏
 */
//TODO:添加收藏
- (void)addCollection:(NSDictionary *)params  completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure;

/**
 @desc 删除收藏
 */
//TODO:删除收藏
- (void)deleteCollection:(NSDictionary *)params  completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure;

/**
 @desc 删除发布
 */
//TODO:删除发布
- (void)deletePublish:(NSDictionary *)params  completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure;

/**
 @desc 添加发布
 */
//TODO:添加发布
- (void)addPublish:(NSDictionary *)params  completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure;

/**
 @desc 拍下用户发布
 */
//TODO:拍下用户发布
- (void)bidUserPublish:(NSDictionary *)params completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure;

/**
 @desc 获取用户拍下的发布列表
 */
//TODO:获取用户拍下的发布列表
- (void)getBidList:(NSDictionary *)params completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure;

/**
 @desc 添加反馈意见
 */
//TODO:添加反馈意见
- (void)addFeedback:(NSDictionary *)params  completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure;


/**
 @desc 我的收货地址
 */
//TODO:我的收货地址
- (void)getAddressList:(NSDictionary *)params  completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure;

/**
 @desc 添加收货地址
 */
//TODO:添加收货地址
- (void)addAddress:(NSDictionary *)params  completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure;

/**
 @desc 删除收货地址
 */
//TODO:删除收货地址
- (void)deleteAddress:(NSDictionary *)params  completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure;

/**
 @desc 更新收货地址
 */
//TODO:更新收货地址
- (void)updateAddress:(NSDictionary *)params  completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure;


/**
 @desc 我的收藏
 */
//TODO:我的收藏
- (void)getMyCollection:(NSDictionary *)params  completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure;


/**
 @desc 更新用户资料
 */
//TODO:更新用户资料
- (void)updateUserInfo:(NSDictionary *)params  completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure;

/**
 @desc 添加订单
 */
//TODO:添加订单
- (void)addOrder:(NSDictionary *)params  completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure;

/**
 @desc 更新订单
 */
//TODO:更新订单
- (void)updateOrder:(NSDictionary *)params  completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure;

/**
 @desc 添加商品评论
 */
//TODO:添加商品评论
- (void)addGoodsComment:(NSDictionary *)params  completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure;

/**
 @desc 获取商品评论列表
 */
- (void)getGoodsComments:(NSDictionary *)params  completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure;


/**
 @desc 添加新闻评论
 */
//TODO:添加新闻评论
- (void)addNewsComment:(NSDictionary *)params  completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure;

/**
 @desc 获取新闻的评论
 */
- (void)getNewsComment:(NSDictionary *)params  completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure;

/**
 @desc 获取启动图片
 */
//TODO:获取启动图片
- (void)getLaunchImage:(NSDictionary *)params  completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure;


/**
 @desc 获取广告
 */
//TODO:获取广告
- (void)getAdvertiment:(NSDictionary *)params  completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure;

/**
 @desc 获取专区
 */
//TODO:获取专区
- (void)getZone:(NSDictionary *)params  completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure;

/**
 @desc 添加客服
 */
//TODO:添加客服
- (void)addService:(NSDictionary *)params  completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure;

/**
 @desc 添加用户真实姓名
 */
//TODO:添加用户真实姓名
- (void)addUserRealName:(NSDictionary *)params  completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure;

/**
 @desc 添加店铺名称
 */
//TODO:添加店铺名称
- (void)addShopName:(NSDictionary *)params  completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure;

/**
 @desc 判断是否第三方登陆账号
 */
//TODO:判断是否第三方登陆账号
- (void)isOpenLogin:(NSDictionary *)params completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure;



@end
