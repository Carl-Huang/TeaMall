//
//  TeaMarketCell.m
//  TeaMall
//
//  Created by vedon on 14/1/14.
//  Copyright (c) 2014 helloworld. All rights reserved.
//

#import "TeaMarketCell.h"
#import "Commodity.h"
#import "UIImageView+AFNetworking.h"

@implementation TeaMarketCell

- (void)setCommodity:(Commodity *)commodity
{
    _commodity = commodity;
    self.teaWeight.text = [NSString stringWithFormat:@"%@g",commodity.weight];
    self.teaName.text = commodity.name;
    self.currentPrice.text = [NSString stringWithFormat:@"￥%@",commodity.hw__price];
    self.originalPrice.text = [NSString stringWithFormat:@"￥%@",commodity.price];
    [self.teaImage setImageWithURL:[NSURL URLWithString:commodity.image] placeholderImage:[UIImage imageNamed:@"placeHolder.png"]];
}
@end
