//
//  SquareItemCell.h
//  TeaMall
//
//  Created by vedon on 13/1/14.
//  Copyright (c) 2014 helloworld. All rights reserved.
//

#import <UIKit/UIKit.h>
@class starView;
@interface SquareItemCell : UITableViewCell

@property (weak, nonatomic) IBOutlet starView *littleStarView;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *description;
@property (weak, nonatomic) IBOutlet UILabel *userActionType;
@property (weak, nonatomic) IBOutlet UILabel *productName;
@property (weak, nonatomic) IBOutlet UILabel *productNumber;
@property (weak, nonatomic) IBOutlet UILabel *productPrice;
@property (weak, nonatomic) IBOutlet UIButton *contactServiceBtn;
@property (weak, nonatomic) IBOutlet UILabel *tractionNumber;
@property (weak, nonatomic) IBOutlet UILabel *tranctionDate;
@property (weak, nonatomic) IBOutlet UILabel *sanchuLabel;

@property (weak, nonatomic) IBOutlet UIImageView *imageView_1;
@property (weak, nonatomic) IBOutlet UIImageView *imageView_3;

@property (weak, nonatomic) IBOutlet UIImageView *imageView_2;
@end
