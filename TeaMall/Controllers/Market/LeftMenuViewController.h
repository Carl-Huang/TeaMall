//
//  LeftMenuViewController.h
//  TeaMall
//
//  Created by vedon on 13/1/14.
//  Copyright (c) 2014 helloworld. All rights reserved.
//

#import "CommonViewController.h"
#import "HeadView.h"
@interface LeftMenuViewController : CommonViewController
{
    NSInteger _currentSection;
    NSInteger _currentRow;
}
//- (IBAction)show:(id)sender;
@property(nonatomic,assign) BOOL isShowSell;
@property(nonatomic, strong) NSMutableArray* headViewArray;
@property(weak, nonatomic) IBOutlet UITableView *contentTable;
@end
