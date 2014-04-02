//
//  NewsComment.h
//  TeaMall
//
//  Created by Carl on 14-4-1.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "BaseModel.h"

@interface NewsComment : BaseModel
@property (nonatomic,strong) NSString * user_id;
@property (nonatomic,strong) NSString * account;
@property (nonatomic,strong) NSString * content;
@property (nonatomic,strong) NSString * news_id;
@property (nonatomic,strong) NSString * comment_time;
@property (nonatomic,strong) NSString * avatar;
@end
