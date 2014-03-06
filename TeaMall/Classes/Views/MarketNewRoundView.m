//
//  MarketNewRoundView.m
//  TeaMall
//
//  Created by vedon on 12/2/14.
//  Copyright (c) 2014 helloworld. All rights reserved.
//

#import "MarketNewRoundView.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"
#import "SDWebImageManager.h"
#import <QuartzCore/QuartzCore.h>
@interface MarketNewRoundView()
{
    UILabel     * descriptionLabel;
}

@end

@implementation MarketNewRoundView
@synthesize imageView;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGRect rect = self.frame;
        rect.origin.x = 0;
        rect.origin.y = 0;
        imageView = [[UIImageView alloc]initWithFrame:rect];
        descriptionLabel = nil;
//        CGRect rect = frame;
//        rect.origin.x = 0;
//        rect.origin.y = 0;
        imageView.frame = rect;
        [imageView.layer setCornerRadius:0.5];
        
        UIView * maskView = [[UIView alloc]initWithFrame:CGRectMake(0, rect.size.height/5 * 3, rect.size.width, rect.size.height/4)];
        [maskView setBackgroundColor:[UIColor blackColor]];
        maskView.alpha = 0.6;
        
        descriptionLabel = [[UILabel alloc]initWithFrame:maskView.frame];
        descriptionLabel.font = [UIFont systemFontOfSize:13];

        descriptionLabel.textColor = [UIColor whiteColor];
        descriptionLabel.textAlignment = NSTextAlignmentCenter;
        descriptionLabel.backgroundColor = [UIColor clearColor];
        
        [self addSubview:imageView];
        [self addSubview:maskView];
        [self addSubview:descriptionLabel];
        
        [self setBackgroundColor:[UIColor clearColor]];
        // Initialization code
    }
    return self;
}

-(void)configureContentImage:(NSURL *)imageURL description:(NSString *)des
{
    descriptionLabel.text = des;
    __block UIActivityIndicatorView *activityIndicator;
    activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.frame = CGRectMake(0.0, 0.0, 20.0, 20.0);
    CGPoint point = CGPointMake(self.frame.size.width/2 - activityIndicator.frame.size.width/2 ,self.frame.size.height/2 - activityIndicator.frame.size.height/2);
    activityIndicator.center = point;
    [self addSubview: activityIndicator];
    [activityIndicator startAnimating];
    
    __weak MarketNewRoundView * weakSelf = self;
    [imageView setImageWithURL:imageURL placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!error) {
                weakSelf.imageView.image = image;
                [activityIndicator stopAnimating];
                activityIndicator = nil;
            }else
            {
                UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"下载图片出错" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
                alertView = nil;
            }
        });
    }];

   
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
