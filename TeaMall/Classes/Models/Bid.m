//
//  Bid.m
//  TeaMall
//
//  Created by Carl_Huang on 14-9-5.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "Bid.h"

@implementation Bid

- (NSString *)description
{
    return [NSString stringWithFormat:@"Bid: %p,%@,%@,%@",self,self.name,self.brand_name,self.add_time];
}

@end
