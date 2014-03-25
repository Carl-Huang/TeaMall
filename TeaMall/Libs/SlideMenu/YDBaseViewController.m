//
//  YDBaseViewController.m
//  SideMenuDemo
//
//  Created by Peter van de Put on 12/09/2013.
//  Copyright (c) 2013 Peter van de Put. All rights reserved.
//

#import "YDBaseViewController.h"
#import "AppDelegate.h"

@interface YDBaseViewController ()

@end

@implementation YDBaseViewController

- (AppDelegate *)appDelegate
{
	return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //if you dont want the menu buttons remove the following code 
    //Create left menu button
    UIBarButtonItem *leftRevealButtonItem = [[UIBarButtonItem alloc] initWithImage:
                                             [UIImage imageNamed:@"分类图标.png"]
                                                                             style:UIBarButtonItemStyleBordered
                                                                            target:self action:@selector(toggleLeftMenu:)];
    self.navigationItem.leftBarButtonItem = leftRevealButtonItem;
//    //create right menu button
//    
//    UIBarButtonItem *rightRevealButtonItem = [[UIBarButtonItem alloc] initWithImage:
//                                              [UIImage imageNamed:@"reveal-icon.png"]
//                                                                              style:UIBarButtonItemStyleBordered
//                                                                             target:self action:@selector(toggleRightMenu:)];
//    self.navigationItem.rightBarButtonItem = rightRevealButtonItem;
}

-(void)toggleLeftMenu:(id)sender
{
    [[self appDelegate] toggleLeftMenu:YES];
}
-(void)toggleRightMenu:(id)sender
{
//    [[self appDelegate] toggleRightMenu];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
