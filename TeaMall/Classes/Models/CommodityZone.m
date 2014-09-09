//
//  CommodityZone.m
//  TeaMall
//
//  Created by Carl_Huang on 14-8-29.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//  商品专区模型

#import "CommodityZone.h"

@implementation CommodityZone

+ (CommodityZone *)CommodityZoneWithDict:(NSDictionary *)dict
{
    CommodityZone *zone = [[CommodityZone alloc] init];
    zone.hw_id = dict[@"id"];
    zone.name = dict[@"name"];
    zone.image = dict[@"image"];
    zone.add_time = dict[@"add_time"];
    return zone;
}

@end
