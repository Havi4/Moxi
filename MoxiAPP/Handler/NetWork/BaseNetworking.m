//
//  BaseNetworking.m
//  51JRQ
//
//  Created by HaviLee on 2017/2/24.
//  Copyright © 2017年 HaviLee. All rights reserved.
//

#import "BaseNetworking.h"

static BaseNetworking *baseApi = nil;

@implementation BaseNetworking


+ (id)sharedAPIManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        baseApi = [[BaseNetworking alloc]init];
    });
    return baseApi;
}


- (void)addCarOrderWith:(NSDictionary *)params
             success:(HYBResponseSuccess)success
                fail:(HYBResponseFail)fail
{
    [HYBNetworking postWithUrl:@"yc/add/" refreshCache:YES params:params success:success fail:fail];
}

- (void)addHourseOrderWith:(NSDictionary *)params
                success:(HYBResponseSuccess)success
                   fail:(HYBResponseFail)fail
{
    [HYBNetworking postWithUrl:@"ms/add/" refreshCache:YES params:params success:success fail:fail];
}


@end
