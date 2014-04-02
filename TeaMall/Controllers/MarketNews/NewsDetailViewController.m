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
#import "ShareManager.h"
#import "ShareView.h"
#import "MBProgressHUD.h"
#import "SDWebImageManager.h"
#import "NewsCommentViewController.h"
#import <ShareSDK/ShareSDK.h>
typedef enum _ANCHOR
{
    TOP_LEFT,
    TOP,
    TOP_RIGHT,
    LEFT,
    CENTER,
    RIGHT,
    BOTTOM_LEFT,
    BOTTOM,
    BOTTOM_RIGHT
} ANCHOR;
@interface NewsDetailViewController ()
{
    CycleScrollView * scrollView;
    ShareView * shareView;
    UIView * blurView;

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
    //[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"顶栏"]];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideShareView)];
    [self.view addGestureRecognizer:tap];
    tap = nil;

    [self setLeftCustomBarItem:@"返回" action:nil];
    UIBarButtonItem * shareItem = [self customBarItem:@"分享图标（未选中状态）" highLightImageName:@"分享图标（选中状态）" action:@selector(share) size:CGSizeMake(28,22)];
    UIBarButtonItem * commentItem = [self customBarItem:@"评论按钮1" action:@selector(commentAction:)];
    self.navigationItem.rightBarButtonItems = @[shareItem,commentItem];
    self.postImageView.image = self.poster;
    self.scrolView.contentSize = CGSizeMake(320, 260);
    self.productName.text   = self.news.title;
    self.cost.text          = self.news.per_fee;
    self.address.text       = self.news.address;
    self.openTime.text      = [NSString stringWithFormat:@"%@-%@",self.news.business_start_time,self.news.business_end_time];
    self.travel.text        = self.news.bus_path;
    self.intro.text         = self.news.description;
    if ([self.news.is_free_parking isEqualToString:@"0"])
    {
        self.partSquare.text = @"不提供免费停车服务";
    }
    else
    {
        self.partSquare.text = @"免费停车";
    }
    
    //分享的背景遮罩
    blurView = [[UIView alloc]initWithFrame:self.view.frame];
    [blurView setBackgroundColor:[UIColor blackColor]];
    blurView.alpha = 0.6;
    [self.view addSubview:blurView];
    [blurView setHidden:YES];
    
    //分享
    shareView = [[[NSBundle mainBundle]loadNibNamed:@"ShareView" owner:self options:nil]objectAtIndex:0];
    [shareView.shareToWeiXinBtn addTarget:self action:@selector(shareToWeiXinAction) forControlEvents:UIControlEventTouchUpInside];
    [shareView.shareToWeiboBtn addTarget:self action:@selector(shareToWeiboAction) forControlEvents:UIControlEventTouchUpInside];
    [shareView.shareToQQZoneBtn addTarget:self action:@selector(shareToQQZoneAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shareView];
    //适配屏幕
    [self anchor:shareView to:BOTTOM withOffset:CGPointMake(0, 80)];
    [shareView setHidden:YES];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)commentAction:(id)sender
{
    NewsCommentViewController * vc = [[NewsCommentViewController alloc] initWithNibName:nil bundle:nil];
    vc.newsID = _news.hw_id;
    [self push:vc];
    vc = nil;
}

-(void)share
{
    NSLog(@"%s",__func__);
//    [shareView setHidden:NO];
//    [blurView setHidden:NO];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager downloadWithURL:[NSURL URLWithString:_news.image] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        ;
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (image)
        {
            UIImage * scaleImage = [image imageWithScale:.3f];
            [self shareWithTitle:_news.title withContent:_news.description withURL:@"http://www.yichatea.com/" withImage:scaleImage withDescription:_news.title];
        }
    }];

}


-(void)hideShareView
{
    [shareView setHidden:YES];
    [blurView setHidden:YES];
}
-(void)anchor:(UIView*)obj to:(ANCHOR)anchor withOffset:(CGPoint)offset
{
    NSInteger statusHeight = 20;
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGRect frm = obj.frame;
    
    if (![[UIApplication sharedApplication] isStatusBarHidden]) {
        screenSize.height -=statusHeight;
    }
    switch (anchor) {
        case TOP_LEFT:
            frm.origin = offset;
            break;
        case TOP:
            frm.origin.x = (screenSize.width - frm.size.width) / 2 + offset.x;
            frm.origin.y = offset.y;
            break;
        case TOP_RIGHT:
            frm.origin.x = screenSize.width - frm.size.width - offset.x;
            frm.origin.y = offset.y;
            break;
        case LEFT:
            frm.origin.x = offset.x;
            frm.origin.y = (screenSize.height - frm.size.height) / 2 + offset.y;
            break;
        case CENTER:
            frm.origin.x = (screenSize.width - frm.size.width) / 2 + offset.x;
            frm.origin.y = (screenSize.height - frm.size.height) / 2 + offset.y;
            break;
        case RIGHT:
            frm.origin.x = screenSize.width - frm.size.width - offset.x;
            frm.origin.y = (screenSize.height - frm.size.height) / 2 + offset.y;
            break;
        case BOTTOM_LEFT:
            frm.origin.x = offset.x;
            frm.origin.y = screenSize.height - frm.size.height - offset.y;
            break;
        case BOTTOM: // 保证贴屏底
            frm.origin.x = (screenSize.width - frm.size.width) / 2 + offset.x;
            frm.origin.y = screenSize.height - frm.size.height - offset.y;
            break;
        case BOTTOM_RIGHT:
            frm.origin.x = screenSize.width - frm.size.width - offset.x;
            frm.origin.y = screenSize.height - frm.size.height - offset.y;
            break;
    }
    
    obj.frame = frm;
}


-(void)shareToWeiXinAction
{
    NSLog(@"%s",__func__);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager downloadWithURL:[NSURL URLWithString:_news.image] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        ;
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
        if (image)
        {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            UIImage * scaleImage = [image imageWithScale:.3f];
            [[ShareManager shareManager] shareToWeiXinContentWithTitle:_news.title content:_news.description image:scaleImage];
        }
    }];
}



-(void)shareToWeiboAction
{
    NSLog(@"%s",__func__);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager downloadWithURL:[NSURL URLWithString:_news.image] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        ;
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
        if (image)
        {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            UIImage * scaleImage = [image imageWithScale:.3f];
            [[ShareManager shareManager] shareToSinaWeiboWithTitle:_news.title content:_news.description image:scaleImage];
        }
    }];
}

-(void)shareToQQZoneAction
{
    NSLog(@"%s",__func__);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager downloadWithURL:[NSURL URLWithString:_news.image] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        ;
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
        if (image)
        {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            UIImage * scaleImage = [image imageWithScale:.3f];
            [[ShareManager shareManager] shareToQQSpaceWithTitle:_news.title content:_news.description image:scaleImage];
        }
    }];
}


- (void)shareWithTitle:(NSString *)title withContent:(NSString *)content withURL:(NSString *)url withImage:(UIImage *)image withDescription:(NSString *)desc
{
    NSArray *shareList = [ShareSDK getShareListWithType:
                          ShareTypeWeixiSession,
                          ShareTypeWeixiTimeline,
                          ShareTypeSinaWeibo,
                          ShareTypeQQSpace,
                          //ShareTypeSMS,
                          nil];
    //定义容器
    id<ISSContainer> container = [ShareSDK container];
    [container setIPhoneContainerWithViewController:self];
    //定义分享内容
    id<ISSContent> publishContent = nil;
    
    NSString *contentString = content;
    NSString *titleString   = title;
    NSString *urlString     = url;
    NSString *description   = desc;
    
    publishContent = [ShareSDK content:contentString
                        defaultContent:@""
                                 image:[ShareSDK jpegImageWithImage:image quality:1]
                                 title:titleString
                                   url:urlString
                           description:description
                             mediaType:SSPublishContentMediaTypeNews];
    
    //定义分享设置
    id<ISSShareOptions> shareOptions = [ShareSDK simpleShareOptionsWithTitle:@"分享" shareViewDelegate:nil];
    
    [ShareSDK showShareActionSheet:container
                         shareList:shareList
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions:shareOptions
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                
                                if (state == SSResponseStateSuccess)
                                {
                                    NSLog(NSLocalizedString(@"TEXT_ShARE_SUC", @"分享成功"));
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
                                }
                            }];
}


@end
