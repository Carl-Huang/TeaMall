//
//  TeamViewController.h
//  TeaMall
//
//  Created by Carl_Huang on 14-1-12.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "CommonViewController.h"

@interface TeamViewController : CommonViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end 
