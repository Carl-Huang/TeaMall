//
//  MainViewController.h
//  TeaMall
//
//  Created by vedon on 13/1/12.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "CommonViewController.h"

@interface MainViewController : CommonViewController

@property (weak, nonatomic) IBOutlet UIScrollView *scrollContainView;

@property (weak, nonatomic) IBOutlet UIView *adScrollBgView;
@property (weak, nonatomic) IBOutlet UIView *brandView;
@property (weak, nonatomic) IBOutlet UIView *bottomAdView;
@property (weak, nonatomic) IBOutlet UIView *scrollTextView;
-(void)gotoSquareViewController;
@end
