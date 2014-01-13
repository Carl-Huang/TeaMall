//
//  PublicViewController.m
//  TeaMall
//
//  Created by vedon on 13/1/14.
//  Copyright (c) 2014 helloworld. All rights reserved.
//

#import "PublicViewController.h"

@interface PublicViewController ()
{
    //品牌
    NSArray * brandArray;
}
@end

@implementation PublicViewController

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
    brandArray = @[@"HTC",@"Apple",@"Nokia"@"Sangsun"];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)IwantBuyAction:(id)sender {
    UIButton * btn = (UIButton *)sender;
    [btn setSelected:!btn.selected];
    [self.wantSellBtn setSelected:NO];
}

- (IBAction)IwantSellAction:(id)sender {
    UIButton * btn = (UIButton *)sender;
    [btn setSelected:!btn.selected];
    [self.wantBuyBtn setSelected:NO];
}

- (IBAction)selectedBrandAction:(id)sender {
}

- (IBAction)selectedNumberAction:(id)sender {
}

- (IBAction)isCanSanChuAction:(id)sender {
}

- (IBAction)takePhotoAction:(id)sender {
}

- (IBAction)choosePhotoAction:(id)sender {
}
- (IBAction)wantBuyBtn:(id)sender {
}
@end
