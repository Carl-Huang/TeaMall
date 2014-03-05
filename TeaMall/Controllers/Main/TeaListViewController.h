//
//  TeaListViewController.h
//  TeaMall
//
//  Created by Carl on 14-3-5.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "CommonViewController.h"
@class TeaCategory;
@interface TeaListViewController : CommonViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *contentTable;
@property (strong,nonatomic) TeaCategory * teaCategory;
@end
