//
//  HeadView.m
//  TeaMall
//
//  Created by vedon on 13/1/14.
//  Copyright (c) 2014 helloworld. All rights reserved.
//

#import "HeadView.h"

@implementation HeadView
@synthesize delegate = _delegate;
@synthesize section,open,backBtn;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        open = NO;
        self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.backBtn.frame = CGRectMake(0, 0, 320, 45.5);
        [self.backBtn.titleLabel setTextAlignment:NSTextAlignmentLeft];
        self.backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [self.backBtn addTarget:self action:@selector(doSelected) forControlEvents:UIControlEventTouchUpInside];
        [self.backBtn setBackgroundImage:[UIImage imageNamed:@"分类底"] forState:UIControlStateNormal];
        [self.backBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [self addSubview:self.backBtn];
        
        
        self.indicatorBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.indicatorBtn.frame = CGRectMake(220, 18, 15, 10);

        [self.indicatorBtn setImage:[UIImage imageNamed:@"下"] forState:UIControlStateSelected];
        [self.indicatorBtn setImage:[UIImage imageNamed:@"上"] forState:UIControlStateNormal];
        [self addSubview:self.indicatorBtn];

    

    }
    return self;
}

-(void)doSelected{
    if (_delegate && [_delegate respondsToSelector:@selector(selectedWith:viewTag:)]){
     	[_delegate selectedWith:self viewTag:self.tag];
    }
}
@end
