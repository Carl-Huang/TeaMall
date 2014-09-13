//
//  ContentCell.h
//  茶叶市场的主界面demo
//
//  Created by Carl_Huang on 14-8-26.
//  Copyright (c) 2014年 HelloWorld. All rights reserved.
//



#import <UIKit/UIKit.h>

@class CommodityZone;
@class TeaMarketMainCell;

#pragma mark - 定义协议，通知控制器跳转
@protocol TeaMarketMainCellDelegate <NSObject>

@optional
- (void)TeaMarketMainCellDidSelectedWithTag:(NSInteger)tag indexPath:(NSIndexPath *)indexPath;

@end


@interface TeaMarketMainCell : UITableViewCell

@property (weak, nonatomic) id<TeaMarketMainCellDelegate> delegate;

@property(nonatomic,strong) UIImageView *firstView;     //第一张图
@property(nonatomic,strong) UIImageView *secondView;   //第二张图
@property(nonatomic,strong) UIImageView *thirdView;    //第三张图
@property(nonatomic,strong) UIImageView *fourthView;   //第四张图
@property(nonatomic,strong) UIImageView *fifthView;    //第五张图
@property(nonatomic,strong) UIImageView *sixthView;    //第六张图

@property(nonatomic,strong) CommodityZone *zone;

@property (nonatomic,strong) NSIndexPath *indexPath;


@end
