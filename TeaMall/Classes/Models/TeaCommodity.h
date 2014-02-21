//
//  TeaCommodity.h
//  TeaMall
//
//  Created by Carl on 14-2-20.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface TeaCommodity : NSManagedObject

@property (nonatomic, retain) NSString * hw_id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * price_p;
@property (nonatomic, retain) NSString * price_b;
@property (nonatomic, retain) NSString * hw__price;
@property (nonatomic, retain) NSString * price;
@property (nonatomic, retain) NSString * image;
@property (nonatomic, retain) NSString * weight;
@property (nonatomic, retain) NSString * year;
@property (nonatomic, retain) NSString * stock;
@property (nonatomic, retain) NSString * cate_id;
@property (nonatomic, retain) NSString * cate;
@property (nonatomic, retain) NSString * hw_description;
@property (nonatomic, retain) NSString * amount;
@property (nonatomic, retain) NSString * selected;
@property (nonatomic, retain) NSString * unit;
@end
