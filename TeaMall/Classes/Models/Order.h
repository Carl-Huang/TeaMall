//
//  Order.h
//  TeaMall
//
//  Created by Carl on 14-2-21.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "BaseModel.h"

@interface Order : BaseModel
@property (nonatomic,strong) NSString * hw_id;
@property (nonatomic,strong) NSString * user_id;
@property (nonatomic,strong) NSString * order_number;
@property (nonatomic,strong) NSString * goods_id;
@property (nonatomic,strong) NSString * goods_name;
@property (nonatomic,strong) NSString * goods_price;
@property (nonatomic,strong) NSString * amount;
@property (nonatomic,strong) NSString * unit;
@property (nonatomic,strong) NSString * status;
@property (nonatomic,strong) NSString * consignee;
@property (nonatomic,strong) NSString * phone;
@property (nonatomic,strong) NSString * zip;
@property (nonatomic,strong) NSString * address;
@property (nonatomic,strong) NSString * total_price;
+ (NSString *)generateTradeNO;
@end
