//
//  BidCell.h
//  TeaMall
//
//  Created by Carl_Huang on 14-9-5.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Bid;

@interface BidCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *serviceIcon;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *batch;
@property (weak, nonatomic) IBOutlet UILabel *isDistribute;
@property (weak, nonatomic) IBOutlet UILabel *brandName;
@property (weak, nonatomic) IBOutlet UILabel *amount;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UIImageView *image1;
@property (weak, nonatomic) IBOutlet UIImageView *image2;
@property (weak, nonatomic) IBOutlet UIImageView *image3;
@property (weak, nonatomic) IBOutlet UILabel *businessNumber;
@property (weak, nonatomic) IBOutlet UILabel *publishTime;

@property (strong, nonatomic) Bid *bid;

@end
