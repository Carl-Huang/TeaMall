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

#import "ContentCell.h"

@implementation ContentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //初始化内部图片空间
        UIButton *first = [[UIButton alloc] init];
        [self addSubview:first];
        _firstBtn = first;
        
        UIButton *second = [[UIButton alloc] init];
        [self addSubview:second];
        _secondBtn = second;
        
        UIButton *third = [[UIButton alloc] init];
        [self addSubview:third];
        _thirdBtn = third;
        
        UIButton *fourth = [[UIButton alloc] init];
        [self addSubview:fourth];
        _fourthBtn = fourth;
        
        UIButton *fifth = [[UIButton alloc] init];
        [self addSubview:fifth];
        _fifthBtn = fifth;
        
        UIButton *sixth = [[UIButton alloc] init];
        [self addSubview:sixth];
        _sixthBtn = sixth;
        
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
        CGFloat firstW = kImageWH * 2 +kImageBorder ;
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


@end
