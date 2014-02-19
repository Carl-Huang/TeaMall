//
//  Address.m
//  TeaMall
//
//  Created by Carl on 14-2-13.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "Address.h"
#define Address_Key    @"MyAddress"
@implementation Address
- (void)saveToLocal
{
    NSDictionary * info = [Address toDictionary:self];
    [[NSUserDefaults standardUserDefaults] setObject:info forKey:Address_Key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (Address *)addressFromLocal
{
    if(![[NSUserDefaults standardUserDefaults] objectForKey:Address_Key])
    {
        return nil;
    }
    NSDictionary * info = [[NSUserDefaults standardUserDefaults] objectForKey:Address_Key];
    Address * address = (Address *)[Address fromDictionary:info withClass:[Address class]];
    return address;
}
@end
