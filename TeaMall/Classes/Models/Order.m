//
//  Order.m
//  TeaMall
//
//  Created by Carl on 14-2-21.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "Order.h"

@implementation Order
/*
 *随机生成15位订单号,外部商户根据自己情况生成订单号
 */
+ (NSString *)generateTradeNO
{
	const int N = 15;
	
	NSString *sourceString = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
	NSMutableString *result = [[NSMutableString alloc] init];
	srand(time(0));
	for (int i = 0; i < N; i++)
	{
		unsigned index = rand() % [sourceString length];
		NSString *s = [sourceString substringWithRange:NSMakeRange(index, 1)];
		[result appendString:s];
	}
	return result;
}

@end
