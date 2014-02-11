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
@property (nonatomic,strong) NSString * image;
@property (nonatomic,strong) NSString * weight;
@property (nonatomic,strong) NSString * stock;
@property (nonatomic,strong) NSString * year;
@property (nonatomic,strong) NSString * add_time;
@property (nonatomic,strong) NSString * cate;
@property (nonatomic,strong) NSString * cate_id;
@property (nonatomic,strong) NSString * update_time;
@property (nonatomic,strong) NSString * description;
@end
