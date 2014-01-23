//
//  MarketNews.h
//  TeaMall
//
//  Created by Carl on 14-1-23.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "BaseModel.h"

@interface MarketNews : BaseModel
@property (nonatomic,strong) NSString * hw_id;
@property (nonatomic,strong) NSString * title;
@property (nonatomic,strong) NSString * address;
@property (nonatomic,strong) NSString * description;
@property (nonatomic,strong) NSString * image;
@property (nonatomic,strong) NSString * business_start_time;
@property (nonatomic,strong) NSString * business_end_time;
@property (nonatomic,strong) NSString * bus_path;
@property (nonatomic,strong) NSString * is_free_parking;
@property (nonatomic,strong) NSString * per_fee;
@property (nonatomic,strong) NSString * add_time;
@property (nonatomic,strong) NSString * update_time;
@property (nonatomic,strong) NSString * is_top;
@end
