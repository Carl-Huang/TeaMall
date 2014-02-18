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
#import "MyPublicCell.h"
#import "HttpService.h"
#import "ProductCollection.h"
#import "PublicCollection.h"
#import "User.h"
#import "Publish.h"
#import "Commodity.h"
static NSString * productIdentifier = @"cellIdentifier";
static NSString * publicIdentifier  = @"publicIdentifier";
static NSString *cellIdentifer = @"tradingTableCell";
@interface MyCollectViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray * dataSource;
    User * user;
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
    
    UINib * productCellNib = [UINib nibWithNibName:@"MyCollectTableCell" bundle:[NSBundle bundleForClass:[MyCollectTableCell class]]];
    [self.contentTable registerNib:productCellNib forCellReuseIdentifier:productIdentifier];
    
    UINib * publicCellNib = [UINib nibWithNibName:@"MyPublicCell" bundle:[NSBundle bundleForClass:[MyPublicCell class]]];
    [self.contentTable registerNib:publicCellNib forCellReuseIdentifier:publicIdentifier];
    
    user = [User userFromLocal];
    if (user) {
        [[HttpService sharedInstance]getMyCollection:@{@"user_id":user.hw_id,@"page":@"1",@"pageSize":@"10"} completionBlock:^(id object) {
            if ([object count]) {
                dataSource = object;
            }
        } failureBlock:^(NSError *error, NSString *responseString) {
            ;
        }];
    }else
    {
        //请登录
    }
   
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
    if (indexPath.row < 5) {
        return 180;
    }else{
        return 90;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MyCollectTableCell *productCell = (MyCollectTableCell*)[tableView dequeueReusableCellWithIdentifier:productIdentifier];
    
    MyPublicCell * publicCell = (MyPublicCell *)[tableView dequeueReusableCellWithIdentifier:publicIdentifier];
    
    
    return nil;
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
