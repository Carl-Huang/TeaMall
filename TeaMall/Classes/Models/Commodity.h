//
//  Commodity.h
//  TeaMall
//
//  Created by Carl on 14-1-23.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "BaseModel.h"

@interface Commodity : BaseModel
@property (nonatomic,strong) NSString * hw_id;
@property (nonatomic,strong) NSString * name;
@property (nonatomic,strong) NSString * price;
@property (nonatomic,strong) NSString * hw__price;
@property (nonatomic,strong) NSString * price_b;
@property (nonatomic,strong) NSString * price_p;
@property (nonatomic,strong) NSString * image;
@property (nonatomic,strong) NSString * image_2;
@property (nonatomic,strong) NSString * image_3;
@property (nonatomic,strong) NSString * image_4;
@property (nonatomic,strong) NSString * image_5;
@property (nonatomic,strong) NSString * weight;
@property (nonatomic,strong) NSString * stock;
@property (nonatomic,strong) NSString * year;
@property (nonatomic,strong) NSString * add_time;
@property (nonatomic,strong) NSString * cate;
@property (nonatomic,strong) NSString * cate_id;
@property (nonatomic,strong) NSString * update_time;
@property (nonatomic,strong) NSString * hw_description;
@property (nonatomic,strong) NSString * producer;                         //生产商
@property (nonatomic,strong) NSString * production;                       //生成工艺
@property (nonatomic,strong) NSString * specification;                    //规格
@property (nonatomic,strong) NSString * burden;                           //配料
@property (nonatomic,strong) NSString * storage;                          //存放方式
@end
