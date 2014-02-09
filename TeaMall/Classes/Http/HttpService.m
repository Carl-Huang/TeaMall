//
//  HttpService.m
//  HWSDK
//
//  Created by Carl on 13-11-28.
//  Copyright (c) 2013年 helloworld. All rights reserved.
//

#import "HttpService.h"
#import "AllModels.h"
#import <objc/runtime.h>
#define HW @"hw_"       //关键字属性前缀
@implementation HttpService

#pragma mark Life Cycle
- (id)init
{
    if ((self = [super init])) {
        
    }
    return  self;
}

#pragma mark Class Method
+ (HttpService *)sharedInstance
{
    static HttpService * this = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        this = [[self alloc] init];
    });
    return this;
}

#pragma mark Private Methods
- (NSString *)mergeURL:(NSString *)methodName
{
    NSString * str =[NSString stringWithFormat:@"%@%@",URL_PREFIX,methodName];
    str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return str;
}

/**
 @desc 返回类的属性列表
 @param 类对应的class
 @return NSArray 属性列表
 */
+ (NSArray *)propertiesName:(Class)cls
{
    if(cls == nil) return nil;
    unsigned int outCount,i;
    objc_property_t * properties = class_copyPropertyList(cls, &outCount);
    NSMutableArray * list = [NSMutableArray arrayWithCapacity:outCount];
    for (i = 0; i < outCount; i++)
    {
        objc_property_t property = properties[i];
        NSString * propertyName = [NSString stringWithUTF8String:property_getName(property)];
        if(propertyName && [propertyName length] != 0)
        {
            [list addObject:propertyName];
        }
    }
    return list;
}



//将取得的内容转换为模型
- (NSArray *)mapModelsProcess:(id)responseObject withClass:(Class)class
{
    //判断返回值
    if(!responseObject || [responseObject isKindOfClass:[NSNull class]])
    {
        return nil;
    }
    
//    NSArray * properties = [[self class] propertiesName:class];
    NSMutableArray * models = [NSMutableArray array];
    for (NSDictionary * info in responseObject) {
        id model = [self mapModel:info withClass:class];
        if(model)
        {
            [models addObject:model];
        }
    }
    
    return (NSArray *)models;
}

- (id)mapModel:(id)reponseObject withClass:(Class)cls
{
    if (!reponseObject || [reponseObject isKindOfClass:[NSNull class]]) {
        return nil;
    }
    id model  = [[cls alloc] init];
    NSArray * properties = [[self class] propertiesName:cls];
    for(NSString * property in properties)
    {
        NSString * tmp = [property stringByReplacingOccurrencesOfString:HW withString:@""];
        id value = [reponseObject valueForKey:tmp];
        if(![value isKindOfClass:[NSNull class]])
        {
            if(![value isKindOfClass:[NSString class]])
            {
                [model setValue:[value stringValue] forKey:property];
            }
            else
            {
                [model setValue:value forKey:property];
            }
        }
    }
    return model;
}

#pragma mark Instance Method
/**
 @desc 用户登录
 */
- (void)userLogin:(NSDictionary *)params completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure
{

    [self post:[self mergeURL:User_Login] withParams:params completionBlock:^(id obj) {
        NSString * result = [obj valueForKey:@"status"];
        if([result intValue] == 1)
        {
            User * user = [self mapModel:[obj valueForKey:@"result"] withClass:[User class]];
            if(success)
            {
                success(user);
            }
        }
        else if ([result intValue] == 0)
        {
            //密码错误
            //用户名不存在
            if(failure)
            {
                failure(nil,result);
            }
            
        }
    } failureBlock:failure];
}

/**
 @desc 用户注册
 */
- (void)userRegister:(NSDictionary *)params completionBlock:(void (^)(BOOL isSuccess))success failureBlock:(void (^)(NSError * error,NSString * reponseString))failure
{
    [self post:[self mergeURL:User_Register] withParams:params completionBlock:^(id obj) {
        NSString * status = [obj objectForKey:@"status"];
        if([status integerValue] == 1)
        {
            if(success)
            {
                success(YES);
            }
        }
        else
        {
            if(success)
            {
                success(NO);
            }

        }
    } failureBlock:failure];
}

/**
 @desc 获取市场资讯(顶部滚动)
 */
- (void)getMarketNewsTopWithCompletionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure
{
    [self getMarketNews:@{@"is_top":@"1"} completionBlock:success failureBlock:failure];
}

/**
 @desc 获取市场资讯(非顶部滚动)
 */
- (void)getMarketNewsWithCompletionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure
{
    [self getMarketNews:@{@"is_top":@"0"} completionBlock:success failureBlock:failure];
}


/**
 @desc 获取市场资讯
 */
- (void)getMarketNews:(NSDictionary *)params completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure
{
    [self post:[self mergeURL:Get_Market_News] withParams:params completionBlock:^(id obj) {
        NSString * status = [obj objectForKey:@"status"];
        if([status integerValue] == 1)
        {
            NSArray * result = [obj objectForKey:@"result"];
            NSArray * newsArray = [self mapModelsProcess:result withClass:[MarketNews class]];
            if(success)
            {
                success(newsArray);
            }
        }
        else if([status integerValue] == 0)
        {
            if(failure)
            {
                failure(nil,@"暂时没有市场资讯!");
            }
        }
    } failureBlock:failure];
}

/**
 @desc 市场行情:获取升价商品
 */
- (void)getAddPriceCommodity:(NSDictionary *)params  completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure
{
    NSMutableDictionary * info = [NSMutableDictionary dictionaryWithDictionary:params];
    [info setValue:@"1" forKey:@"type"];
    [self getMarketCommodity:info completionBlock:success failureBlock:failure];
}

/**
 @desc 市场行情:获取降价商品
 */
- (void)getReducePriceCommodity:(NSDictionary *)params completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure
{
    NSMutableDictionary * info = [NSMutableDictionary dictionaryWithDictionary:params];
    [info setValue:@"0" forKey:@"type"];
    [self getMarketCommodity:info completionBlock:success failureBlock:failure];
}

/**
 @desc 市场行情
 */
- (void)getMarketCommodity:(NSDictionary *)params completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure
{
    [self post:[self mergeURL:Get_Market] withParams:params completionBlock:^(id obj) {
        NSString * status = [obj objectForKey:@"status"];
        if([status integerValue] == 1)
        {
            NSArray * result = [obj objectForKey:@"result"];
            NSArray * commodities = [self mapModelsProcess:result withClass:[Commodity class]];
            if(success)
            {
                success(commodities);
            }
        }
        else if([status integerValue] == 0)
        {
            if(failure)
            {
                failure(nil,@"暂时没有商品!");
            }
        }
    } failureBlock:failure];
}

/**
 @desc 搜索商品
 */
- (void)searchCommodity:(NSDictionary *)params  completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure
{
    [self post:[self mergeURL:Search_Commodity] withParams:params completionBlock:^(id obj) {
        NSString * status = [obj objectForKey:@"status"];
        if([status integerValue] == 1)
        {
            NSArray * result = [obj objectForKey:@"result"];
            NSArray * commodities = [self mapModelsProcess:result withClass:[Commodity class]];
            if(success)
            {
                success(commodities);
            }
        }
        else if([status integerValue] == 0)
        {
            if(failure)
            {
                failure(nil,@"暂时没有商品!");
            }
        }
    } failureBlock:failure];
}

/**
 @desc 获取客服列表
 */
- (void)getCustomerService:(NSDictionary *)params  completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure
{
    [self post:[self mergeURL:Get_Customer_Service] withParams:params completionBlock:^(id obj) {
        NSString * status = [obj objectForKey:@"status"];
        if([status integerValue] == 1)
        {
            NSArray * result = [obj objectForKey:@"result"];
            NSArray * customerServices = [self mapModelsProcess:result withClass:[CustomerService class]];
            if(success)
            {
                success(customerServices);
            }
        }
        else if([status integerValue] == 0)
        {
            if(failure)
            {
                failure(nil,@"暂时没有客服人员!");
            }
        }
    } failureBlock:failure];
    
}

/**
 @desc 获取用户发布列表
 */
- (void)getPublishList:(NSDictionary *)params  completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure
{
    [self post:[self mergeURL:Get_Publish] withParams:params completionBlock:^(id obj) {
        NSString * status = [obj objectForKey:@"status"];
        if([status integerValue] == 1)
        {
            NSArray * result = [obj objectForKey:@"result"];
            NSArray * publishs = [self mapModelsProcess:result withClass:[Publish class]];
            if(success)
            {
                success(publishs);
            }
        }
        else if([status integerValue] == 0)
        {
            if(failure)
            {
                failure(nil,@"暂时没有发布!");
            }
        }

    } failureBlock:failure];
}

/**
 @desc 获取个人发布列表
 */
- (void)getUserPublish:(NSDictionary *)params  completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure
{
    [self post:[self mergeURL:Get_User_Publish] withParams:params completionBlock:^(id obj) {
        NSString * status = [obj objectForKey:@"status"];
        if([status integerValue] == 1)
        {
            NSArray * result = [obj objectForKey:@"result"];
            NSArray * publishs = [self mapModelsProcess:result withClass:[Publish class]];
            if(success)
            {
                success(publishs);
            }
        }
        else if([status integerValue] == 0)
        {
            if(failure)
            {
                failure(nil,@"暂时没有发布!");
            }
        }
        
    } failureBlock:failure];
}


@end
