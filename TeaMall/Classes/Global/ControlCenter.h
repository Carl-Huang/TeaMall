//
//  ControlCenter.h
//  ClairAudient
//
//  Created by Carl on 13-12-31.
//  Copyright (c) 2013年 helloworld. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "AKTabBarController.h"
#import "MainViewController.h"
#import "MarketNewsViewController.h"
#import "MarketViewController.h"
#import "TeaMarketViewController.h"
#import "MoreViewController.h"
#import "AllModels.h"
@interface ControlCenter : NSObject

+ (AppDelegate *)appDelegate;
+ (UIWindow *)keyWindow;
+ (UIWindow *)newWindow;
+ (void)makeKeyAndVisible;
+ (void)showTeaMarket;
+ (void)showTeaMarketWithCatagory:(TeaCategory *)category;
+ (void)showTeaMarketWithCatagory:(TeaCategory *)category withYear:(NSString *)year;
+ (void)showMarketNewsWithNews:(MarketNews *)news;
+ (void)showMarketWithType:(NSString *)type;
+ (void)setNavigationTitleWhiteColor;
+ (void)showVC:(NSString *)vcName;
+ (UIViewController *)viewControllerWithName:(NSString *)vcName;
+ (UINavigationController *)navWithRootVC:(UIViewController *)vc;
+ (UINavigationController *)globleNavController;
@end
