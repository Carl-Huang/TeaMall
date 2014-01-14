//
//  TeaViewController.m
//  TeaMall
//
//  Created by vedon on 14/1/14.
//  Copyright (c) 2014 helloworld. All rights reserved.
//

#import "TeaViewController.h"
#import "UIViewController+BarItem.h"
@interface TeaViewController ()

@end

@implementation TeaViewController

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
    
    
    UIBarButtonItem * flexBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem * shareItem = [self customBarItem:@"分享图标（未选中状态）" highLightImageName:@"分享图标（选中状态）" action:@selector(share) size:CGSizeMake(35,30)];
    UIBarButtonItem * loveItem = [self customBarItem:@"收藏（爱心）" highLightImageName:@"收藏（爱心）" action:@selector(love) size:CGSizeMake(35,30)];
    self.navigationItem.rightBarButtonItems = @[loveItem,shareItem,flexBarItem];
 
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)share
{
     NSLog(@"%s",__func__);
}

-(void)love
{
    NSLog(@"%s",__func__);
}
@end
