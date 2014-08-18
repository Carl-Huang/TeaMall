//
//  TeaViewController.h
//  TeaMall
//
//  Created by vedon on 14/1/14.
//  Copyright (c) 2014 helloworld. All rights reserved.
//

#import "CommonViewController.h"
#import "Commodity.h"
@interface TeaViewController : CommonViewController
@property (weak, nonatomic) IBOutlet UIView *productScrollView;
@property (weak, nonatomic) IBOutlet UIView *btnView;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *storageLabel;
@property (weak, nonatomic) IBOutlet UILabel *saleLabel;
@property (nonatomic,strong) Commodity * commodity;
- (IBAction)buyImmediatelyAction:(id)sender;
- (IBAction)putInCarAction:(id)sender;
- (IBAction)showCommentVC:(id)sender;

@end
