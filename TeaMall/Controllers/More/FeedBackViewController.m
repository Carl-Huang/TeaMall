//
//  FeedBackViewController.m
//  TeaMall
//
//  Created by vedon on 21/1/14.
//  Copyright (c) 2014 helloworld. All rights reserved.
//

#import "FeedBackViewController.h"
#define PlaceHolder @"快把你的宝贵意见告诉我们~~~~"
#import "HttpService.h"
#import "MBProgressHUD.h"
@interface FeedBackViewController ()<UITextViewDelegate>

@end

@implementation FeedBackViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setLeftCustomBarItem:@"返回" action:nil];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MBProgressHUD hideHUDForView:self.view animated:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [self setView:nil];
    _textView = nil;
}

- (IBAction)feedbackAction:(id)sender
{
    [_textView resignFirstResponder];
    if([_textView.text length] == 0 || [_textView.text isEqualToString:PlaceHolder])
    {
        [self showAlertViewWithMessage:@"请填写您的宝贵意见!"];
        return;
    }
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"提交中...";
    [[HttpService sharedInstance] addFeedback:@{@"content":_textView.text} completionBlock:^(id object) {
        hud.labelText = @"提交成功，谢谢您的参与";
        [hud hide:YES afterDelay:1];
        _textView.text = PlaceHolder;
    } failureBlock:^(NSError *error, NSString *responseString) {
        hud.labelText = @"提交失败，请重试";
        [hud hide:YES afterDelay:1];
    }];
    
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if([textView.text isEqualToString:PlaceHolder])
    {
        textView.text = nil;
    }
}
@end
