//
//  FeedBackViewController.h
//  TeaMall
//
//  Created by vedon on 21/1/14.
//  Copyright (c) 2014 helloworld. All rights reserved.
//

#import "CommonViewController.h"

@interface FeedBackViewController : CommonViewController
@property (weak, nonatomic) IBOutlet UITextView *textView;
- (IBAction)feedbackAction:(id)sender;

@end
