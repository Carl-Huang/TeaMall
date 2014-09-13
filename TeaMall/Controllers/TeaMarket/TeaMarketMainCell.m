//
//  ContentCell.m
//  茶叶市场的主界面demo
//
//  Created by Carl_Huang on 14-8-26.
//  Copyright (c) 2014年 HelloWorld. All rights reserved.
//

#define kSmallCellHeight    (self.bounds.size.width/3)          //较小的cell高度
#define kBigCellHeight      (kSmallCellHeight*2)                //较小的cell高度
#define kImageBorder        10                                   //imageViewBorder的间距
#define kImageWH            ((self.bounds.size.width - 4*kImageBorder)/3) //每个imageView的宽高
#define kCellBg             kColor(172,117,91)

#import "TeaMarketMainCell.h"
#import "CommodityZone.h"
#import "UIImageView+AFNetworking.h"
#import "SDWebImageManager.h"
#import "Commodity.h"

@interface TeaMarketMainCell()
{
    NSMutableArray *_viewArray;
}

@end

@implementation TeaMarketMainCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //取消cell的选中样式
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = kCellBg;
        
        //初始化按钮数组
        _viewArray = [NSMutableArray array];
        
        //创建imageView
        _firstView = [self createViewWithTag:0];
        _secondView = [self createViewWithTag:1];
        _thirdView = [self createViewWithTag:2];
        _fourthView = [self createViewWithTag:3];
        _fifthView = [self createViewWithTag:4];
        _sixthView = [self createViewWithTag:5];

        //临时设置背景颜色
        [_firstView setBackgroundColor:[UIColor grayColor]];
        [_secondView setBackgroundColor:[UIColor grayColor]];
        [_thirdView setBackgroundColor:[UIColor grayColor]];
        [_fourthView setBackgroundColor:[UIColor grayColor]];
        [_fifthView setBackgroundColor:[UIColor grayColor]];
        [_sixthView setBackgroundColor:[UIColor grayColor]];
        
        //设置内部按钮控件
        [self setBtnFrames];
    }
    return self;
}

#pragma 初始化内部按钮
- (UIImageView *)createViewWithTag:(int) index
{
    //初始化内部图片控件
    UIImageView *btn = [[UIImageView alloc] init];
    btn.userInteractionEnabled = YES;
    btn.tag = index;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(BtnClick:)];
    [btn addGestureRecognizer:singleTap];
    [self addSubview:btn];
    [_viewArray addObject:btn];
    return btn;
}

#pragma mark 设置内部按钮控件的位置
- (void)setBtnFrames
{
    CGFloat firstX = kImageBorder;
    CGFloat firstY = kImageBorder;
    CGFloat firstW = kImageWH * 2 +kImageBorder;
    CGFloat firstH = firstW;
    [_firstView setFrame:CGRectMake(firstX, firstY, firstW, firstH)];
    
    //为第一张图加一个logo
    [self addLogo];
    
    CGFloat secondX = firstX + firstW + kImageBorder;
    CGFloat secondY = firstY;
    CGFloat secondW = kImageWH;
    CGFloat secondH = kImageWH;
    [_secondView setFrame:CGRectMake(secondX ,secondY, secondW, secondH)];
    
    CGFloat thirdX = secondX;
    CGFloat thirdY = secondY + secondW + kImageBorder;
    CGFloat thirdW = kImageWH;
    CGFloat thirdH = kImageWH;
    [_thirdView setFrame:CGRectMake(thirdX, thirdY, thirdW, thirdH)];
    
    CGFloat fourthX = kImageBorder;
    CGFloat fourthY = firstY + firstH + kImageBorder;
    CGFloat fourthW = kImageWH;
    CGFloat fourthH = kImageWH;
    [_fourthView setFrame:CGRectMake(fourthX, fourthY, fourthW, fourthH)];
    
    CGFloat fifthX = fourthX + fourthW + kImageBorder;
    CGFloat fifthY = fourthY;
    CGFloat fifthW = kImageWH;
    CGFloat fifthH = kImageWH;
    [_fifthView setFrame:CGRectMake(fifthX, fifthY, fifthW, fifthH)];
    
    CGFloat sisthX = fifthX + fifthW + kImageBorder;
    CGFloat sisthY = fifthY;
    CGFloat sisthW = kImageWH;
    CGFloat sisthH = kImageWH;
    [_sixthView setFrame:CGRectMake(sisthX, sisthY, sisthW, sisthH)];
}

#pragma mark 加入进入专区的logo
- (void)addLogo
{
    UIButton *firstViewBtn = [[UIButton alloc] init];
    firstViewBtn.enabled = NO;
    firstViewBtn.adjustsImageWhenDisabled = NO;
    [firstViewBtn setBackgroundColor:[UIColor whiteColor]];
//    [firstViewBtn setBackgroundImage:[UIImage imageNamed:@"白框3.png"] forState:UIControlStateNormal];
    [firstViewBtn setTitleColor:kCellBg forState:UIControlStateNormal];
    firstViewBtn.layer.cornerRadius=15.0f;
    firstViewBtn.layer.borderColor = [[UIColor clearColor] CGColor];
    firstViewBtn.layer.borderWidth = 1.0;
    [firstViewBtn setTitle:@"进入专区>" forState:UIControlStateNormal];
    firstViewBtn.titleLabel.font  = [UIFont systemFontOfSize:13.0];
    CGFloat w = _firstView.bounds.size.width;
    CGFloat h = _firstView.bounds.size.height;
    firstViewBtn.frame = CGRectMake( w - w * 0.4 - 5, h - h *0.125 - 5, w*0.4, h*0.125);
    [_firstView addSubview:firstViewBtn];
}

#pragma mark 按钮监听方法
- (void)BtnClick:(UITapGestureRecognizer *)gesture
{
    [self.delegate TeaMarketMainCellDidSelectedWithTag:gesture.view.tag indexPath:self.indexPath];
}

#pragma mark --重写set方法
- (void)setZone:(CommodityZone *)zone
{
    _zone = zone;
    //设置专区图片
    [_firstView setImageWithURL:[NSURL URLWithString:zone.image] placeholderImage:[UIImage imageNamed:@"关闭交易（选中状态）"]];
    //设置商品列表图片
    NSArray *goodList = zone.goods_list;
    int count = _viewArray.count;
    for (int i = 0 ; i < count - 1; i++) {
        if (i > goodList.count - 1) {    //
            [_viewArray[i+1] setImage:[UIImage imageNamed:@"关闭交易（选中状态）"]];
        }else{
            Commodity *commodity = zone.goods_list[i];
            [_viewArray[i+1] setImageWithURL:[NSURL URLWithString:commodity.image] placeholderImage:[UIImage imageNamed:@"关闭交易（选中状态）"]];
        }
    }
}

@end
