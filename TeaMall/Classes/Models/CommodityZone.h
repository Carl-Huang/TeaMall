//
//  CommodityZone.h
//  TeaMall
//
//  Created by Carl_Huang on 14-8-29.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "BaseModel.h"

@interface CommodityZone : BaseModel

@property (nonatomic,strong) NSString * hw_id;
@property (nonatomic,strong) NSString * name;
@property (nonatomic,strong) NSString * image;
@property (nonatomic,strong) NSString * add_time;
@property (nonatomic,strong) NSString * update_time;
//存放Commodity的数组
@property (nonatomic,strong) NSArray * goods_list;

+ (CommodityZone *)CommodityZoneWithDict:(NSDictionary *)dict;

@end
