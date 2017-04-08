//
//  BaseNetworking.h
//  51JRQ
//
//  Created by HaviLee on 2017/2/24.
//  Copyright © 2017年 HaviLee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HYBNetworking.h"

@interface BaseNetworking : NSObject

/**
 单例

 @return 返回网络单例
 */
+ (id)sharedAPIManager;
- (void)addCarOrderWith:(NSDictionary *)params
                success:(HYBResponseSuccess)success
                   fail:(HYBResponseFail)fail;
- (void)addHourseOrderWith:(NSDictionary *)params
                   success:(HYBResponseSuccess)success
                      fail:(HYBResponseFail)fail;

- (void)getMSOrderWith:(NSDictionary *)params
                   success:(HYBResponseSuccess)success
                      fail:(HYBResponseFail)fail;
- (void)getYCOrderWith:(NSDictionary *)params
               success:(HYBResponseSuccess)success
                  fail:(HYBResponseFail)fail;
- (void)getMYOrderWith:(NSDictionary *)params
               success:(HYBResponseSuccess)success
                  fail:(HYBResponseFail)fail;
@end
