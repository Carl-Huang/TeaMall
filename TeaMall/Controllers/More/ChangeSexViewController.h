//
//  ChangeSexViewController.h
//  TeaMall
//
//  Created by Carl on 14-2-12.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "CommonViewController.h"

@interface ChangeSexViewController : CommonViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
