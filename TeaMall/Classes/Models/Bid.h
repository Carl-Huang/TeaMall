//
//  Bid.h
//  TeaMall
//
//  Created by Carl_Huang on 14-9-5.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "BaseModel.h"

@interface Bid : NSObject

@property (nonatomic,strong) NSString *add_time;
@property (nonatomic,strong) NSString *amount;
@property (nonatomic,strong) NSString *batch;
@property (nonatomic,strong) NSString *brand;
@property (nonatomic,strong) NSString *brand_name;
@property (nonatomic,strong) NSString *business_number;
@property (nonatomic,strong) NSString *details;
@property (nonatomic,strong) NSString *image_1;
@property (nonatomic,strong) NSString *image_2;
@property (nonatomic,strong) NSString *image_3;
@property (nonatomic,strong) NSString *is_buy;
@property (nonatomic,strong) NSString *is_distribute;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *price;
@property (nonatomic,strong) NSString *publish_id;
@property (nonatomic,strong) NSString *publish_time;
@property (nonatomic,strong) NSString *publisher_id;
@property (nonatomic,strong) NSString *shopping_id;
@property (nonatomic,strong) NSString *status;
@property (nonatomic,strong) NSString *supply;
@property (nonatomic,strong) NSString *unit;

@end


/*
 "add_time" = "2014-09-02 15:45:34";
 amount = 5;
 batch = 401;
 brand = 3;
 "brand_name" = "\U5927\U76ca";
 "business_number" = 7EAVXQUC3VJ0KKI;
 details = "<null>";
 "image_1" = "<null>";
 "image_2" = "<null>";
 "image_3" = "<null>";
 "is_buy" = 1;
 "is_distribute" = 0;
 name = "\U7384\U82b1\U6597";
 price = "10500.00";
 "publish_id" = 2095;
 "publish_time" = "2014-07-26 11:50:26";
 "publisher_id" = 56;
 "shopping_id" = 2;
 status = 1;
 supply = "<null>";
 unit = "\U4ef6";
 */