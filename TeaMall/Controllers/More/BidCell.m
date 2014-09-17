//
//  BidCell.m
//  TeaMall
//
//  Created by Carl_Huang on 14-9-5.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "BidCell.h"
#import "Bid.h"
#import "UIImageView+AFNetworking.h"

@implementation BidCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setBid:(Bid *)bid
{
    _bid = bid;
#warning 暂不处理 
//     _serviceIcon = ;
     _name.text = bid.name;
     _batch.text = bid.batch;
     _isDistribute.text = bid.is_distribute;
     _brandName.text = bid.brand_name;
     _amount.text = bid.amount;
     _price.text = bid.price;
     [_image1 setImageWithURL:[NSURL URLWithString:bid.image_1] placeholderImage:[UIImage imageNamed:@"placeHolder.png"]];
    [_image2 setImageWithURL:[NSURL URLWithString:bid.image_2] placeholderImage:[UIImage imageNamed:@"placeHolder.png"]];
    [_image3 setImageWithURL:[NSURL URLWithString:bid.image_3] placeholderImage:[UIImage imageNamed:@"placeHolder.png"]];
     _businessNumber.text = bid.business_number;
   
     _publishTime.text = [[NSDate dateFromString:bid.publish_time withFormat:@"yyyy-MM-dd HH:mm:ss"] formatDateString:@"yyyy-MM-dd"];
    
}

@end
