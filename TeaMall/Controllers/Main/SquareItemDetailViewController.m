//
//  SquareItemDetailViewController.m
//  TeaMall
//
//  Created by vedon on 13/1/14.
//  Copyright (c) 2014 helloworld. All rights reserved.
//

#import "SquareItemDetailViewController.h"
#import "starView.h"
#import "UIViewController+BarItem.h"
#import "CustomiseServiceViewController.h"
#import "MBProgressHUD.h"
#import "PublicCollection.h"
#import "HttpService.h"
#import "PersistentStore.h"
#import "User.h"
#import "UIImageView+AFNetworking.h"
@interface SquareItemDetailViewController ()
{
    User * user;
}
@end

@implementation SquareItemDetailViewController

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
    [self.littleStarView setStarNum:5];
    [self setLeftCustomBarItem:@"返回" action:nil];
//    [self setRightCustomBarItem:@"收藏（爱心）" action:@selector(addToFavorite)];
     self.navigationItem.rightBarButtonItem = [self customBarItem:@"收藏（爱心）" action:@selector(addToFavorite) size:CGSizeMake(35,30)];
    
    _userName.text = _publish.account;
    _description.text = _publish.name;
    _transactionNum.text = _publish.business_number;
    NSString * publishDate = [[NSDate dateFromString:_publish.publish_time withFormat:@"yyyy-MM-dd hh:mm:ss"] formatDateString:@"yyyy-MM-dd"];
    _transactionDate.text = publishDate;
    _productNameLabel.text = _publish.name;
    _priceLabel.text = [NSString stringWithFormat:@"￥%@",_publish.price];
    _brandLabel.text = _publish.brand;
    _amountLabel.text = _publish.amount;
    if([_publish.is_buy isEqualToString:@"0"])
    {
        _transactionType.text = @"我要卖";
    }
    else
    {
        _transactionType.text = @"我要买";
    }
    [_imageView_1 setImageWithURL:[NSURL URLWithString:_publish.image_1]];
    [_imageView_2 setImageWithURL:[NSURL URLWithString:_publish.image_2]];
    [_imageView_3 setImageWithURL:[NSURL URLWithString:_publish.image_3]];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addToFavorite
{
    NSLog(@"%s",__func__);
    user = [User userFromLocal];
    if (user) {
        NSArray * collections = [PersistentStore getAllObjectWithType:[PublicCollection class]];
        BOOL isShouldAdd = YES;
        for (PublicCollection * obj in collections) {
            if ([obj.collectionID isEqualToString:self.publish.hw_id]) {
                isShouldAdd = NO;
                break;
            }
        }
        
        if (isShouldAdd) {
            MBProgressHUD * hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hub.labelText = @"添加收藏";
            __weak SquareItemDetailViewController * weakSelf = self;
            [[HttpService sharedInstance]addCollection:@{@"user_id":user.hw_id,@"collection_id":self.publish.hw_id,@"type":@"2"} completionBlock:^(id object) {
                
                hub.mode = MBProgressHUDModeText;
                hub.labelText = object;
                [weakSelf saveToLocal];
                [hub hide:YES afterDelay:1];
                
            } failureBlock:^(NSError *error, NSString *responseString) {
                hub.mode = MBProgressHUDModeText;
                hub.labelText = @"添加失败";
                [hub hide:YES afterDelay:1];
            }];
        }else
        {
            //已经保存
            [self showAlertViewWithMessage:@"已经收藏"];
        }

    }
    
    
}

-(void)saveToLocal
{
    PublicCollection * collection = [PublicCollection MR_createEntity];
    collection.collectionID = self.publish.hw_id;
    [[NSManagedObjectContext MR_defaultContext]MR_saveOnlySelfAndWait];
}

- (IBAction)contactCustomerServiceAction:(id)sender
{
    [self gotoContactServiceViewController];
}

-(void)gotoContactServiceViewController
{
    CustomiseServiceViewController * viewController = [[CustomiseServiceViewController alloc]initWithNibName:@"CustomiseServiceViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
    viewController = nil;
}
@end
