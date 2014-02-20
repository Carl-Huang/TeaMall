//
//  MyShoppingCarViewController.h
//  TeaMall
//
//  Created by Vedon on 14-1-13.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "CommonViewController.h"

@interface MyShoppingCarViewController : CommonViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *allMoneyLabel;

- (IBAction)seletedAllItemAction:(id)sender;
@end
