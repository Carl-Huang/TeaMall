//
//  NewsDetailViewController.m
//  TeaMall
//
//  Created by vedon on 18/1/14.
//  Copyright (c) 2014 helloworld. All rights reserved.
//

#import "NewsDetailViewController.h"
#import "UINavigationBar+Custom.h"
#import "CycleScrollView.h"
#import "MarketNews.h"

@interface NewsDetailViewController ()
{
    CycleScrollView * scrollView;
}
@end

@implementation NewsDetailViewController

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
    self.postImageView.image = self.poster;

    NSLog(@"%@",    self.news.title);
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
