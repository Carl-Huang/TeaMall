//
//  MarketViewController.m
//  TeaMall
//
//  Created by vedon on 13/1/14.
//  Copyright (c) 2014 helloworld. All rights reserved.
//

#import "MarketViewController.h"
#import "UIViewController+AKTabBarController.h"
#import "MarketCell.h"
@interface MarketViewController ()

@end

@implementation MarketViewController

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
    [self.priceDownBtn addTarget:self action:@selector(priceDownAction) forControlEvents:UIControlEventTouchUpInside];
    [self.priceUpBtn addTarget:self action:@selector(priceUpAction) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)priceDownAction
{
    NSLog(@"%s",__func__);  
}

-(void)priceUpAction
{
    NSLog(@"%s",__func__);
}
#pragma mark - Private Methods
- (NSString *)tabImageName
{
	return @"市场行情-图标（黑）";
}

- (NSString *)tabTitle
{
	return nil;
}

- (void)initUI
{
    
}

@end
