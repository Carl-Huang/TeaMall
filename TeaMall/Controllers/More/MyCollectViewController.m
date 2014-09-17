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
#import "MJRefresh.h"
#import "HWSDK.h"
#import "CustomiseServiceViewController.h"
static NSString * productIdentifier = @"cellIdentifier";
static NSString * publicIdentifier  = @"publicIdentifier";
static NSString *cellIdentifer = @"tradingTableCell";
@interface MyCollectViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    
    MJRefreshFooterView * refreshFooterView ;

    
}
@property (assign ,nonatomic) NSInteger currentPage;
@property (assign ,nonatomic) NSInteger pageSize;
@property (strong ,nonatomic) User * user;
@property (strong ,nonatomic) NSMutableArray * dataSource;
@end

@implementation MyCollectViewController
@synthesize currentPage,user,pageSize,dataSource;

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
    
    [self initializationInterface];
    [self configureDataSourceData];
}

-(void)initializationInterface
{
    [self setLeftCustomBarItem:@"返回" action:nil];
    [self setRightCustomBarItem:@"编辑" action:@selector(modifyMyCollectData:)];
    
    UINib * productCellNib = [UINib nibWithNibName:@"MyCollectTableCell" bundle:[NSBundle bundleForClass:[MyCollectTableCell class]]];
    [self.contentTable registerNib:productCellNib forCellReuseIdentifier:productIdentifier];
    
    UINib * publicCellNib = [UINib nibWithNibName:@"MyPublicCell" bundle:[NSBundle bundleForClass:[MyPublicCell class]]];
    [self.contentTable registerNib:publicCellNib forCellReuseIdentifier:publicIdentifier];
}


-(void)configureDataSourceData
{
     __weak MyCollectViewController * weakSelf = self;
    currentPage = 1;
    pageSize = 10;
    user = [User userFromLocal];
    
    
    refreshFooterView = [[MJRefreshFooterView alloc]initWithScrollView:self.contentTable];
    refreshFooterView.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
        ++ weakSelf.currentPage;
        
        [[HttpService sharedInstance]getMyCollection:@{@"user_id":weakSelf.user.hw_id,
                                                       @"page":[NSString stringWithFormat:@"%d",weakSelf.currentPage],
                                                       @"pageSize":[NSString stringWithFormat:@"%d",weakSelf.pageSize]}
                                     completionBlock:^(id object)
        {
            [refreshView endRefreshing];
            if ([object count]) {
                [weakSelf.dataSource addObjectsFromArray:object];
                [weakSelf saveObjectToLocal:object];
                [weakSelf.contentTable reloadData];
            }
        } failureBlock:^(NSError *error, NSString *responseString) {
            [refreshView endRefreshing];
        }];
    };
    
    
    if ([OSHelper isReachable]) {
        if (user) {
            [self deleteLocalCollectionData];

            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [[HttpService sharedInstance]getMyCollection:@{@"user_id":user.hw_id,@"page":[NSString stringWithFormat:@"%d",currentPage],@"pageSize":[NSString stringWithFormat:@"%d",pageSize]} completionBlock:^(id object) {
                [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
                if ([object count]) {
                    dataSource = [NSMutableArray arrayWithArray:object];
                    [weakSelf saveObjectToLocal:object];
                    [weakSelf.contentTable reloadData];
                }
            } failureBlock:^(NSError *error, NSString *responseString) {
                [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
            }];
        }else
        {
            //请登录
            [self showAlertViewWithMessage:@"请登录"];
        }
    }
    
}

-(void)saveObjectToLocal:(NSArray *)objects
{
    for (id object in objects) {
        
        if ([object isKindOfClass:[Commodity class]]) {
            Commodity * commodityObject = (Commodity *)object;
            ProductCollection * productObj = [ProductCollection MR_createEntity];
            productObj.collectionID = commodityObject.hw_id;
            [PersistentStore save];
        }else
        {
            
            Publish * publicObject = (Publish *)object;
            PublicCollection * publicObj = [PublicCollection MR_createEntity];
            publicObj.collectionID = publicObject.hw_id;
            [PersistentStore save];
        }

    }
}

-(void)deleteLocalCollectionData
{
    NSArray * productionCollections = [PersistentStore getAllObjectWithType:[ProductCollection class]];
    for (ProductCollection * obj in productionCollections) {
        [PersistentStore deleteObje:obj];
    }
    
    NSArray * publicCollections = [PersistentStore getAllObjectWithType:[PublicCollection class]];
    for (PublicCollection * object in publicCollections) {
        [PersistentStore deleteObje:object];
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
    @autoreleasepool {
        id object = [dataSource objectAtIndex:indexPath.row];
        
        if ([object isKindOfClass:[Commodity class]]) {
            
            return 90.0f;
        }else
        {
            return 180.0f;
        }
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
        productCell.presentPrice.text   = commodityObject.hw__price;
        productCell.originalPrice.text  = commodityObject.price;
        
        //原价小于现价，order为 降序，默认是升序
        if (commodityObject.hw__price.floatValue < commodityObject.price.floatValue) {
            productCell.orderImageView.image = [UIImage imageNamed:@"降价小图标.png"];
        }
        productCell.weight.text =  commodityObject.weight;
        [productCell.image setImageWithURL:[NSURL URLWithString:commodityObject.image] placeholderImage:[UIImage imageNamed:@"placeHolder.png"]];
        productCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [productCell.service addTarget:self action:@selector(callAction:) forControlEvents:UIControlEventTouchUpInside];
        return productCell;
    }else
    {
        MyPublicCell * publicCell = (MyPublicCell *)[tableView dequeueReusableCellWithIdentifier:publicIdentifier];
        Publish * publicObject = (Publish *)object;
        [publicCell.userImageView setImageWithURL:[NSURL URLWithString:publicObject.avatar] placeholderImage:[UIImage imageNamed:@"陈小姐-客服头像12"]];
        publicCell.productNameLabel.text    = publicObject.name;
        publicCell.brandLabel.text          = publicObject.brand;
        publicCell.amountLabel.text         = publicObject.amount;
        publicCell.priceLabel.text          = publicObject.price;
        publicCell.businessNumberLabel.text = publicObject.business_number;
        publicCell.publishDateLabel.text    = publicObject.publish_time;
        publicCell.closeBtn.hidden = NO;
        [publicCell.closeBtn setImage:[UIImage imageNamed:@"联系客服（未选中状态）"] forState:UIControlStateNormal];
        [publicCell.closeBtn setImage:[UIImage imageNamed:@"联系客服（选中状态）"] forState:UIControlStateHighlighted];
        if ([publicObject.image_1 length]) {
            [publicCell.imageView_1 setImageWithURL:[NSURL URLWithString:publicObject.image_1] placeholderImage:[UIImage imageNamed:@"placeHolder.png"]];
        }
        if ([publicObject.image_2 length]) {
            [publicCell.imageView_2 setImageWithURL:[NSURL URLWithString:publicObject.image_2] placeholderImage:[UIImage imageNamed:@"placeHolder.png"]];
        }
        if ([publicObject.image_3 length]) {
            [publicCell.imageView_3 setImageWithURL:[NSURL URLWithString:publicObject.image_3] placeholderImage:[UIImage imageNamed:@"placeHolder.png"]];
        }
        [publicCell.closeBtn addTarget:self action:@selector(callAction:) forControlEvents:UIControlEventTouchUpInside];
        publicCell.selectionStyle = UITableViewCellSelectionStyleNone;
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
    [[HttpService sharedInstance]deleteCollection:@{@"id":commodityObject.collection_id} completionBlock:^(id object) {
        hub.mode = MBProgressHUDModeText;
        hub.labelText = @"删除成功";
        [hub hide:YES afterDelay:1];
        
        //删除本地记录
        NSArray * tempArray = [PersistentStore getAllObjectWithType:[ProductCollection class]];
        for (ProductCollection * obj in tempArray) {
            if ([obj.collectionID isEqualToString:commodityObject.collection_id]) {
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
    [[HttpService sharedInstance] deleteCollection:@{@"id":publicObject.collection_id} completionBlock:^(id object) {
        hub.mode = MBProgressHUDModeText;
        hub.labelText = @"删除成功";
        [hub hide:YES afterDelay:1];
        
        //删除本地记录
        NSArray * tempArray = [PersistentStore getAllObjectWithType:[PublicCollection class]];
        for (PublicCollection * obj in tempArray) {
            if ([obj.collectionID isEqualToString:publicObject.collection_id]) {
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

- (void)callAction:(id)sender
{
    CustomiseServiceViewController * vc = [[CustomiseServiceViewController alloc] initWithNibName:nil bundle:nil];
    [self push:vc];
    vc = nil;
}
@end
