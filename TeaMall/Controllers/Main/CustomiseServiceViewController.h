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
//此属性用来判断当点控制器是从哪个控制器push进来的
@property (strong,nonatomic) UIViewController *myParentController;

@end
