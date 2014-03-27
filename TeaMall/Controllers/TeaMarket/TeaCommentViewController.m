//
//  TeaCommentViewController.m
//  TeaMall
//
//  Created by Carl on 14-3-26.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "TeaCommentViewController.h"
#import "TeaCommentSelfCell.h"
#import "TeaCommentOtherCell.h"
@interface TeaCommentViewController ()

@end

@implementation TeaCommentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.title = @"评价详情";
    [self setLeftCustomBarItem:@"返回" action:nil];
    
    UINib * otherNib = [UINib nibWithNibName:@"TeaCommentOtherCell" bundle:[NSBundle bundleForClass:[TeaCommentOtherCell class]]];
    UINib * selfNib = [UINib nibWithNibName:@"TeaCommentSelfCell" bundle:[NSBundle bundleForClass:[TeaCommentSelfCell class]]];
    [_tableView registerNib:otherNib forCellReuseIdentifier:@"OtherCell"];
    [_tableView registerNib:selfNib forCellReuseIdentifier:@"SelfCell"];
    UIView * view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [_tableView setTableFooterView:view];
    view = nil;
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [self setView:nil];
}

#pragma mark - UITableViewDataSource Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 62.0f;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TeaCommentOtherCell * cell = [tableView dequeueReusableCellWithIdentifier:@"OtherCell"];
    return cell;
}

@end
