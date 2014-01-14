//
//  TeaViewController.h
//  TeaMall
//
//  Created by vedon on 14/1/14.
//  Copyright (c) 2014 helloworld. All rights reserved.
//

#import "CommonViewController.h"

@interface TeaViewController : CommonViewController
@property (weak, nonatomic) IBOutlet UIView *productScrollView;
@property (weak, nonatomic) IBOutlet UIView *btnView;

- (IBAction)buyImmediatelyAction:(id)sender;
- (IBAction)putInCarAction:(id)sender;
@end
