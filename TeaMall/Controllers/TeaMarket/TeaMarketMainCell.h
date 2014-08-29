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
- (void)TeaMarketMainCell:(TeaMarketMainCell *)teaMarketMainCell didSelectedWithTag:(NSInteger)tag;

@end


@interface TeaMarketMainCell : UITableViewCell

//@property(nonatomic,strong) NSArray *btnArray;   //存放按钮的数组

@property (weak, nonatomic) id<TeaMarketMainCellDelegate> delegate;

@property(nonatomic,strong) UIButton *firstBtn;     //第一张图
@property(nonatomic,strong) UIButton *secondBtn;   //第二张图
@property(nonatomic,strong) UIButton *thirdBtn;    //第三张图
@property(nonatomic,strong) UIButton *fourthBtn;   //第四张图
@property(nonatomic,strong) UIButton *fifthBtn;    //第五张图
@property(nonatomic,strong) UIButton *sixthBtn;    //第六张图

//@property(nonatomic,strong) NSIndexPath *indexPath; //根据该属性来确定内控空间布局

@property(nonatomic,strong) CommodityZone *zone;

@end
