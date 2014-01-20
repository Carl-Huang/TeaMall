//
//  CustomiseServiceViewController.h
//  TeaMall
//
//  Created by vedon on 13/1/14.
//  Copyright (c) 2014 helloworld. All rights reserved.
//

#import "CommonViewController.h"

@interface CustomiseServiceViewController : CommonViewController

@property (weak, nonatomic) IBOutlet UITableView *contentTable;
@property (copy, nonatomic) NSArray *plistArray;
@end
