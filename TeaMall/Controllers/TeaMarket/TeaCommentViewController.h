//
//  TeaCommentViewController.h
//  TeaMall
//
//  Created by Carl on 14-3-26.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "CommonViewController.h"

@interface TeaCommentViewController : CommonViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *contentField;
@property (strong, nonatomic) NSString * goodsID;
- (IBAction)submitAction:(id)sender;
- (IBAction)endEdit:(id)sender;
@end
