//
//  TeaMarketViewController.h
//  TeaMall
//
//  Created by Carl on 14-1-10.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "CommonViewController.h"
@class TeaCategory;
@interface TeaMarketViewController : CommonViewController
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *contentTable;
@property (strong,nonatomic) TeaCategory * teaCategory;
- (void)showCommodityByCategory:(TeaCategory *)category;
@end
