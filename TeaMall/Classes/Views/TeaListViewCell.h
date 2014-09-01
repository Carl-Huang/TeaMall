//
//  TeaListViewCell.h
//  TeaMall
//
//  Created by Carl_Huang on 14-9-1.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TeaListViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *teaName;
@property (weak, nonatomic) IBOutlet UILabel *originalPrice;
@property (weak, nonatomic) IBOutlet UILabel *currentPrice;
@property (weak, nonatomic) IBOutlet UILabel *teaWeight;
@property (weak, nonatomic) IBOutlet UIImageView *originalPriceLineImage;
@property (weak, nonatomic) IBOutlet UIImageView *teaImage;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;
@property (weak, nonatomic) IBOutlet UILabel *percentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *seperateLine;

@end
