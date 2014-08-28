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

#import "TeaMarketMainCell.h"

@implementation TeaMarketMainCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //创建按钮
        [self createButton];
        
//        NSMutableArray *tempArr = [NSMutableArray arrayWithCapacity:6];
//        
//        for (int i=0; i<6; i++) {
//            UIButton *btn = [[UIButton alloc] init];
//            btn.tag = i;
//            [btn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
//            [btn setBackgroundColor:[UIColor redColor]];
//            
//            [self addSubview:btn];
//            [tempArr addObject:btn];
//        }
//        
//        _btnArray = tempArr;
        
        //设置cell的布局
//        CGFloat width = self.bounds.size.width;
        [_firstBtn setBackgroundColor:[UIColor orangeColor]];
        [_secondBtn setBackgroundColor:[UIColor blueColor]];
        [_thirdBtn setBackgroundColor:[UIColor redColor]];
        [_fourthBtn setBackgroundColor:[UIColor orangeColor]];
        [_fifthBtn setBackgroundColor:[UIColor blueColor]];
        [_sixthBtn setBackgroundColor:[UIColor redColor]];
        
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
    return self;
}


- (void)createButton
{
    //初始化内部图片空间
    UIButton *first = [[UIButton alloc] init];
    first.tag = 1;
    [first addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:first];
    _firstBtn = first;
    
    UIButton *second = [[UIButton alloc] init];
    second.tag = 2;
    [second addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:second];
    _secondBtn = second;
    
    UIButton *third = [[UIButton alloc] init];
    third.tag = 3;
    [third addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:third];
    _thirdBtn = third;
    
    UIButton *fourth = [[UIButton alloc] init];
    fourth.tag = 4;
    [fourth addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:fourth];
    _fourthBtn = fourth;
    
    UIButton *fifth = [[UIButton alloc] init];
    fifth.tag = 5;
    [fifth addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:fifth];
    _fifthBtn = fifth;
    
    UIButton *sixth = [[UIButton alloc] init];
    sixth.tag = 6;
    [sixth addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:sixth];
    _sixthBtn = sixth;
}

#pragma mark 按钮监听方法
- (void)BtnClick:(UIButton *)btn
{
    [self.delegate TeaMarketMainCell:self didSelectedWithTag:btn.tag];
}

@end
