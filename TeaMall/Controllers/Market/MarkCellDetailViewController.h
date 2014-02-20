//
//  MarkCellDetailViewController.h
//  TeaMall
//
//  Created by vedon on 15/1/14.
//  Copyright (c) 2014 helloworld. All rights reserved.
//

#import "CommonViewController.h"
#import "Commodity.h"
@interface MarkCellDetailViewController : CommonViewController
@property (weak, nonatomic) IBOutlet UIView *productScrollView;
@property (weak, nonatomic) IBOutlet UITableView *contentTable;
@property (weak, nonatomic) Commodity * commodity;
- (IBAction)callAction:(id)sender;
@end
