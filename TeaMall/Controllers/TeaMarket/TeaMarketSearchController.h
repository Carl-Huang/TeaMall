//
//  TeaMarketSearchController.h
//  茶叶市场的主界面
//
//  Created by Carl_Huang on 14-8-26.
//  Copyright (c) 2014年 HelloWorld. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TeaMarketSearchController : UIViewController 

@property(nonatomic,assign) BOOL isShowSell;
//搜索栏
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
//tableView
@property (weak, nonatomic) IBOutlet UITableView *contentTable;


@end
