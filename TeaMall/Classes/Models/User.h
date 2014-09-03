//
//  User.h
//  ClairAudient
//
//  Created by Carl on 14-1-19.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "BaseModel.h"

@interface User : BaseModel

@property (nonatomic,strong) NSString * hw_id;
@property (nonatomic,strong) NSString * account;
@property (nonatomic,strong) NSString * real_name;
@property (nonatomic,strong) NSString * shop_name;
@property (nonatomic,strong) NSString * serviceName;
@property (nonatomic,strong) NSString * password;
@property (nonatomic,strong) NSString * phone;
@property (nonatomic,strong) NSString * wechat;
@property (nonatomic,strong) NSString * avatar;
@property (nonatomic,strong) NSString * sex;
@property (nonatomic,strong) NSString * register_time;
@property (nonatomic,strong) NSString * last_time;
+ (void)saveToLocal:(User *)user;
+ (User *)userFromLocal;
+ (void)deleteUserFromLocal;
@end
