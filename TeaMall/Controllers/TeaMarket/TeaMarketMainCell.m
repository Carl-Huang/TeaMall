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

@implementation TeaMarketMainCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //取消cell的选中样式
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = kCellBg;
        
        //创建按钮
        _firstBtn = [self createButtonWithTag:1];
        _secondBtn = [self createButtonWithTag:2];
        _thirdBtn = [self createButtonWithTag:3];
        _fourthBtn = [self createButtonWithTag:4];
        _fifthBtn = [self createButtonWithTag:5];
        _sixthBtn = [self createButtonWithTag:6];

        //临时设置背景颜色
        [_firstBtn setBackgroundColor:[UIColor orangeColor]];
        [_secondBtn setBackgroundColor:[UIColor blueColor]];
        [_thirdBtn setBackgroundColor:[UIColor redColor]];
        [_fourthBtn setBackgroundColor:[UIColor orangeColor]];
        [_fifthBtn setBackgroundColor:[UIColor blueColor]];
        [_sixthBtn setBackgroundColor:[UIColor redColor]];
        
        //设置内部按钮控件
        [self setBtnFrames];
    }
    return self;
}

#pragma 初始化内部按钮
- (UIButton *)createButtonWithTag:(int) index
{
    //初始化内部图片控件
    UIButton *btn = [[UIButton alloc] init];
    btn.tag = index;
    [btn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    return btn;
}

#pragma mark 设置内部按钮控件的位置
- (void)setBtnFrames
{
    CGFloat firstX = kImageBorder;
    CGFloat firstY = kImageBorder;
    CGFloat firstW = kImageWH * 2 +kImageBorder;
    CGFloat firstH = firstW;
    [_firstBtn setFrame:CGRectMake(firstX, firstY, firstW, firstH)];
    
    CGFloat secondX = firstX + firstW + kImageBorder;
    CGFloat secondY = firstY;
    CGFloat secondW = kImageWH;
    CGFloat secondH = kImageWH;
    [_secondBtn setFrame:CGRectMake(secondX ,secondY, secondW, secondH)];
    
    CGFloat thirdX = secondX;
    CGFloat thirdY = secondY + secondW + kImageBorder;
    CGFloat thirdW = kImageWH;
    CGFloat thirdH = kImageWH;
    [_thirdBtn setFrame:CGRectMake(thirdX, thirdY, thirdW, thirdH)];
    
    CGFloat fourthX = kImageBorder;
    CGFloat fourthY = firstY + firstH + kImageBorder;
    CGFloat fourthW = kImageWH;
    CGFloat fourthH = kImageWH;
    [_fourthBtn setFrame:CGRectMake(fourthX, fourthY, fourthW, fourthH)];
    
    CGFloat fifthX = fourthX + fourthW + kImageBorder;
    CGFloat fifthY = fourthY;
    CGFloat fifthW = kImageWH;
    CGFloat fifthH = kImageWH;
    [_fifthBtn setFrame:CGRectMake(fifthX, fifthY, fifthW, fifthH)];
    
    CGFloat sisthX = fifthX + fifthW + kImageBorder;
    CGFloat sisthY = fifthY;
    CGFloat sisthW = kImageWH;
    CGFloat sisthH = kImageWH;
    [_sixthBtn setFrame:CGRectMake(sisthX, sisthY, sisthW, sisthH)];
}

#pragma mark 按钮监听方法
- (void)BtnClick:(UIButton *)btn
{
    [self.delegate TeaMarketMainCell:self didSelectedWithTag:btn.tag];
}

#pragma mark --重写set方法
- (void)setZone:(CommodityZone *)zone
{
    _zone = zone;
    
    NSArray *goodList = zone.goods_list;
    
//    [_firstBtn.imageView setImageWithURL:<#(NSURL *)#> placeholderImage:<#(UIImage *)#>]
#warning 后台数据暂未做好，暂不处理
//    [_fifthBtn setBackgroundImage:image forState:UIControlStateNormal];
}


@end
