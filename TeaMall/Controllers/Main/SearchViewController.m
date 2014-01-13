//
//  SearchViewController.m
//  TeaMall
//
//  Created by vedon on 13/1/14.
//  Copyright (c) 2014 helloworld. All rights reserved.
//

#import "SearchViewController.h"
#import "PopupTagViewController.h"
@interface SearchViewController ()
{
    PopupTagViewController * popupTagViewController;
}
@end

@implementation SearchViewController

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
    popupTagViewController = nil;
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showTagAction:(id)sender {
    
    UIButton * btn = (UIButton *)sender;
    [btn setSelected:!btn.selected];
    if (btn.selected) {
        if (!popupTagViewController) {
            
            popupTagViewController = [[PopupTagViewController alloc]initWithNibName:@"PopupTagViewController" bundle:nil];
            
            //设置位置
            CGRect originalRect = popupTagViewController.view.frame;
            originalRect.origin.x = btn.frame.origin.x + btn.frame.size.width - originalRect.size.width/2-15;
            originalRect.origin.y = btn.frame.origin.y + btn.frame.size.height +10;
            [popupTagViewController.view setFrame:originalRect];
            
            [popupTagViewController setBlock:^(){
                [btn setSelected:NO];
            }];
            [self addChildViewController:popupTagViewController];
            [self.view addSubview:popupTagViewController.view];
            return;
        }
        [self.view addSubview:popupTagViewController.view];
    }else
    {
        [popupTagViewController.view removeFromSuperview];
    }
    
}

- (IBAction)cancelSearchAction:(id)sender {
}
- (IBAction)clearHistoryAction:(id)sender {
}
@end
