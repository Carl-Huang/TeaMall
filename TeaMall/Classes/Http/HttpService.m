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
            NSArray * result = [obj valueForKey:@"result"];
            NSDictionary * info = nil;
            if ([result count] > 0) {
                info = [result objectAtIndex:0];
            }
            User * user = [self mapModel:info withClass:[User class]];
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


/**
 @desc 获取商品
 */
- (void)getCommodity:(NSDictionary *)params  completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure
{
    [self post:[self mergeURL:Get_Commodity] withParams:params completionBlock:^(id obj) {
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
 @desc 获取商品分类
 */
- (void)getCategory:(NSDictionary *)params  completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure
{
    [self post:[self mergeURL:Get_Category] withParams:params completionBlock:^(id obj) {
        NSString * status = [obj objectForKey:@"status"];
        if([status integerValue] == 1)
        {
            NSArray * result = [obj objectForKey:@"result"];
            NSArray * teaCategorys = [self mapModelsProcess:result withClass:[TeaCategory class]];
            if(success)
            {
                success(teaCategorys);
            }
            
        }
        else
        {
            if (failure) {
                failure(nil,@"获取分类失败");
            }
        }
    } failureBlock:failure];
}

/**
 @desc 添加收藏
 */
//TODO:添加收藏
- (void)addCollection:(NSDictionary *)params  completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure
{
    [self post:[self mergeURL:Add_Collection] withParams:params completionBlock:^(id obj) {
        NSString * status = [obj objectForKey:@"status"];
        if([status integerValue] == 1)
        {
            if(success) success([obj objectForKey:@"result"]);
        }
        else
        {
            if(failure) failure(nil,[obj objectForKey:@"result"]);
        }
    } failureBlock:failure];
}

/**
 @desc 删除收藏
 */
//TODO:删除收藏
- (void)deleteCollection:(NSDictionary *)params  completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure
{
    [self post:[self mergeURL:Delete_Collection] withParams:params completionBlock:^(id obj) {
        NSString * status = [obj objectForKey:@"status"];
        if([status integerValue] == 1)
        {
            if(success) success([obj objectForKey:@"result"]);
        }
        else
        {
            if(failure) failure(nil,[obj objectForKey:@"result"]);
        }
    } failureBlock:failure];
}

/**
 @desc 删除发布
 */
//TODO:删除发布
- (void)deletePublish:(NSDictionary *)params  completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure
{
    [self post:[self mergeURL:Delete_Publish] withParams:params completionBlock:^(id obj) {
        NSString * status = [obj objectForKey:@"status"];
        if([status integerValue] == 1)
        {
            if(success) success([obj objectForKey:@"result"]);
        }
        else
        {
            if(failure) failure(nil,[obj objectForKey:@"result"]);
        }
    } failureBlock:failure];
    
}

/**
 @desc 添加发布
 */
//TODO:添加发布
- (void)addPublish:(NSDictionary *)params  completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure
{
    [self post:[self mergeURL:Add_Publish] withParams:params completionBlock:^(id obj) {
        NSString * status = [obj objectForKey:@"status"];
        if([status integerValue] == 1)
        {
            if(success) success([obj objectForKey:@"result"]);
        }
        else
        {
            if(failure) failure(nil,[obj objectForKey:@"result"]);
        }
    } failureBlock:failure];
}

/**
 @desc 添加反馈意见
 */
//TODO:添加反馈意见
- (void)addFeedback:(NSDictionary *)params  completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure
{
    [self post:[self mergeURL:Add_Publish] withParams:params completionBlock:^(id obj) {
        NSString * status = [obj objectForKey:@"status"];
        if([status integerValue] == 1)
        {
            if(success) success([obj objectForKey:@"result"]);
        }
        else
        {
            if(failure) failure(nil,[obj objectForKey:@"result"]);
        }
    } failureBlock:failure];
    
}

/**
 @desc 我的收货地址
 */
//TODO:我的收货地址
- (void)getAddressList:(NSDictionary *)params  completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure
{
    [self post:[self mergeURL:Get_Address_List] withParams:params completionBlock:^(id obj) {
        NSString * status = [obj objectForKey:@"status"];
        if([status integerValue] == 1)
        {
            NSArray * result = [obj objectForKey:@"result"];
            NSArray * addressList = [self mapModelsProcess:result withClass:[Address class]];
            if(success)
            {
                success(addressList);
            }
            
        }
        else
        {
            if (failure) {
                failure(nil,@"获取我的收货地址失败");
            }
        }
    } failureBlock:failure];
}


/**
 @desc 添加收货地址
 */
//TODO:添加收货地址
- (void)addAddress:(NSDictionary *)params  completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure
{
    [self post:[self mergeURL:Add_Address] withParams:params completionBlock:^(id obj) {
        NSString * status = [obj objectForKey:@"status"];
        if([status integerValue] == 1)
        {
            if(success) success([obj objectForKey:@"result"]);
        }
        else
        {
            if(failure) failure(nil,[obj objectForKey:@"result"]);
        }
    } failureBlock:failure];
}

/**
 @desc 删除收货地址
 */
//TODO:删除收货地址
- (void)deleteAddress:(NSDictionary *)params  completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure
{
    [self post:[self mergeURL:Delete_Address] withParams:params completionBlock:^(id obj) {
        NSString * status = [obj objectForKey:@"status"];
        if([status integerValue] == 1)
        {
            if(success) success([obj objectForKey:@"result"]);
        }
        else
        {
            if(failure) failure(nil,[obj objectForKey:@"result"]);
        }
    } failureBlock:failure];
}

/**
 @desc 更新收货地址
 */
//TODO:更新收货地址
- (void)updateAddress:(NSDictionary *)params  completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure
{
    [self post:[self mergeURL:Update_Address] withParams:params completionBlock:^(id obj) {
        NSString * status = [obj objectForKey:@"status"];
        if([status integerValue] == 1)
        {
            if(success) success([obj objectForKey:@"result"]);
        }
        else
        {
            if(failure) failure(nil,[obj objectForKey:@"result"]);
        }
    } failureBlock:failure];
}

/**
 @desc 我的收藏
 */
//TODO:我的收藏
- (void)getMyCollection:(NSDictionary *)params  completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure
{
    [self post:[self mergeURL:Get_My_Collection] withParams:params completionBlock:^(id obj) {
        NSString * status = [obj objectForKey:@"status"];
        if([status integerValue] == 1)
        {
            NSMutableArray * result = [NSMutableArray array];
            NSArray * goods = [self mapModelsProcess:[obj objectForKey:@"goods"] withClass:[Commodity class]];
            NSArray * publishs = [self mapModelsProcess:[obj objectForKey:@"publish"] withClass:[Publish class]];
            if(goods != nil || [goods count] > 0)
            {
                [result addObjectsFromArray:goods];
            }
            
            if(publishs != nil && [publishs count] > 0)
            {
                [result addObjectsFromArray:publishs];
            }
            
            if(success)
            {
                success(result);
            }
        }
        else
        {
            if(failure) failure(nil,[obj objectForKey:@"result"]);
        }

    } failureBlock:failure];
}

@end
