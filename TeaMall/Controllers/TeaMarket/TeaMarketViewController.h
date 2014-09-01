//
//  TeaMarketViewController.h
//  TeaMall
//
//  Created by Carl on 14-1-10.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "CommonViewController.h"
@class TeaCategory;
@interface TeaMarketViewController : CommonViewController
@property (weak, nonatomic) IBOutlet UICollectionView *contentCollection;

@property (strong,nonatomic) TeaCategory * teaCategory;
@property (strong,nonatomic) NSString * year;
@property (strong,nonatomic) NSString * keyword;
- (void)loadAllCommodity;
-(void)showLeftController:(id)sender;
- (void)showCommodityByCategory:(TeaCategory *)category;
- (void)searchCommodityWithKeyword:(NSString *)keyword;


@end
