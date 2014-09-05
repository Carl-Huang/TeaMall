//
//  myBidViewController.h
//  TeaMall
//
//  Created by Carl_Huang on 14-9-5.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "CommonViewController.h"

@interface myBidViewController : CommonViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *contentTable;

@end
