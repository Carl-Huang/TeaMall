//
//  NewsDetailViewController.m
//  TeaMall
//
//  Created by vedon on 18/1/14.
//  Copyright (c) 2014 helloworld. All rights reserved.
//

#import "ScrollNewsDetailViewController.h"
#import "UINavigationBar+Custom.h"
#import "CycleScrollView.h"
#import "MarketNews.h"

@interface ScrollNewsDetailViewController ()
{
    CycleScrollView * scrollView;
}
@end

@implementation ScrollNewsDetailViewController

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
    //[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"顶栏"]];
    [self setLeftCustomBarItem:@"返回" action:nil];
    self.postImageView.image = self.poster;

    self.productName.text   = self.news.title;
    self.cost.text          = self.news.per_fee;
    self.address.text       = self.news.address;
    self.openTime.text      = [NSString stringWithFormat:@"%@-%@",self.news.business_start_time,self.news.business_end_time];
    self.travel.text        = self.news.bus_path;
    self.intro.text         = self.news.description;
    if ([self.news.is_free_parking isEqualToString:@"0"]) {
        self.partSquare.text = @"不提供免费停车服务";
    }else
    {
        self.partSquare.text = @"免费停车";
    }
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
