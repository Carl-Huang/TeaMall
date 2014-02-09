//
//  CustomerService.h
//  TeaMall
//
//  Created by Carl on 14-2-9.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "BaseModel.h"

@interface CustomerService : BaseModel
@property (nonatomic,strong) NSString * hw_id;
@property (nonatomic,strong) NSString * contact;
@property (nonatomic,strong) NSString * phone;
@property (nonatomic,strong) NSString * level;
@property (nonatomic,strong) NSString * image;
@property (nonatomic,strong) NSString * add_time;
@property (nonatomic,strong) NSString * update_time;
@end
