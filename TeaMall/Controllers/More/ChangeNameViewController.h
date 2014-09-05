//
//  ChangeNameViewController.h
//  TeaMall
//
//  Created by Carl on 14-2-12.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "CommonViewController.h"

@interface ChangeNameViewController : CommonViewController
@property (weak, nonatomic) IBOutlet UITextField *nameField;
- (IBAction)sure:(id)sender;

@end
