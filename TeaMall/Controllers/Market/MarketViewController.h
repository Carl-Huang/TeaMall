//
//  MarketViewController.h
//  TeaMall
//
//  Created by vedon on 13/1/14.
//  Copyright (c) 2014 helloworld. All rights reserved.
//

#import "CommonViewController.h"

@interface MarketViewController : CommonViewController
@property (weak, nonatomic) IBOutlet UITableView *contentTable;
@property (weak, nonatomic) IBOutlet UIButton *priceUpBtn;
@property (weak, nonatomic) IBOutlet UIButton *priceDownBtn;
@property (strong,nonatomic) NSString * keyword;
@property (strong,nonatomic) NSString * type;
- (void)setType:(NSString *)type keyword:(NSString *)keyword;
@end
