//
//  AddAddressViewController.h
//  TeaMall
//
//  Created by Carl on 14-2-13.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "CommonViewController.h"
#import "Address.h"
@interface AddAddressViewController : CommonViewController
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UITextField *zipField;
@property (weak, nonatomic) IBOutlet UITextField *addressField;
@property (nonatomic,strong) Address * address;
@end
