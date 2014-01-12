//
//  TeamViewController.m
//  TeaMall
//
//  Created by Carl_Huang on 14-1-12.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "TeamViewController.h"
#import "UINavigationBar+Custom.h"
#import "TeamCell.h"

@interface TeamViewController ()

@end

@implementation TeamViewController

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
}


#pragma mark - tableView -
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifer = @"teamCell";
    TeamCell *cell = (TeamCell*)[tableView dequeueReusableCellWithIdentifier:identifer];
    if (cell == nil)
    {
        cell= (TeamCell *)[[[NSBundle  mainBundle]  loadNibNamed:@"TeamCell" owner:self options:nil]  lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return (UITableViewCell *)cell;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
       