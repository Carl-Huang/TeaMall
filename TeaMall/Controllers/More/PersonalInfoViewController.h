//
//  PersonalInfoViewController.h
//  TeaMall
//
//  Created by Carl on 14-2-12.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "CommonViewController.h"

@interface PersonalInfoViewController : CommonViewController
@property (strong, nonatomic) IBOutlet UIScrollView *scroll;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *sexLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *wechatLabel;
- (IBAction)tabkePictureAction:(id)sender;
- (IBAction)showAddressAction:(id)sender;
- (IBAction)changeNameAction:(id)sender;
- (IBAction)changeSexAction:(id)sender;
- (IBAction)changePhoneAction:(id)sender;
- (IBAction)changeWeChatAction:(id)sender;

@end
