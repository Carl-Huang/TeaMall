//
//  Public.h
//  TeaMall
//
//  Created by Carl on 14-2-9.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "BaseModel.h"

@interface Publish : BaseModel
@property (nonatomic,strong) NSString * hw_id;
@property (nonatomic,strong) NSString * user_id;
@property (nonatomic,strong) NSString * avatar;
@property (nonatomic,strong) NSString * account;
@property (nonatomic,strong) NSString * brand;
@property (nonatomic,strong) NSString * name;
@property (nonatomic,strong) NSString * amount;
@property (nonatomic,strong) NSString * price;
@property (nonatomic,strong) NSString * business_number;
@property (nonatomic,strong) NSString * image_1;
@property (nonatomic,strong) NSString * image_2;
@property (nonatomic,strong) NSString * image_3;
@property (nonatomic,strong) NSString * is_buy;
@property (nonatomic,strong) NSString * is_distribute;
@property (nonatomic,strong) NSString * publish_time;
@property (nonatomic,strong) NSString * collection_id;
@property (nonatomic,strong) NSString * unit;
@end
