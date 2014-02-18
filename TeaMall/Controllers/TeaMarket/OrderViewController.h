//
//  OrderViewController.h
//  TeaMall
//
//  Created by vedon on 15/1/14.
//  Copyright (c) 2014 helloworld. All rights reserved.
//

#import "CommonViewController.h"
#import "Commodity.h"
@interface OrderViewController : CommonViewController
@property (nonatomic,strong) Commodity * commodity;
@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UIButton *priceBtn_1;
@property (weak, nonatomic) IBOutlet UIButton *priceBtn_2;
@property (weak, nonatomic) IBOutlet UIButton *priceBtn_3;
@property (weak, nonatomic) IBOutlet UILabel *productName;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *weightLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
- (IBAction)comfirmAction:(id)sender;
- (IBAction)addAmountAction:(id)sender;

- (IBAction)reduceAmountAction:(id)sender;
@end
