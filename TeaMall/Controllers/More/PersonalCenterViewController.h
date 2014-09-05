//
//  PersonalCenterViewController.h
//  TeaMall
//
//  Created by Vedon on 16-1-12.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "CommonViewController.h"





@interface PersonalCenterViewController : CommonViewController
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
- (IBAction)myPersonalDataBtnAciton:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *photeImageView;
- (IBAction)MyPublicBtnAction:(id)sender;
- (IBAction)MyCollectBtnAction:(id)sender;
- (IBAction)myShoppingCarBtnAction:(id)sender;
- (IBAction)showAddressAction:(id)sender;
- (IBAction)myBidBtnAction:(id)sender;//我拍下的

- (IBAction)ZhifubaoAction:(id)sender;

@end
