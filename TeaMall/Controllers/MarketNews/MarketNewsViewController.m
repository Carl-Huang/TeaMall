//
//  MarketNewsViewController.m
//  TeaMall
//
//  Created by Carl on 14-1-10.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "MarketNewsViewController.h"
#import "UIViewController+AKTabBarController.h"
#import "UINavigationBar+Custom.h"
#import "CycleScrollView.h"
#import "NewsDetailViewController.h"
#import "MBProgressHUD.h"
#import "HttpService.h"
#import "MarketNews.h"
#import "SDWebImageManager.h"
#import "MarketNewRoundView.h"
@interface MarketNewsViewController ()
{
    
    NSArray * downAdViewInfo ;
    
    //
    NSString * identifier;
    NSString * contentIdentifier;
    BOOL isPlaceHolderImage;
}
@property (strong ,nonatomic) CycleScrollView * autoScrollView;
@property (strong ,nonatomic) NSArray * topAdViewInfo;
@property (strong ,nonatomic) NSMutableArray * autoScrollviewDataSource;
@end

@implementation MarketNewsViewController
@synthesize autoScrollView,topAdViewInfo,autoScrollviewDataSource;

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
    
    CGRect rect = self.contentScrollView.frame;
    if(![OSHelper iPhone5])
    {
        rect.size.height = 207;
        [self.contentScrollView setFrame:rect];
    }

    [self initializationInterface];
   

    [self showTopAdvertisementImage];
    [self getDownAdvertisementImage];
//    [self configureContentScrollView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.view bringSubviewToFront:self.contentScrollView];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

#pragma mark - Private method
-(void)initializationInterface
{
    self.title = @"市场资讯";
    //[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"顶栏"]];
    
    
    CGRect tempScrollViewRect = CGRectMake(0, 0, 320, self.adScrolllView.frame.size.height);
    NSArray * tempArray = @[[UIImage imageNamed:@"广告1"],[UIImage imageNamed:@"广告1"],[UIImage imageNamed:@"整桶（选中状态）"]];
    
    
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
    __weak MarketNewsViewController * weakSelf = self;
    autoScrollView.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex){

        if ([weakSelf.topAdViewInfo count] !=0) {
            if (pageIndex >= [weakSelf.topAdViewInfo count]) {
                pageIndex = [weakSelf.topAdViewInfo count] -1;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                MarketNews * obj = [weakSelf.topAdViewInfo objectAtIndex:pageIndex];
                weakSelf.scrollItemTitle.text = obj.title;
            });
        }
      
        return weakSelf.autoScrollviewDataSource[pageIndex];
    };
    autoScrollView.totalPagesCount = ^NSInteger(void){
        return [weakSelf.autoScrollviewDataSource count];
    };
    autoScrollView.TapActionBlock = ^(NSInteger pageIndex){
        
        NSLog(@"点击了第%ld个",(long)pageIndex);
        if ([weakSelf.autoScrollviewDataSource count]) {
            UIImageView * imageView = [weakSelf.autoScrollviewDataSource objectAtIndex:pageIndex];
            for (MarketNews * object in weakSelf.topAdViewInfo) {
                if (object.hw_id.integerValue == imageView.tag) {
                    NewsDetailViewController * viewController = [[NewsDetailViewController alloc]initWithNibName:@"NewsDetailViewController" bundle:nil];
                    [viewController setPoster:imageView.image];
                    [viewController setNews:object];
                    [weakSelf push:viewController];
                }
            }
        }
        
    };
    [_adScrolllView addSubview:autoScrollView];

}

-(void)updateAutoScrollViewItem
{
    
    __weak MarketNewsViewController * weakSelf = self;
    autoScrollView.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex){
        if ([weakSelf.topAdViewInfo count] !=0) {
            if (pageIndex >= [weakSelf.topAdViewInfo count]) {
                pageIndex = [weakSelf.topAdViewInfo count] -1;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                MarketNews * obj = [weakSelf.topAdViewInfo objectAtIndex:pageIndex];
                weakSelf.scrollItemTitle.text = obj.title;
            });
        }
        return weakSelf.autoScrollviewDataSource[pageIndex];
    };
    
    autoScrollView.totalPagesCount = ^NSInteger(void){
        return [weakSelf.autoScrollviewDataSource count];
    };
}

-(void)showTopAdvertisementImage
{
    __weak MarketNewsViewController * weakSelf = self;
    //读取图片
    [[HttpService sharedInstance]getMarketNewsTopWithCompletionBlock:^(id object) {
        if (object) {
            topAdViewInfo = object;
            [weakSelf downloadTopImage];
        }
    } failureBlock:^(NSError *error, NSString *responseString) {
        ;
    }];
}

-(void)downloadTopImage
{
//    MarketNews * obj = [topAdViewInfo objectAtIndex:0];
//    _scrollItemTitle.text = obj.title;
    for (int i =0 ;i<[topAdViewInfo count];i++) {
        MarketNews * obj = [topAdViewInfo objectAtIndex:i];
        @autoreleasepool {
            __weak MarketNewsViewController * weakSelf = self;
            NSURL * imageURL = [NSURL URLWithString:obj.image];
            NSInteger tagNum = obj.hw_id.integerValue;
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

-(void)getDownAdvertisementImage
{
    __weak MarketNewsViewController * weakSelf =self;
    [[HttpService sharedInstance]getMarketNewsWithCompletionBlock:^(id object) {
        if ([object count]) {
            downAdViewInfo = object;
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf downloadDownImage];
            });
            
        }
    } failureBlock:^(NSError *error, NSString *responseString) {
        ;
    }];
}

-(void)downloadDownImage
{
    NSUInteger width = 140;
    NSUInteger height = 90;
    NSUInteger gap    = 14;
    for (int i =0 ;i<[downAdViewInfo count];i++) {
        MarketNews * obj = [downAdViewInfo objectAtIndex:i];
        MarketNewRoundView * view = [[MarketNewRoundView alloc]initWithFrame:CGRectMake(gap+(width+gap)*(i%2), gap+(height+gap)*(i/2), width, height)];
        [view configureContentImage:[NSURL URLWithString:obj.image] description:obj.title];
        view.tag = i;
        //点击动作事件
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gotoNewsInfoContrller:)];
        [view addGestureRecognizer:tap];
        tap = nil;
        [self.contentScrollView addSubview:view];
        view = nil;
    }
    [self.contentScrollView setContentSize:CGSizeMake(320, 350)];
}


-(void)placeHolderImage
{
    NSUInteger width = 140;
    NSUInteger height = 90;
    NSUInteger gap    = 14;
    for (int i =0 ;i<6;i++) {
       
        MarketNewRoundView * view = [[MarketNewRoundView alloc]initWithFrame:CGRectMake(gap+(width+gap)*(i%2), gap+(height+gap)*(i/2), width, height)];
        //        [view configureContentImage:[NSURL URLWithString:@"http://teamall880.sinaapp.com/uploads/13912751465426.jpg"] description:@"hello"];
        [view configureContentImage:nil description:@"加载中"];
        
        //点击动作事件
        [self.contentScrollView addSubview:view];
        view = nil;
    }
    [self.contentScrollView setContentSize:CGSizeMake(320, 350)];
}
-(void)gotoNewsInfoContrller:(UITapGestureRecognizer *)tap
{
    MarketNewRoundView * view = (MarketNewRoundView*)tap.view;
    NSLog(@"%d",view.tag);
    UIImage * image = view.imageView.image;
    MarketNews * object = [downAdViewInfo objectAtIndex:view.tag];
    NewsDetailViewController * viewController = [[NewsDetailViewController alloc]initWithNibName:@"NewsDetailViewController" bundle:nil];
    [viewController setPoster:image];
    [viewController setNews:object];
    [self push:viewController];
    viewController = nil;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)tabImageName
{
	return @"市场资讯-图标（黑）";
}

- (NSString *)tabTitle
{
	return nil;
}

-(void)configureContentScrollView
{
    NSUInteger width = 140;
    NSUInteger height = 90;
    NSUInteger gap    = 14;
    for (int i =0; i<6; i++) {
        MarketNewRoundView * view = [[MarketNewRoundView alloc]initWithFrame:CGRectMake(gap+(width+gap)*(i%2), gap+(height+gap)*(i/2), width, height)];
        [view configureContentImage:nil description:@"hello"];
        [self.contentScrollView addSubview:view];
    }
    [self.contentScrollView setContentSize:CGSizeMake(320, 350)];
}
#pragma mark - CycleView delegate
-(void)cycleScrollViewDelegate:(CycleScrollView *)cycleScrollView didSelectImageView:(NSDictionary *)info
{
    for (MarketNews * object in topAdViewInfo) {
        if ([object.hw_id isEqualToString:[info valueForKey:identifier]]) {
            NewsDetailViewController * viewController = [[NewsDetailViewController alloc]initWithNibName:@"NewsDetailViewController" bundle:nil];
            [viewController setPoster:[info valueForKey:contentIdentifier]];
            [viewController setNews:object];
            [self push:viewController];
        }
    }
}


- (void)cycleScrollViewDelegate:(CycleScrollView *)cycleScrollView didScrollImageView:(int)index
{
    NSInteger scrollItemNum = index -1;
    if (index > [topAdViewInfo count]) {
        scrollItemNum = [topAdViewInfo count] -1;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        MarketNews * obj = [topAdViewInfo objectAtIndex:scrollItemNum];
        _scrollItemTitle.text = obj.title;
    });
    
}
@end
