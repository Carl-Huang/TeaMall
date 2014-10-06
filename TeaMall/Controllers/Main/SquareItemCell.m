//
//  SquareItemCell.m
//  TeaMall
//
//  Created by vedon on 13/1/14.
//  Copyright (c) 2014 helloworld. All rights reserved.
//

#import "SquareItemCell.h"
#import "starView.h"

#define reduceHeight 40.0


@implementation SquareItemCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self.littleStarView setStarNum:1];
}

//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//    if (self.imageView_1.hidden && self.imageView_2.hidden && self.imageView_3.hidden) {
//        CGRect tempF1 = CGRectMake(self.tranctionNumberLabel.frame.origin.x, self.tranctionNumberLabel.frame.origin.y - reduceHeight, self.tranctionNumberLabel.frame.size.width, self.tranctionNumberLabel.frame.size.height);
//        self.tranctionNumberLabel.frame = tempF1;
//        CGRect tempF2 = CGRectMake(self.tractionNumber.frame.origin.x, self.tractionNumber.frame.origin.y - reduceHeight, self.tractionNumber.frame.size.width, self.tractionNumber.frame.size.height);
//        self.tractionNumber.frame = tempF2;
//        CGRect tempF3 = CGRectMake(self.tranctionDate.frame.origin.x, self.tranctionDate.frame.origin.y - reduceHeight, self.tranctionDate.frame.size.width, self.tranctionDate.frame.size.height);
//        self.tranctionDate.frame = tempF3;
//        CGRect f = self.bounds;
//        self.bounds = CGRectMake(0, 0, f.size.width, f.size.height - reduceHeight);
//    }
//    
//}

@end
