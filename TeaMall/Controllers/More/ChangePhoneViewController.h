//
//  ChangePhoneViewController.h
//  TeaMall
//
//  Created by Carl on 14-2-12.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "CommonViewController.h"

@interface ChangePhoneViewController : CommonViewController
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
- (IBAction)sure:(id)sender;

@end
