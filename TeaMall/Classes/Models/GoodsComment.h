//
//  GoodsComment.h
//  TeaMall
//
//  Created by Carl on 14-3-27.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "BaseModel.h"

@interface GoodsComment : BaseModel
@property (nonatomic,strong) NSString * user_id;
@property (nonatomic,strong) NSString * goods_id;
@property (nonatomic,strong) NSString * comment_time;
@property (nonatomic,strong) NSString * avatar;
@end
