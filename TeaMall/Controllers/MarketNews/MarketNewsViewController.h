//
//  MarketNewsViewController.h
//  TeaMall
//
//  Created by Carl on 14-1-10.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "CommonViewController.h"
//#import "EGORefreshTableHeaderView.h"
//#import "EGORefreshTableFooterView.h"
#import "AOWaterView.h"
@interface MarketNewsViewController : CommonViewController
@property (retain, nonatomic)AOWaterView *aoView;

@property (weak, nonatomic) IBOutlet UIScrollView *adScrolllView;

@end
