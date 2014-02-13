//
//  MarketNewRoundView.m
//  TeaMall
//
//  Created by vedon on 12/2/14.
//  Copyright (c) 2014 helloworld. All rights reserved.
//

#import "MarketNewRoundView.h"
#import "UIImageView+AFNetworking.h"
#import "MBProgressHUD.h"

@interface MarketNewRoundView()
{
    UIImageView * imageView;
    UILabel     * descriptionLabel;
}
@end
@implementation MarketNewRoundView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        imageView = nil;
        descriptionLabel = nil;
        // Initialization code
    }
    return self;
}

-(void)configureContentImage:(NSURL *)imageURL description:(NSString *)des
{
    
    MBProgressHUD * hub = [[MBProgressHUD alloc]initWithFrame:CGRectMake(self.frame.size.width/2- 15, self.frame.size.height/2-15, 15, 15)];
    hub.color = [UIColor blackColor];
    hub.dimBackground = YES;
    [hub setCustomView:nil];
    [hub setBackgroundColor:[UIColor clearColor]];
    [hub show:YES];
    NSURLRequest * request = [NSURLRequest requestWithURL:imageURL];
    __weak UIImageView * weakImageView = imageView;
    __weak UIView * weakSelf = self;
    [self addSubview:hub];
    [imageView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        weakImageView.image = image;
    
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf animated:YES];
    }];
    CGRect rect = self.frame;
    rect.origin.x = 0;
    rect.origin.y = 0;
    imageView.frame = rect;
    [imageView.layer setCornerRadius:0.5];
    
    UIView * maskView = [[UIView alloc]initWithFrame:CGRectMake(0, rect.size.height/5 * 3, rect.size.width, rect.size.height/4)];
    [maskView setBackgroundColor:[UIColor blackColor]];
    maskView.alpha = 0.6;
    
    descriptionLabel = [[UILabel alloc]initWithFrame:maskView.frame];
    descriptionLabel.font = [UIFont systemFontOfSize:13];
    descriptionLabel.text = des;
    descriptionLabel.textColor = [UIColor whiteColor];
    descriptionLabel.textAlignment = NSTextAlignmentCenter;
    
    
    [self addSubview:imageView];
    [self addSubview:maskView];
    [self addSubview:descriptionLabel];
    
    [self setBackgroundColor:[UIColor clearColor]];
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
