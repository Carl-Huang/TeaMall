//
//  starView.m
//  TeaMall
//
//  Created by vedon on 13/1/14.
//  Copyright (c) 2014 helloworld. All rights reserved.
//
#define StarWidth  15
#define StarHeight 15

#import "starView.h"

@implementation starView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setStarNum:(NSInteger )starNumber
{
    NSUInteger currentOffsetX = 0;
    for (int i =0; i< starNumber; i++) {
        UIImageView * starImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"星星-实心"]];
        [starImage setFrame:CGRectMake(5+(StarWidth + 5)*i, 5, StarWidth, StarHeight)];
        [self addSubview:starImage];
        if (i == starNumber -1) {
            currentOffsetX += starImage.frame.origin.x + starImage.frame.size.width;
        }
        starImage = nil;
    }

    for (int j =0; j<(5-starNumber); j++) {
        UIImageView * starImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"星星-镂空"]];
        [starImage setFrame:CGRectMake(5+currentOffsetX+(StarWidth + 5)*j, 5, StarWidth, StarHeight)];
        [self addSubview:starImage];
        starImage = nil;
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
