//
//  ControlCenter.m
//  ClairAudient
//
//  Created by Carl on 13-12-31.
//  Copyright (c) 2013年 helloworld. All rights reserved.
//

#import "ControlCenter.h"
#import "YDSlideMenuContainerViewController.h"
#import "Constants.h"
#import "TeaMarketViewController.h"
#import "NewsDetailViewController.h"
#import "MarketViewController.h"
#import "TeaListViewController.h"
#import "TeaMarketMainController.h"

@implementation ControlCenter

+ (AppDelegate *)appDelegate
{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

+ (UIWindow *)keyWindow
{
    return [[UIApplication sharedApplication] keyWindow];
}

+ (UIWindow *)newWindow
{
    UIWindow * window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    window.backgroundColor = [UIColor whiteColor];
    return window;
}

+ (void)makeKeyAndVisible
{
    AppDelegate * appDelegate = [[self class] appDelegate];
    [[self class] setNavigationTitleWhiteColor];
    appDelegate.window = [[self class] newWindow];
    AKTabBarController * tabBarController = [[AKTabBarController alloc] initWithTabBarHeight:49];
    [tabBarController setBackgroundImageName:@"tabbar_bg"];
    [tabBarController setSelectedBackgroundImageName:nil];
    tabBarController.iconGlossyIsHidden = NO;
    tabBarController.tabTitleIsHidden = YES;
    UINavigationController * nav_1 = [[self class] navWithRootVC:[[self class] viewControllerWithName:@"MainViewController"]];
//    UINavigationController * nav_2 = [[self class] navWithRootVC:[[self class] viewControllerWithName:@"TeaMarketViewController"]];
    UINavigationController * nav_2 = [[self class] navWithRootVC:[[TeaMarketMainController alloc] init]];
    
    UINavigationController * nav_3 = [[self class] navWithRootVC:[[self class] viewControllerWithName:@"MarketViewController"]];
    UINavigationController * nav_4 = [[self class] navWithRootVC:[[self class] viewControllerWithName:@"MarketNewsViewController"]];
    UINavigationController * nav_5 = [[self class] navWithRootVC:[[self class] viewControllerWithName:@"MoreViewController"]];

    [tabBarController setIconColors:@[[UIColor colorWithRed:73.0/255.0 green:29.0/255.0f blue:18.0/255.0f alpha:1.0],[UIColor colorWithRed:73.0/255.0 green:29.0/255.0f blue:18.0/255.0f alpha:1.0],[UIColor colorWithRed:73.0/255.0 green:29.0/255.0f blue:18.0/255.0f alpha:1.0],[UIColor colorWithRed:73.0/255.0 green:29.0/255.0f blue:18.0/255.0f alpha:1.0],[UIColor colorWithRed:73.0/255.0 green:29.0/255.0f blue:18.0/255.0f alpha:1.0]]];
    [tabBarController setSelectedIconColors:@[[UIColor colorWithRed:206.0/255.0f green:48.0/255.0f blue:17.0/255.0f alpha:1.0f],[UIColor colorWithRed:206.0/255.0f green:48.0/255.0f blue:17.0/255.0f alpha:1.0f],[UIColor colorWithRed:206.0/255.0f green:48.0/255.0f blue:17.0/255.0f alpha:1.0f],[UIColor colorWithRed:206.0/255.0f green:48.0/255.0f blue:17.0/255.0f alpha:1.0f],[UIColor colorWithRed:206.0/255.0f green:48.0/255.0f blue:17.0/255.0f alpha:1.0f]]];
    [tabBarController setSelectedTabColors:@[[UIColor clearColor],[UIColor clearColor],[UIColor clearColor],[UIColor clearColor],[UIColor clearColor]]];
    [tabBarController setTabColors:@[[UIColor whiteColor],[UIColor whiteColor],[UIColor whiteColor]]];
    [tabBarController setTabStrokeColor:[UIColor clearColor]];
    [tabBarController setTabEdgeColor:[UIColor clearColor]];
    tabBarController.viewControllers = [NSMutableArray arrayWithObjects:nav_1,nav_2,nav_3,nav_4,nav_5,nil];
    appDelegate.akTabBarController = tabBarController;
    
    
    LeftMenuViewController * leftVC = [[LeftMenuViewController alloc]initWithNibName:@"LeftMenuViewController" bundle:nil];
    UINavigationController * leftNav = [[self class] navWithRootVC:leftVC];
    appDelegate.leftMenuController = leftNav;
    
    if([OSHelper iOS7])
    {
        UINavigationController * globleNav = [self globleNavController];
        [globleNav.navigationBar setHidden:YES];
        [globleNav setViewControllers:@[appDelegate.akTabBarController] animated:YES];
        appDelegate.containerViewController = [YDSlideMenuContainerViewController containerWithCenterViewController:globleNav leftMenuViewController:appDelegate.leftMenuController rightMenuViewController:nil];
    }
    else
    {
        appDelegate.containerViewController = [YDSlideMenuContainerViewController containerWithCenterViewController:tabBarController leftMenuViewController:appDelegate.leftMenuController rightMenuViewController:nil];
    }
    


    
    [appDelegate.window setRootViewController:appDelegate.containerViewController];
    [appDelegate.window makeKeyAndVisible];
    //[tabBarController setSelectedViewController:nav_1];
    nav_1 = nil;
    nav_2 = nil;
    nav_3 = nil;
    nav_4 = nil;
    nav_5 = nil;
    tabBarController = nil;

}

+ (void)showTeaMarket
{
    AppDelegate * appDelegate = [[self class] appDelegate];
    //取得茶叶超市的controller
    UINavigationController * nav_2 = [appDelegate.akTabBarController.viewControllers objectAtIndex:1];
    [nav_2 popToRootViewControllerAnimated:YES];
    //显示茶叶超市
    TeaMarketViewController * vc = (TeaMarketViewController *)nav_2.topViewController;
    [appDelegate.akTabBarController setSelectedViewController:nav_2];
    [vc loadAllCommodity];
}

//显示茶叶超市，并按照分类搜索商品
+ (void)showTeaMarketWithCatagory:(TeaCategory *)category
{
    NSAssert(category != nil, @"The category is nil.");
    AppDelegate * appDelegate = [[self class] appDelegate];
    //取得茶叶超市的controller
//    UINavigationController * nav_2 = [appDelegate.akTabBarController.viewControllers objectAtIndex:1];
//    [nav_2 popToRootViewControllerAnimated:YES];
//    //显示茶叶超市
//    [appDelegate.akTabBarController setSelectedViewController:nav_2];
//    TeaMarketViewController * vc = (TeaMarketViewController *)nav_2.topViewController;
//    [vc showCommodityByCategory:category];
    UINavigationController * nav_1 = [appDelegate.akTabBarController.viewControllers objectAtIndex:0];
    TeaListViewController * vc = [[TeaListViewController alloc] initWithNibName:nil bundle:nil];
    vc.teaCategory = category;
    [nav_1 pushViewController:vc animated:YES];
    vc = nil;
    
    
}

+ (void)showTeaMarketWithCatagory:(TeaCategory *)category withYear:(NSString *)year
{
    NSAssert(category != nil, @"The category is nil.");
    AppDelegate * appDelegate = [[self class] appDelegate];
    //取得茶叶超市的controller
    UINavigationController * nav_2 = [appDelegate.akTabBarController.viewControllers objectAtIndex:1];
    [nav_2 popToRootViewControllerAnimated:YES];
    TeaMarketViewController * vc = (TeaMarketViewController *)nav_2.topViewController;
    vc.teaCategory = category;
    vc.year = year;
    [appDelegate.containerViewController setMenuState:YDSLideMenuStateClosed];
    
}

+ (void)showBranchTeaWithCategory:(TeaCategory *)category withYear:(NSString *)year
{
    NSAssert(category != nil, @"The category is nil.");
    AppDelegate * appDelegate = [[self class] appDelegate];
    UINavigationController * nav_1 = appDelegate.akTabBarController.viewControllers[0];
    NSLog(@"%@",NSStringFromClass([nav_1.visibleViewController class]));
    TeaListViewController * vc = (TeaListViewController *)nav_1.visibleViewController;
    vc.teaCategory = category;
    vc.year = year;
    [vc showCommodityByCategoryAndYear];
    [appDelegate.containerViewController setMenuState:YDSLideMenuStateClosed];
    
}

+ (void)showTeaMarketWithKeyword:(NSString *)keyword
{
    AppDelegate * appDelegate = [[self class] appDelegate];
    //取得茶叶超市的controller
    UINavigationController * nav_2 = [appDelegate.akTabBarController.viewControllers objectAtIndex:1];
    [nav_2 popToRootViewControllerAnimated:YES];
    TeaMarketViewController * vc = (TeaMarketViewController *)nav_2.topViewController;
    [appDelegate.akTabBarController setSelectedViewController:nav_2];
    [vc searchCommodityWithKeyword:keyword];

}

+ (void)showCatetoryInTeaMarket
{
    AppDelegate * appDelegate = [[self class] appDelegate];
    //取得茶叶超市的controller
    UINavigationController * nav_2 = [appDelegate.akTabBarController.viewControllers objectAtIndex:1];
    [nav_2 popToRootViewControllerAnimated:YES];
    TeaMarketViewController * vc = (TeaMarketViewController *)nav_2.topViewController;
    [appDelegate.akTabBarController setSelectedViewController:nav_2];
    [vc showLeftController:nil];
}


+ (void)showMarketNewsWithNews:(MarketNews *)news withImage:(UIImage *)image
{
    NSAssert(news != nil, @"The category is nil.");
    AppDelegate * appDelegate = [[self class] appDelegate];
    //取得茶叶超市的controller
    UINavigationController * nav_3 = [appDelegate.akTabBarController.viewControllers objectAtIndex:3];
    [nav_3 popToRootViewControllerAnimated:NO];
    [appDelegate.akTabBarController setSelectedViewController:nav_3];
    NewsDetailViewController * vc = [[NewsDetailViewController alloc] initWithNibName:nil bundle:nil];
    [vc setPoster:image];
    [vc setNews:news];
    [nav_3 pushViewController:vc animated:YES];
    vc = nil;
}

+ (void)showMarketWithType:(NSString *)type keyword:(NSString *)keyword
{
    NSAssert(type != nil, @"The category is nil.");
    AppDelegate * appDelegate = [[self class] appDelegate];
    //取得茶叶超市的controller
    UINavigationController * nav_3 = [appDelegate.akTabBarController.viewControllers objectAtIndex:2];
    [nav_3 popToRootViewControllerAnimated:YES];
    MarketViewController * vc = (MarketViewController *)nav_3.topViewController;
    [vc setType:type keyword:keyword];
    [appDelegate.akTabBarController setSelectedViewController:nav_3];
}

+ (void)setNavigationTitleWhiteColor
{
    [[UINavigationBar appearance] setTitleTextAttributes:@{UITextAttributeTextColor:[UIColor whiteColor]}];
}



+ (void)showVC:(NSString *)vcName
{
//    AppDelegate * appDelegate = [[self class] appDelegate];
//    UIViewController * vc = [[self class] viewControllerWithName:vcName];

    
}


+ (UIViewController *)viewControllerWithName:(NSString *)vcName
{
    Class cls = NSClassFromString(vcName);
    UIViewController * vc = [[cls alloc] initWithNibName:vcName bundle:[NSBundle mainBundle]];
    return vc;
}

+ (UINavigationController *)navWithRootVC:(UIViewController *)vc
{
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:vc];
    return nav;
}

+(UINavigationController *)globleNavController
{
    static UINavigationController * nav  = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        nav = [[UINavigationController alloc]init];
    });
    return nav;
}
@end
