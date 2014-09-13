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
@property (nonatomic , strong) NSMutableArray * commodityList;  //存放商品模型数据
@property (strong,nonatomic) TeaCategory * teaCategory;
@property (strong,nonatomic) NSString * year;
@property (strong,nonatomic) NSString * keyword;

@property (nonatomic,assign) BOOL isFromZone;//是否来自点击@“进入专区”
@property (nonatomic,strong) NSString *zoneID;//专区的ID号

- (void)loadAllCommodity;
-(void)showLeftController:(id)sender;
- (void)showCommodityByCategory:(TeaCategory *)category;
- (void)searchCommodityWithKeyword:(NSString *)keyword;


@end
