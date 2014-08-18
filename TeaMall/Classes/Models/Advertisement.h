//
//  Advertisement.h
//  TeaMall
//
//  Created by Carl on 14-5-18.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "BaseModel.h"

@interface Advertisement : BaseModel
@property (nonatomic,strong) NSString * hw_id;
@property (nonatomic,strong) NSString * url;
@property (nonatomic,strong) NSString * image;
@property (nonatomic,strong) NSString * type;
@property (nonatomic,strong) NSString * add_time;
@property (nonatomic,strong) NSString * update_time;
@end
