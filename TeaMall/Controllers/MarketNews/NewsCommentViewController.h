//
//  NewsCommentViewController.h
//  TeaMall
//
//  Created by Carl on 14-4-1.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "CommonViewController.h"

@interface NewsCommentViewController : CommonViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSString * newsID;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *contentField;
- (IBAction)submitAction:(id)sender;
- (IBAction)endEdit:(id)sender;
@end
