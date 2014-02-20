//
//  TeaViewController.m
//  TeaMall
//
//  Created by vedon on 14/1/14.
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


#import "TeaViewController.h"
#import "UIViewController+BarItem.h"
#import "ShareView.h"
#import "CycleScrollView.h"
#import "ShareManager.h"
#import "OrderViewController.h"
#import "HttpService.h"
#import "MBProgressHUD.h"
#import "ProductCollection.h"
#import "PersistentStore.h"
#import "User.h"
#import "TeaCommodity.h"
@interface TeaViewController ()<CycleScrollViewDelegate>
{
    ShareView * shareView;
    UIView * blurView;
    User * user;
}
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
    [self interfaceInitialization];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideShareView)];
    [self.view addGestureRecognizer:tap];
    tap = nil;
    
    user = [User userFromLocal];
}

-(void)interfaceInitialization
{
    [self setLeftCustomBarItem:@"返回" action:nil];
    UIBarButtonItem * flexBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem * shareItem = [self customBarItem:@"分享图标（未选中状态）" highLightImageName:@"分享图标（选中状态）" action:@selector(share) size:CGSizeMake(35,30)];
    UIBarButtonItem * loveItem = [self customBarItem:@"收藏（爱心）" highLightImageName:@"收藏（选中状态）" action:@selector(love) size:CGSizeMake(35,30)];
    self.navigationItem.rightBarButtonItems = @[loveItem,shareItem,flexBarItem];
    
    //显示商品信息
    _descriptionLabel.text = _commodity.hw_description;
    _currentPriceLabel.text = [NSString stringWithFormat:@"￥%@",_commodity.hw__price];
    
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
    CycleScrollView *scrollView = [[CycleScrollView alloc]initWithFrame:tempScrollViewRect
                                                         cycleDirection:CycleDirectionLandscape
                                                               pictures:tempArray
                                                             autoScroll:NO];
    [self.productScrollView addSubview:scrollView];
    scrollView = nil;
    
    //适配屏幕
    [self anchor:self.btnView to:BOTTOM withOffset:CGPointMake(0, 90)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)shareToWeiXinAction
{
    NSLog(@"%s",__func__);
    [[ShareManager shareManager]shareToWeiXinContentWithTitle:@"hello" content:@"content" image:[UIImage imageNamed:@"整桶（选中状态）"]];
}

-(void)shareToWeiboAction
{
    NSLog(@"%s",__func__);
//    [ShareManager shareManager]shareToSinaWeiboWithTitle:<#(NSString *)#> content:<#(NSString *)#> image:<#(UIImage *)#>
}

-(void)shareToQQZoneAction
{
    NSLog(@"%s",__func__);
//    [ShareManager shareManager]shareToQQSpaceWithTitle:<#(NSString *)#> content:<#(NSString *)#> image:<#(UIImage *)#>
}

-(void)share
{
     NSLog(@"%s",__func__);
    [shareView setHidden:NO];
    [blurView setHidden:NO];
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
            __weak TeaViewController * weakSelf = self;
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

- (IBAction)buyImmediatelyAction:(id)sender {
    OrderViewController * viewController = [[OrderViewController alloc]initWithNibName:@"OrderViewController" bundle:nil];
    viewController.commodity = self.commodity;
    [self.navigationController pushViewController:viewController animated:YES];
    viewController = nil;
}

- (IBAction)putInCarAction:(id)sender
{
    if(_commodity == nil)
    {
        NSLog(@"The commodity is nil.");
        return ;
    }
    
    //加入购物车前，先判断是否存在
    NSArray * teaCommoditys = [PersistentStore getObjectWithType:[TeaCommodity class] Key:@"hw_id" Value:_commodity.hw_id];
    if([teaCommoditys count] == 0)
    {
        
        NSMutableDictionary * info = [NSMutableDictionary dictionaryWithDictionary:[Commodity toDictionary:_commodity]];
        [info setValue:@"1" forKey:@"amount"];
        [info setValue:@"0" forKey:@"selected"];
        [PersistentStore createAndSaveWithObject:[TeaCommodity class] params:info];
    }
    else
    {
        //如果商品已存在购物车里，则数量加1
        TeaCommodity * teaCommodity = [teaCommoditys objectAtIndex:0];
        int amount = [teaCommodity.amount integerValue] + 1;
        [PersistentStore updateObject:teaCommodity Key:@"amount" Value:[NSString stringWithFormat:@"%i",amount]];
    }

    
}

@end
