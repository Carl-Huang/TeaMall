//
//  AppDelegate.h
//  TeaMall
//
//  Created by Carl on 14-1-10.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AKTabBarController.h"
#import "YDSlideMenuContainerViewController.h"
#import "LeftMenuViewController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) AKTabBarController * akTabBarController;

@property (strong, nonatomic) YDSlideMenuContainerViewController *containerViewController;
@property (strong, nonatomic) LeftMenuViewController * leftMenuController;
-(void)toggleLeftMenu;
@end
