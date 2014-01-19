//
//  PersonalCenterViewController.h
//  TeaMall
//
//  Created by Carl_Huang on 14-1-12.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "CommonViewController.h"

//
//测试商品信息封装在Product中,外部商户可以根据自己商品实际情况定义
//
@interface Product : NSObject{
@private
	float     _price;
	NSString *_subject;
	NSString *_body;
	NSString *_orderId;
}

@property (nonatomic, assign) float price;
@property (nonatomic, retain) NSString *subject;
@property (nonatomic, retain) NSString *body;
@property (nonatomic, retain) NSString *orderId;

@end



@interface PersonalCenterViewController : CommonViewController
- (IBAction)myPersonalDataBtnAciton:(id)sender;

- (IBAction)MyPublicBtnAction:(id)sender;
- (IBAction)MyCollectBtnAction:(id)sender;
- (IBAction)myShoppingCarBtnAction:(id)sender;

- (IBAction)ZhifubaoAction:(id)sender;

@end
