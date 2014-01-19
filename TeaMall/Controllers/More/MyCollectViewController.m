//
//  ISellViewController.m
//  TeaMall
//
//  Created by omi on 14-1-13.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "MyCollectViewController.h"
#import "MyCollectTableCell.h"
#import "UIViewController+BarItem.h"
static NSString *identifer = @"cellIdentifier";
@interface MyCollectViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSInteger itemCount;
}
@end

@implementation MyCollectViewController

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
    [self setLeftCustomBarItem:@"返回" action:nil];
    [self setRightCustomBarItem:@"编辑" action:@selector(modifyMyCollectData:)];
    
    UINib * cellNib = [UINib nibWithNibName:@"MyCollectTableCell" bundle:[NSBundle bundleForClass:[MyCollectTableCell class]]];
    [self.contentTable registerNib:cellNib forCellReuseIdentifier:identifer];
    // Do any additional setup after loading the view from its nib.
    itemCount = 10;
}

-(void)modifyMyCollectData:(id)sender
{
    UIButton * btn = (UIButton *)sender;
    [btn setSelected:!btn.selected];
    if (btn.selected) {
        
         [self.contentTable setEditing:YES animated:YES];
    }else
    {
         [self.contentTable setEditing:NO animated:YES];
    }
    NSLog(@"%s",__func__);
    
   
}

#pragma mark - tableView -
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return itemCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MyCollectTableCell *cell = (MyCollectTableCell*)[tableView dequeueReusableCellWithIdentifier:identifer];
    cell.clipsToBounds  = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return (UITableViewCell *)cell;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyCollectTableCell * cell = (MyCollectTableCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (cell.service.hidden) {
        [UIView animateWithDuration:0.3 animations:^{
            cell.service.alpha = 1.0;
            [cell.service setHidden:NO];
            
        }];
    }else
    {
        [UIView animateWithDuration:0.3 animations:^{
            cell.service.alpha = 0.0;
            [cell.service setHidden:YES];
            
        }];
    }
    
    
    return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        [self.items  removeObjectAtIndex:[indexPath row]];
        itemCount --;
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
