//
//  NSString+Utils.m
//  HWSDK
//
//  Created by Carl on 13-11-25.
//  Copyright (c) 2013年 HelloWorld. All rights reserved.
//

#import "NSString+Utils.h"

@implementation NSString (Utils)
- (NSString *)filterHTML
{
    NSScanner * theScanner;
    NSString * text = nil;
    NSString * html = self;
    theScanner = [NSScanner scannerWithString:html];
    while ([theScanner isAtEnd] == NO) {
        [theScanner scanUpToString:@"<" intoString:NULL];
        [theScanner scanUpToString:@">" intoString:&text];
        html = [html stringByReplacingOccurrencesOfString:[ NSString stringWithFormat:@"%@>", text] withString:@" "];
    }
    html = [html stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    return html;
}

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
