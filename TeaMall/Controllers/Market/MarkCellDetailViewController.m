//
//  MarkCellDetailViewController.m
//  TeaMall
//
//  Created by vedon on 15/1/14.
//  Copyright (c) 2014 helloworld. All rights reserved.
//
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
#import <ShareSDK/ShareSDK.h>
#import "PersistentStore.h"
#import "MarkCellDetailViewController.h"
#import "CycleScrollView.h"
#import "UIViewController+BarItem.h"
#import "CustomiseServiceViewController.h"
#import "SDWebImageManager.h"
#import "ShareView.h"
#import "ShareManager.h"
#import "ProductCollection.h"
#import "User.h"
#import "MBProgressHUD.h"
#import "HttpService.h"
static NSString * cellIdentifier = @"cellIdentifier";
@interface MarkCellDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSString * identifier;
    NSString * contentIdentifier;
    ShareView * shareView;
    UIView * blurView;
    User * user;

    BOOL isPlaceHolderImage;
}
@property (nonatomic,strong) CycleScrollView *autoScrollView ;
@property (strong ,nonatomic) NSMutableArray * autoScrollviewDataSource;
@end

@implementation MarkCellDetailViewController
@synthesize autoScrollView,autoScrollviewDataSource;

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
#ifdef iOS7_SDK
    if ([OSHelper iOS7]) {
        self.contentTable.separatorInset = UIEdgeInsetsZero;
    }
#endif
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideShareView)];
    [self.view addGestureRecognizer:tap];
    tap = nil;
    user = [User userFromLocal];
    [self setLeftCustomBarItem:@"返回" action:nil];
    UIBarButtonItem * flexBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem * shareItem = [self customBarItem:@"分享图标（未选中状态）" highLightImageName:@"分享图标（选中状态）" action:@selector(share) size:CGSizeMake(28,22)];
    UIBarButtonItem * loveItem = [self customBarItem:@"收藏（爱心）" highLightImageName:@"收藏（选中状态）" action:@selector(love) size:CGSizeMake(28,22)];
    self.navigationItem.rightBarButtonItems = @[loveItem,shareItem,flexBarItem];
    
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

    
    
    //顶部的滚动图片
    NSArray * tempArray = @[[UIImage imageNamed:@"广告1"],[UIImage imageNamed:@"广告1"],[UIImage imageNamed:@"整桶（选中状态）"]];
    CGRect tempScrollViewRect = CGRectMake(0, 0, 320, self.productScrollView.frame.size.height);
    
    
    isPlaceHolderImage = YES;
    autoScrollView = [[CycleScrollView alloc] initWithFrame:tempScrollViewRect animationDuration:2];
    autoScrollView.backgroundColor = [UIColor clearColor];
    autoScrollviewDataSource = [NSMutableArray array];
    for (UIImage * image in tempArray) {
        UIImageView * tempImageView = [[UIImageView alloc]initWithImage:image];
        [tempImageView setFrame:tempScrollViewRect];
        [autoScrollviewDataSource addObject:tempImageView];
        tempImageView = nil;
    }
    __weak MarkCellDetailViewController * weakSelf = self;
    autoScrollView.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex){
        
        return weakSelf.autoScrollviewDataSource[pageIndex];
    };
    autoScrollView.totalPagesCount = ^NSInteger(void){
        return [weakSelf.autoScrollviewDataSource count];
    };
    autoScrollView.TapActionBlock = ^(NSInteger pageIndex){
        
        NSLog(@"点击了第%ld个",(long)pageIndex);

    };

    [self.productScrollView addSubview:autoScrollView];
    [self downloadUpperImage];
    
    [_contentTable setTableHeaderView:_productScrollView];

    // Do any additional setup after loading the view from its nib.
}

-(void)viewDidDisappear:(BOOL)animated
{
//    for (UIView * view in self.productScrollView.subviews) {
//        if ([view isKindOfClass:[CycleScrollView class]]) {
//            CycleScrollView * cycleView = (CycleScrollView *)view;
//            if ([cycleView.timer isValid]) {
////                [cycleView.timer invalidate];
//            }
//        }
//    }
    autoScrollView = nil;
    self.productScrollView = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)downloadUpperImage
{
    NSMutableArray * imageURLs = [NSMutableArray array];
    if(_commodity.image)
    {
        [imageURLs addObject:_commodity.image];
    }
    
    if(_commodity.image_2)
    {
        [imageURLs addObject:_commodity.image_2];
    }
    
    if(_commodity.image_3)
    {
        [imageURLs addObject:_commodity.image_3];
    }
    
    if(_commodity.image_4)
    {
        [imageURLs addObject:_commodity.image_4];
    }
    
    if(_commodity.image_5)
    {
        [imageURLs addObject:_commodity.image_5];
    }
    
    __block NSMutableArray * imageArray = [NSMutableArray array];
    for (int i =0 ;i<[imageURLs count];i++) {
        
        @autoreleasepool {
            __weak MarkCellDetailViewController * weakSelf = self;;
            NSURL * imageURL = [NSURL URLWithString:[imageURLs objectAtIndex:i]];
            NSInteger tagNum = i;
            SDWebImageManager *manager = [SDWebImageManager sharedManager];
            [manager downloadWithURL:imageURL options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                ;
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
                if (image)
                {
                    NSLog(@"%@",[imageURL absoluteString]);
                    UIImageView * info = [[UIImageView alloc]initWithImage:image];
                    info.tag = tagNum;
                    if (isPlaceHolderImage) {
                        isPlaceHolderImage= NO;
                        [weakSelf.autoScrollviewDataSource removeAllObjects];
                    }
                    
                    [weakSelf.autoScrollviewDataSource addObject:info];
                    [self updateAutoScrollViewItem];
                }
            }];
        }
    }
}

-(void)updateAutoScrollViewItem
{
    __weak MarkCellDetailViewController * weakSelf = self;
    autoScrollView.totalPagesCount = ^NSInteger(void){
        return [weakSelf.autoScrollviewDataSource count];
    };
    autoScrollView.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex){

        return weakSelf.autoScrollviewDataSource[pageIndex];
    };
    
    
}
#pragma  mark - Table

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        //cell.textLabel.textColor = [UIColor blackColor];
    }
    
    if(indexPath.row == 0)
    {
        cell.textLabel.text = [NSString stringWithFormat:@"【品名】%@",_commodity.name];
        //cell.detailTextLabel.text = _commodity.name;
    }
    else if(indexPath.row == 1)
    {
        cell.textLabel.text = [NSString stringWithFormat:@"【生产工艺】%@",_commodity.production];
        //cell.detailTextLabel.text = _commodity.production;
    }
    else if(indexPath.row == 2)
    {
        cell.textLabel.text = [NSString stringWithFormat:@"【规格】%@",_commodity.specification];
        //cell.detailTextLabel.text = _commodity.specification;
    }
    else if(indexPath.row == 3)
    {
        cell.textLabel.text = [NSString stringWithFormat:@"【配料】%@",_commodity.burden];
        //cell.detailTextLabel.text = _commodity.burden;
    }
    else if(indexPath.row == 4)
    {
        cell.textLabel.text = [NSString stringWithFormat:@"【生产日期】%@",_commodity.year];
        //cell.detailTextLabel.text = _commodity.year;
    }
    else if(indexPath.row == 5)
    {
        cell.textLabel.text = [NSString stringWithFormat:@"【出品商】%@",_commodity.producer];
        //cell.detailTextLabel.text = _commodity.producer;
    }
    else
    {
        cell.textLabel.text = [NSString stringWithFormat:@"【储存方式】%@",_commodity.storage];
        //cell.detailTextLabel.text = _commodity.storage;
    }
    
    return cell;
}

- (IBAction)callAction:(id)sender
{
    CustomiseServiceViewController * vc = [[CustomiseServiceViewController alloc] initWithNibName:nil bundle:nil];
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
    [manager downloadWithURL:[NSURL URLWithString:_commodity.image] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        ;
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (image)
        {
            
            UIImage * scaleImage = [image imageWithScale:.3f];
            [self shareWithTitle:_commodity.name withContent:_commodity.hw_description withURL:@"http://www.baidu.com" withImage:scaleImage withDescription:_commodity.name];
        }
    }];

}

-(void)love
{
    if (user) {
        NSLog(@"%s",__func__);
        NSArray * collections = [PersistentStore getAllObjectWithType:[ProductCollection class]];
        BOOL isShouldAdd = YES;
        for (ProductCollection * obj in collections) {
            if ([obj.collectionID isEqualToString:self.commodity.hw_id]) {
                isShouldAdd = NO;
                break;
            }
        }
        
        if (isShouldAdd) {
            MBProgressHUD * hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hub.labelText = @"添加收藏";
            __weak MarkCellDetailViewController * weakSelf = self;
            [[HttpService sharedInstance]addCollection:@{@"user_id":user.hw_id,@"collection_id":self.commodity.hw_id,@"type":@"1"} completionBlock:^(id object) {
                
                hub.mode = MBProgressHUDModeText;
                hub.labelText = object;
                [weakSelf saveToLocal];
                [hub hide:YES afterDelay:1];
                
            } failureBlock:^(NSError *error, NSString *responseString) {
                hub.mode = MBProgressHUDModeText;
                hub.labelText = @"添加失败";
                [hub hide:YES afterDelay:1];
            }];
        }else
        {
            //已经保存
            [self showAlertViewWithMessage:@"已经收藏"];
        }
        
    }else
    {
        //请登录
        [self showAlertViewWithMessage:@"请先登录"];
    }
    
}

-(void)saveToLocal
{
    ProductCollection * collection = [ProductCollection MR_createEntity];
    collection.collectionID = self.commodity.hw_id;
    [[NSManagedObjectContext MR_defaultContext]MR_saveOnlySelfAndWait];
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
    [manager downloadWithURL:[NSURL URLWithString:_commodity.image] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        ;
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
        if (image)
        {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            UIImage * scaleImage = [image imageWithScale:.3f];
            [[ShareManager shareManager] shareToWeiXinContentWithTitle:_commodity.name content:_commodity.hw_description image:scaleImage];
        }
    }];
}



-(void)shareToWeiboAction
{
    NSLog(@"%s",__func__);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager downloadWithURL:[NSURL URLWithString:_commodity.image] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        ;
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
        if (image)
        {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            UIImage * scaleImage = [image imageWithScale:.3f];
            [[ShareManager shareManager] shareToSinaWeiboWithTitle:_commodity.name content:_commodity.hw_description image:scaleImage];
        }
    }];
}

-(void)shareToQQZoneAction
{
    NSLog(@"%s",__func__);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager downloadWithURL:[NSURL URLWithString:_commodity.image] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        ;
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
        if (image)
        {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            UIImage * scaleImage = [image imageWithScale:.3f];
            [[ShareManager shareManager] shareToQQSpaceWithTitle:_commodity.name content:_commodity.hw_description image:scaleImage];
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
                          ShareTypeSMS,
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
