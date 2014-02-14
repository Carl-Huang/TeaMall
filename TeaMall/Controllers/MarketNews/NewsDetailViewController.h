//
//  NewsDetailViewController.h
//  TeaMall
//
//  Created by vedon on 18/1/14.
//  Copyright (c) 2014 helloworld. All rights reserved.
//

#import "CommonViewController.h"
@class MarketNews;
@interface NewsDetailViewController : CommonViewController
@property (strong ,nonatomic) MarketNews * news;
@property (strong ,nonatomic) UIImage  * poster;
@property (weak, nonatomic) IBOutlet UIImageView *postImageView;
@end
