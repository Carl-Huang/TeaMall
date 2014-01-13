//
//  PublicViewController.h
//  TeaMall
//
//  Created by vedon on 13/1/14.
//  Copyright (c) 2014 helloworld. All rights reserved.
//

#import "CommonViewController.h"

@interface PublicViewController : CommonViewController
- (IBAction)IwantBuyAction:(id)sender;
- (IBAction)IwantSellAction:(id)sender;

- (IBAction)selectedBrandAction:(id)sender;
- (IBAction)selectedNumberAction:(id)sender;
- (IBAction)isCanSanChuAction:(id)sender;
- (IBAction)takePhotoAction:(id)sender;
- (IBAction)choosePhotoAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *productName;
@property (weak, nonatomic) IBOutlet UITextField *productPrice;
@property (weak, nonatomic) IBOutlet UIButton *wantSellBtn;
@property (weak, nonatomic) IBOutlet UIButton *wantBuyBtn;


@end
