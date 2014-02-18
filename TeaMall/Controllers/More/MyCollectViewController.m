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
#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"
#import "PersistentStore.h"
static NSString * productIdentifier = @"cellIdentifier";
static NSString * publicIdentifier  = @"publicIdentifier";
static NSString *cellIdentifer = @"tradingTableCell";
@interface MyCollectViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray * dataSource;
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
    __weak MyCollectViewController * weakSelf = self;
    if (user) {
        [[HttpService sharedInstance]getMyCollection:@{@"user_id":user.hw_id,@"page":@"1",@"pageSize":@"10"} completionBlock:^(id object) {
            if ([object count]) {
                dataSource = [NSMutableArray arrayWithArray:object];
                [weakSelf.contentTable reloadData];
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
    
    id object = [dataSource objectAtIndex:indexPath.row];
    
    if ([object isKindOfClass:[Commodity class]]) {
         MyCollectTableCell *productCell = (MyCollectTableCell*)[tableView dequeueReusableCellWithIdentifier:productIdentifier];
        Commodity * commodityObject = (Commodity *)object;
        productCell.name.text = commodityObject.name;
        productCell.presentPrice.text   = commodityObject.price;
        productCell.originalPrice.text  = commodityObject.hw__price;
        productCell.weight.text =  commodityObject.weight;
        return productCell;
    }else
    {
        MyPublicCell * publicCell = (MyPublicCell *)[tableView dequeueReusableCellWithIdentifier:publicIdentifier];
        Publish * publicObject = (Publish *)object;
        publicCell.productNameLabel.text    = publicObject.name;
        publicCell.brandLabel.text          = publicObject.brand;
        publicCell.amountLabel.text         = publicObject.amount;
        publicCell.priceLabel.text          = publicObject.price;
        publicCell.businessNumberLabel.text = publicObject.business_number;
        publicCell.publishDateLabel.text    = publicObject.publish_time;
        
        if ([publicObject.image_1 length]) {
            [publicCell.imageView_1 setImageWithURL:[NSURL URLWithString:publicObject.image_1] placeholderImage:nil];
        }
        if ([publicObject.image_2 length]) {
            [publicCell.imageView_2 setImageWithURL:[NSURL URLWithString:publicObject.image_2] placeholderImage:nil];
        }
        if ([publicObject.image_3 length]) {
            [publicCell.imageView_3 setImageWithURL:[NSURL URLWithString:publicObject.image_3] placeholderImage:nil];
        }
        
        return publicCell;
    }

}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{

    return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        id object = [dataSource objectAtIndex:indexPath.row];
        if ([object isKindOfClass:[Commodity class]]) {
            //删除商品
            [self deleteMyProductCollection:object];
        }else
        {
            //删除发布
            [self deleteMyPublicCollection:object];
        }
        
        [dataSource removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

-(void)deleteMyProductCollection:(Commodity *)commodityObject
{
    MBProgressHUD * hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hub.labelText = @"删除收藏";
    __weak MyCollectViewController * weakSelf = self;
    [[HttpService sharedInstance]deleteCollection:@{@"id":commodityObject.hw_id} completionBlock:^(id object) {
        hub.mode = MBProgressHUDModeText;
        hub.labelText = @"删除成功";
        [hub hide:YES afterDelay:1];
        
        //删除本地记录
        NSArray * tempArray = [PersistentStore getAllObjectWithType:[ProductCollection class]];
        for (ProductCollection * obj in tempArray) {
            if ([obj.collectionID isEqualToString:commodityObject.hw_id]) {
                [PersistentStore deleteObje:obj];
                break;
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.contentTable reloadData];
        });
    } failureBlock:^(NSError *error, NSString *responseString) {
        hub.mode = MBProgressHUDModeText;
        hub.labelText = @"删除失败";
        [hub hide:YES afterDelay:1];
    }];
}

-(void)deleteMyPublicCollection:(Publish *)publicObject
{
    MBProgressHUD * hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hub.labelText = @"删除收藏";
    __weak MyCollectViewController * weakSelf = self;
    [[HttpService sharedInstance]deletePublish:@{@"id":publicObject.hw_id} completionBlock:^(id object) {
        hub.mode = MBProgressHUDModeText;
        hub.labelText = @"删除成功";
        [hub hide:YES afterDelay:1];
        
        //删除本地记录
        NSArray * tempArray = [PersistentStore getAllObjectWithType:[PublicCollection class]];
        for (PublicCollection * obj in tempArray) {
            if ([obj.collectionID isEqualToString:publicObject.hw_id]) {
                [PersistentStore deleteObje:obj];
                break;
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.contentTable reloadData];
        });
        
    } failureBlock:^(NSError *error, NSString *responseString) {
        hub.mode = MBProgressHUDModeText;
        hub.labelText = @"删除失败";
        [hub hide:YES afterDelay:1];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
