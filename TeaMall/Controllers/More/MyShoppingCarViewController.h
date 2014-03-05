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
@property (nonatomic,assign) SEL result;//这里声明为属性方便在于外部传入。
@property (weak, nonatomic) IBOutlet UIView *bottomView;
- (void)paymentResult:(NSString *)result;
- (IBAction)buyAction:(id)sender;

- (IBAction)seletedAllItemAction:(id)sender;
@end
