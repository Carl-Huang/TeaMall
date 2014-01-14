//
//  HeadView.h
//  TeaMall
//
//  Created by vedon on 13/1/14.
//  Copyright (c) 2014 helloworld. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HeadViewDelegate; 

@interface HeadView : UIView{
    id<HeadViewDelegate> delegate;
    NSInteger section;
    UIButton* backBtn;
    BOOL open;
}
@property(nonatomic, assign) id<HeadViewDelegate> delegate;
@property(nonatomic, assign) NSInteger section;
@property(nonatomic, assign) BOOL open;
@property(nonatomic, retain) UIButton* backBtn;
@property (strong ,nonatomic) UIButton * indicatorBtn;
@property (assign ,nonatomic) NSInteger viewTag;
@end

@protocol HeadViewDelegate <NSObject>
-(void)selectedWith:(HeadView *)view viewTag:(NSInteger)tag;
@end
