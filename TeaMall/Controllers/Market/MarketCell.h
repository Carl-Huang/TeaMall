//
//  MarketCell.h
//  TeaMall
//
//  Created by vedon on 15/1/14.
//  Copyright (c) 2014 helloworld. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MarketCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *originPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *weightLabel;
@property (weak, nonatomic) IBOutlet UILabel *percentLabel;
@property (weak, nonatomic) IBOutlet UIButton *callButton;
@property (weak, nonatomic) IBOutlet UIButton *addCollectionButton;
@property (weak, nonatomic) IBOutlet UIImageView *teaImageView;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;
@end
