//
//  MyCarTableCell.h
//  TeaMall
//
//  Created by Vedon on 14-1-13.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCarTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *commodityImageView;
@property (weak, nonatomic) IBOutlet UILabel *commodityNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *weightLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel_1;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel_2;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel_3;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *allMoneyLabel;

@property (weak, nonatomic) IBOutlet UIButton *checkBtn;
@end
