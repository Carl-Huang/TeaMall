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
@property (nonatomic,strong) NSString * address;
@property (nonatomic,strong) NSString * email;
@property (nonatomic,strong) NSString * userName;
@property (nonatomic,strong) NSString * passWord;
+ (void)saveToLocal:(User *)user;
+ (User *)userFromLocal;
@end
