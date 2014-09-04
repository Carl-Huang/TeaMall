//
//  RegisteredViewController.h
//  TeaMall
//
//  Created by Carl_Huang on 14-1-12.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "CommonViewController.h"

@interface RegisteredViewController : CommonViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *confirmPwd;
@property (weak, nonatomic) IBOutlet UITextField *phone;

@property (weak,nonatomic) NSString *openID;     //第三方登陆的uid
@property (weak,nonatomic) NSString *type;    //第三方登陆的方式，@"1"为QQ空间，@“2”为新浪微博

- (IBAction)registerAction:(id)sender;
@end
