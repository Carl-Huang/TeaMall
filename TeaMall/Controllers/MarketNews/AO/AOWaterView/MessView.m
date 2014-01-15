//
//  MessView.m
//  AOWaterView
//
//  Created by akria.king on 13-4-10.
//  Copyright (c) 2013年 akria.king. All rights reserved.
//

#import "MessView.h"
#import "UrlImageButton.h"
#import <QuartzCore/QuartzCore.h>
#define WIDTH 320/2
@implementation MessView
@synthesize idelegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithData:(DataInfo *)data yPoint:(float) y
{
    self = [super initWithFrame:CGRectMake(0, y, WIDTH, 100+10)];
    if (self) {
        UrlImageButton *imageBtn = [[UrlImageButton alloc]initWithFrame:CGRectMake(5,10, 150, 100)];//初始化url图片按钮控件
        [imageBtn setImageFromUrl:YES withUrl:data.url];//设置图片地质
        imageBtn.clipsToBounds = YES;
        imageBtn.layer.cornerRadius = 5.0;
        [imageBtn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:imageBtn];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(5, 70, 150, 30)];
        label.backgroundColor = [UIColor blackColor];
        label.alpha = 0.7;
        label.text=data.title;
        label.font = [UIFont systemFontOfSize:11];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor =[UIColor whiteColor];
        
        [self addSubview:label];
    }
    return self;
    
}

-(void)click{
    [self.idelegate click:self.dataInfo];
}
@end
