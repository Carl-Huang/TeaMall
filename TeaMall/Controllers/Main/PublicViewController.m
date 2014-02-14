//
//  PublicViewController.m
//  TeaMall
//
//  Created by vedon on 13/1/14.
//  Copyright (c) 2014 helloworld. All rights reserved.
//

#import "PublicViewController.h"
#import "PopupTagViewController.h"
#import "PhotoManager.h"
#import "AppDelegate.h"
@interface PublicViewController ()
{
    //品牌
    NSArray * brandArray;
    
    //数量下拉表
    PopupTagViewController * numberTable;
    
    //牌子下拉表
    PopupTagViewController * brandTable;
    
    //记录拍照的图片数量
    NSInteger currentImageCount;
    
    //保存拍照的图片
    NSMutableArray * takenPhotoArray;
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
    numberTable = nil;
    brandTable = nil;
    currentImageCount = 0;
    takenPhotoArray  = [NSMutableArray array];
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
    UIButton * btn = (UIButton *)sender;
    [btn setSelected:!btn.selected];
    if (btn.selected) {
        if (!brandTable) {
            brandTable = [[PopupTagViewController alloc]initWithNibName:@"PopupTagViewController" bundle:nil];
            NSArray * array = @[@"品牌",@"产品",@"交易号",@"升价",@"降价"];
            [brandTable setDataSource:array];
            //设置位置
            CGRect originalRect = brandTable.view.frame;
            originalRect.origin.x = btn.frame.origin.x + btn.frame.size.width/2.0 - originalRect.size.width/2;
            originalRect.origin.y = btn.frame.origin.y + btn.frame.size.height +10;
            [brandTable.view setFrame:originalRect];
            
            [brandTable setBlock:^(NSString * item){
                [btn setSelected:NO];
            }];
            [self addChildViewController:brandTable];
            [self.view addSubview:brandTable.view];
        }else
        {
            [self.view addSubview:brandTable.view];
        }
    }else
    {
        [brandTable.view removeFromSuperview];
    }
}

- (IBAction)selectedNumberAction:(id)sender {
    UIButton * btn = (UIButton *)sender;
    [btn setSelected:!btn.selected];
    if (btn.selected) {
        if (!numberTable) {
            numberTable = [[PopupTagViewController alloc]initWithNibName:@"PopupTagViewController" bundle:nil];
            NSArray * array = @[@"品牌",@"产品",@"交易号",@"升价",@"降价"];
            [numberTable setDataSource:array];
            //设置位置
            CGRect originalRect = numberTable.view.frame;
            originalRect.origin.x = btn.frame.origin.x + btn.frame.size.width/2.0 - originalRect.size.width/2;
            originalRect.origin.y = btn.frame.origin.y + btn.frame.size.height +10;
            [numberTable.view setFrame:originalRect];
            
            [numberTable setBlock:^(NSString * item){
                [btn setSelected:NO];
            }];
            [self addChildViewController:numberTable];
            [self.view addSubview:numberTable.view];
        }else
        {
            [self.view addSubview:numberTable.view];
        }
    }else
    {
        [numberTable.view removeFromSuperview];
    }
    
}

- (IBAction)isCanSanChuAction:(id)sender {
}

- (IBAction)takePhotoAction:(id)sender {
    if (currentImageCount <3) {
        AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        __weak PublicViewController * weakSelf = self;
        [[PhotoManager shareManager]setConfigureBlock:^(UIImage * image)
         {
             UIImageView * imageView = [[UIImageView alloc]initWithImage:image];
             [imageView setFrame:CGRectMake(10+(56+5)*currentImageCount, weakSelf.addImageBtn.frame.origin.y, 56, 56)];
            currentImageCount ++;
             if (currentImageCount == 3) {
                 [weakSelf.addImageBtn setHidden:YES];
             }else
             {
                 weakSelf.addImageBtn.frame = CGRectOffset(weakSelf.addImageBtn.frame, (56+5), 0);
             }
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 [weakSelf.imageContanier addSubview:imageView];
             });
             [takenPhotoArray addObject:image];
         }];
        [myDelegate.containerViewController presentViewController:[PhotoManager shareManager].camera animated:YES completion:nil];
    }else
    {
        //达到拍照上限
        [self showAlertViewWithMessage:@"最多只可以上传三张图片"];
    }
    
}

- (IBAction)choosePhotoAction:(id)sender {
    if (currentImageCount <=3) {
        AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        __weak PublicViewController * weakSelf = self;
        [[PhotoManager shareManager]setConfigureBlock:^(UIImage * image)
         {
             UIImageView * imageView = [[UIImageView alloc]initWithImage:image];
             [imageView setFrame:CGRectMake(10+(56+5)*currentImageCount, weakSelf.addImageBtn.frame.origin.y, 56, 56)];
             currentImageCount ++;
             if (currentImageCount == 3) {
                 [weakSelf.addImageBtn setHidden:YES];
             }else
             {
                 weakSelf.addImageBtn.frame = CGRectOffset(weakSelf.addImageBtn.frame, (56+5), 0);
             }
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 [weakSelf.imageContanier addSubview:imageView];
             });
             [takenPhotoArray addObject:image];
         }];
        [myDelegate.containerViewController presentViewController:[PhotoManager shareManager].pickingImageView animated:YES completion:nil];
    }else
    {
        //达到拍照上限
        [self showAlertViewWithMessage:@"最多只可以上传三张图片"];
    }
    
}
- (IBAction)wantBuyBtn:(id)sender {
}
@end
