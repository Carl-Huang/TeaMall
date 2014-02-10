//
//  Category.h
//  TeaMall
//
//  Created by Carl on 14-2-10.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "BaseModel.h"

@interface TeaCategory : BaseModel
@property (nonatomic,strong) NSString * hw_id;
@property (nonatomic,strong) NSString * name;
@property (nonatomic,strong) NSString * add_time;
@property (nonatomic,strong) NSString * update_time;
@end
