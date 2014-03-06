//
//  OrderViewController.m
//  TeaMall
//
//  Created by vedon on 15/1/14.
//  Copyright (c) 2014 helloworld. All rights reserved.
//

#import "OrderViewController.h"
#import "UIViewController+BarItem.h"
#import "OrderAddressDetailViewController.h"
#import "UIImageView+AFNetworking.h"
#import "User.h"
#import "LoginViewController.h"
#import <objc/runtime.h>
@interface OrderViewController ()

@end

@implementation OrderViewController

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
    
    if(![OSHelper iPhone5])
    {
        CGRect rect = self.view.frame;
        rect.size.height = 367;
        [self.view setFrame:rect];
        
        CGRect bottomRect = _bottomView.frame;
        bottomRect.origin.y = 237.0f;
        _bottomView.frame = bottomRect;
    }

    _productName.text = _commodity.name;
    _priceLabel.text = [NSString stringWithFormat:@"￥%@",_commodity.hw__price];
    _weightLabel.text = [NSString stringWithFormat:@"%@g",_commodity.weight];
    [_productImageView setImageWithURL:[NSURL URLWithString:_commodity.image]];
    [_priceBtn_1 setTitle:[NSString stringWithFormat:@"￥%@",_commodity.hw__price] forState:UIControlStateNormal];
    [_priceBtn_2 setTitle:[NSString stringWithFormat:@"￥%@",_commodity.price_b] forState:UIControlStateNormal];
    [_priceBtn_3 setTitle:[NSString stringWithFormat:@"￥%@",_commodity.price_p] forState:UIControlStateNormal];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)comfirmAction:(id)sender {
//    NSString * amountKey = @"amount";
//    NSString * typeKey = @"type";
//    objc_setAssociatedObject(_commodity,&amountKey ,_amountLabel.text, OBJC_ASSOCIATION_RETAIN);
//    if(_priceBtn_1.selected)
//    {
//        objc_setAssociatedObject(_commodity, &typeKey, @"1", OBJC_ASSOCIATION_RETAIN);
//    }
//    
//    if(_priceBtn_2.selected)
//    {
//        objc_setAssociatedObject(_commodity, &typeKey, @"2", OBJC_ASSOCIATION_RETAIN);
//    }
//    
//    if(_priceBtn_3.selected)
//    {
//        objc_setAssociatedObject(_commodity, &typeKey, @"3", OBJC_ASSOCIATION_RETAIN);
//    }
    User * user = [User userFromLocal];
    if(user == nil)
    {
        LoginViewController * vc = [[LoginViewController alloc] initWithNibName:nil bundle:nil];
        vc.isNeedGoBack = YES;
        [self push:vc];
        vc = nil;
        //[self showAlertViewWithMessage:@"请先登录，谢谢"];
        return;
    }
    OrderAddressDetailViewController * viewController = [[OrderAddressDetailViewController alloc]initWithNibName:@"OrderAddressDetailViewController" bundle:nil];
    viewController.commodity = _commodity;
    viewController.amount = _amountLabel.text;
    if(_priceBtn_1.selected)
    {
        viewController.commodityType = @"1";
    }
    if(_priceBtn_2.selected)
    {
        viewController.commodityType = @"2";
    }
    if(_priceBtn_3.selected)
    {
        viewController.commodityType = @"3";
    }
    [self.navigationController pushViewController: viewController animated:YES];
    viewController = nil;
}

- (IBAction)addAmountAction:(id)sender
{
    int amount = [_amountLabel.text intValue];
    if(amount == [_commodity.stock intValue])
    {
        [self showAlertViewWithMessage:@"库存不足"];
        return ;
    }
    amount += 1;
    _amountLabel.text = [NSString stringWithFormat:@"%i",amount];
}

- (IBAction)reduceAmountAction:(id)sender
{
    int amount = [_amountLabel.text intValue];
    if(amount == 1)
    {
        return ;
    }
    amount -= 1;
    _amountLabel.text = [NSString stringWithFormat:@"%i",amount];
}

- (IBAction)priceBtn1Action:(id)sender
{
    [_priceBtn_1 setSelected:YES];
    [_priceBtn_2 setSelected:NO];
    [_priceBtn_3 setSelected:NO];
}

- (IBAction)priceBtn2Action:(id)sender
{
    [_priceBtn_2 setSelected:YES];
    [_priceBtn_1 setSelected:NO];
    [_priceBtn_3 setSelected:NO];
}

- (IBAction)priceBtn3Action:(id)sender
{
    [_priceBtn_3 setSelected:YES];
    [_priceBtn_1 setSelected:NO];
    [_priceBtn_2 setSelected:NO];
}
@end
