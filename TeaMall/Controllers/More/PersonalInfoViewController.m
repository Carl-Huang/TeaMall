//
//  PersonalInfoViewController.m
//  TeaMall
//
//  Created by Carl on 14-2-12.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "PersonalInfoViewController.h"
#import "MyAddressViewController.h"
#import "ChangeSexViewController.h"
#import "ChangeNameViewController.h"
#import "ChangeRealNameViewController.h"
#import "ChangePhoneViewController.h"
#import "ChangeWeChatViewController.h"
#import "ChangeShopNameViewController.h"
#import "CustomiseServiceViewController.h"
#import "User.h"
#import "CustomerService.h"
#import "PhotoManager.h"
#import "ControlCenter.h"
#import "AppDelegate.h"
#import "Constants.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"
#import "HttpService.h"
#import "GTMBase64.h"
#import <QuartzCore/QuartzCore.h>
@interface PersonalInfoViewController ()<UIActionSheetDelegate,UIScrollViewDelegate>
@property (nonatomic,strong) User * user;
@end

@implementation PersonalInfoViewController

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
    self.scroll.showsVerticalScrollIndicator = NO;
    self.scroll.contentSize = CGSizeMake(0, 455);
    _photoImageView.layer.cornerRadius = 10.0;
    _photoImageView.layer.masksToBounds = YES;

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _user = [User userFromLocal];
    if(_user.account)
    {
        _nameLabel.text = _user.account;
    }
    else
    {
        _nameLabel.text = @"";
    }
    
    if(_user.sex)
    {
        if([_user.sex isEqualToString:@"1"])
        {
            _sexLabel.text = @"男";
        }
        else
        {
            _sexLabel.text = @"女";
        }
    }
    else
    {
        _sexLabel.text = @"";
    }
    
    if(_user.phone)
    {
        _phoneLabel.text = _user.phone;
    }
    else
    {
        _phoneLabel.text = @"";
    }
    
    if(_user.wechat)
    {
        _wechatLabel.text = _user.wechat;
    }
    else
    {
        _wechatLabel.text = @"";
    }
    
    _realNameLabel.text = _user.real_name?_user.real_name:@"";
    
    _shopNameLabel.text = _user.shop_name?_user.shop_name:@"";

    //根据客服ID拿到客服的电话
//#warning 未处理
//    NSString *phone = [self getCustomServiceWithID:_user.service];
    _serviceLabel.text = _user.service?_user.service:@"";

    
//    NSURL * URL = [IO URLForResource:Avatar_Name inDirectory:Image_Path];
//    if([IO isFileExistAtPath:[URL path]])
//    {
//        _photoImageView.image = [UIImage imageWithContentsOfFile:[URL path]];
//    }
    if(_user.avatar)
    {
        [_photoImageView setImageWithURL:[NSURL URLWithString:_user.avatar]];
    }
}

//#pragma mark - 根据客服ID拿到客服的电话
//- (NSString *)getCustomServiceWithID:(NSString *)serviceID
//{
//   
//    return nil;
//}


- (IBAction)tabkePictureAction:(id)sender
{
    AppDelegate * appDelegate = [ControlCenter appDelegate];
    UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
    [actionSheet showInView:appDelegate.akTabBarController.view];
    actionSheet = nil;
}

- (IBAction)showAddressAction:(id)sender
{
    MyAddressViewController * vc = [[MyAddressViewController alloc] initWithNibName:nil bundle:nil];
    [self push:vc];
    vc = nil;
}

- (IBAction)changeNameAction:(id)sender
{
    ChangeNameViewController * vc = [[ChangeNameViewController alloc] initWithNibName:nil bundle:nil];
    [self push:vc];
    vc = nil;
}

- (IBAction)changeRealNameAction:(id)sender
{
    ChangeRealNameViewController * vc = [[ChangeRealNameViewController alloc] initWithNibName:nil bundle:nil];
    [self push:vc];
    vc = nil;
}

- (IBAction)changeSexAction:(id)sender
{
    ChangeSexViewController * vc = [[ChangeSexViewController alloc] initWithNibName:nil bundle:nil];
    [self push:vc];
    vc = nil;
}

- (IBAction)changePhoneAction:(id)sender
{
    ChangePhoneViewController * vc = [[ChangePhoneViewController alloc] initWithNibName:nil bundle:nil];
    [self push:vc];
    vc = nil;
}

- (IBAction)changeWeChatAction:(id)sender
{
    ChangeWeChatViewController * vc = [[ChangeWeChatViewController alloc] initWithNibName:nil bundle:nil];
    [self push:vc];
    vc = nil;
}

- (IBAction)changeShopName:(id)sender
{
    ChangeShopNameViewController * vc = [[ChangeShopNameViewController alloc] initWithNibName:nil bundle:nil];
    [self push:vc];
    vc = nil;
}

- (IBAction)changeService:(id)sender
{
    CustomiseServiceViewController * vc = [[CustomiseServiceViewController alloc] initWithNibName:nil bundle:nil];
    vc.myParentController = self;
    [self push:vc];
    vc = nil;
}




- (void)choosePicture
{
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    __weak PersonalInfoViewController * weakSelf = self;
    [[PhotoManager shareManager]setConfigureBlock:^(UIImage * image)
     {
         UIImage * editeImage = [image imageWithScale:.5];
         weakSelf.photoImageView.image = editeImage;
         NSString * path = [[IO URLForResource:Avatar_Name inDirectory:Image_Path] path];
         [IO deleteFileAtPath:path];
         NSData * data = UIImagePNGRepresentation(editeImage);
         [data writeToFile:path atomically:YES];
         [self updateUserInfo];
         
     }];
    [myDelegate.containerViewController presentViewController:[PhotoManager shareManager].pickingImageView animated:YES completion:nil];
}

- (void)takePicture
{
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    //__weak PersonalInfoViewController * weakSelf = self;
    [[PhotoManager shareManager]setConfigureBlock:^(UIImage * image)
     {
         UIImage * editeImage = [image imageWithScale:.5];
         //weakSelf.photoImageView.image = editeImage;
         NSString * path = [[IO URLForResource:Avatar_Name inDirectory:Image_Path] path];
         [IO deleteFileAtPath:path];
         NSData * data = UIImagePNGRepresentation(editeImage);
         [data writeToFile:path atomically:YES];
         [self updateUserInfo];
     }];
    [myDelegate.containerViewController presentViewController:[PhotoManager shareManager].camera animated:YES completion:nil];
}

- (void)updateUserInfo
{
    
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"更新中...";
    NSString * path = [[IO URLForResource:Avatar_Name inDirectory:Image_Path] path];
    NSData * imageData = [NSData dataWithContentsOfFile:path];
    NSString * base64String = [GTMBase64 encodeBase64Data:imageData];
    NSDictionary * params = @{@"id":_user.hw_id,@"avatar":base64String};
    [[HttpService sharedInstance] updateUserInfo:params completionBlock:^(id object) {
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"更新成功";
        [hud hide:YES afterDelay:1];
        User * newUser = (User *)object;
        _user.avatar = newUser.avatar;
        [_photoImageView setImageWithURL:[NSURL URLWithString:_user.avatar]];
        [User saveToLocal:_user];
    } failureBlock:^(NSError *error, NSString *responseString) {
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"更新失败";
        [hud hide:YES afterDelay:1];
    }];
}

#pragma mark - UIActionSheetDelegate Methods
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"%i",buttonIndex);
    if(buttonIndex == 0)
    {
        [self takePicture];
    }
    else if(buttonIndex == 1)
    {
        [self choosePicture];
    }
}

- (void)actionSheetCancel:(UIActionSheet *)actionSheet
{
    [actionSheet dismissWithClickedButtonIndex:actionSheet.cancelButtonIndex animated:YES];
}


@end
