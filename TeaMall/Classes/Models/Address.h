//
//  Address.h
//  TeaMall
//
//  Created by Carl on 14-2-13.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "BaseModel.h"

@interface Address : BaseModel
@property (nonatomic,strong) NSString * hw_id;
@property (nonatomic,strong) NSString * user_id;
@property (nonatomic,strong) NSString * name;
@property (nonatomic,strong) NSString * phone;
@property (nonatomic,strong) NSString * zip;
@property (nonatomic,strong) NSString * address;
@property (nonatomic,strong) NSString * add_time;
@property (nonatomic,strong) NSString * update_time;
@end
