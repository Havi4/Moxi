//
//  UserManager.m
//  ET
//
//  Created by centling on 13-11-7.
//  Copyright (c) 2013年 Zhaoyu Li. All rights reserved.
//

#import "UserManager.h"

static NSString* CUR_USERINFO = @"CURRENT_USER_INFO";
static NSString* CUR_USERID = @"CURRENT_USER_ID";
static NSString* CUR_OriginalUSERID = @"CUR_OriginalUSERID";
static NSString* CUR_USERTOKEN = @"CURRENT_USER_TOKEN";
static NSString* CUR_USEROPENID = @"CURRENT_USER_OPENID";
static NSString* CUR_USERICON = @"CURRENT_USER_ICON";
static NSString* CUR_USERPLATFORM= @"CURRENT_USER_PLATFORM";
static NSString* CUR_HardWareUUID = @"CUR_HardWareUUID";
static NSString* CUR_HardWareName = @"CUR_HardWareName";
static NSString* CUR_USERNICKNAME = @"CUR_USERNICKNAME";
static NSString* CUR_MeddoPhone = @"CUR_MeddoPhone";
static NSString* CUR_MeddoPassWord = @"CUR_MeddoPassWord";
static NSString* CUR_LeftHardWareUUID = @"CUR_LeftHardWareUUID";
static NSString* CUR_RightHardWareUUID = @"CUR_RightHardWareUUID";
static NSString* CUR_LeftHardWareName = @"CUR_LeftHardWareName";
static NSString* CUR_RightHardWareName = @"CUR_RightHardWareName";
static NSString* CUR_MineDevice = @"CUR_MineDevice";
static NSString* CUR_LanChoice = @"CUR_LangagueChoice";


@implementation UserManager

+(void) setGlobalOauth
{
    NSUserDefaults *global = [NSUserDefaults standardUserDefaults];
    if([global objectForKey:CUR_USERINFO]!=nil) {
        [global removeObjectForKey:CUR_USERINFO];
    }
    NSMutableDictionary* userinfo = [NSMutableDictionary dictionary];
    userinfo[CUR_USERID] = thirdPartyLoginUserId;
    userinfo[CUR_USERICON] = thirdPartyUseIcon;
    userinfo[CUR_USERNICKNAME] = thirdPartyNickName;
    userinfo[CUR_USEROPENID] = thirdPartyOpenID;
    userinfo[CUR_USERTOKEN] = thirdPartyAccess_Token;
    [global setObject:userinfo forKey:CUR_USERINFO];
}

+(void)resetUserInfo    {
    NSUserDefaults *global = [NSUserDefaults standardUserDefaults];
    if([global objectForKey:CUR_USERINFO]!=nil) {
        [global removeObjectForKey:CUR_USERINFO];
    }
    thirdPartyLoginUserId = @"";
    thirdPartyUseIcon = @"";
    thirdPartyNickName = @"";
    thirdPartyOpenID = @"";
    thirdPartyAccess_Token = @"";
}

+(void)resetInitUserInfo {
    
}

+(BOOL)IsUserLogged {
    BOOL ret = FALSE;
    NSMutableDictionary* userinfo = [[NSUserDefaults standardUserDefaults] objectForKey:CUR_USERINFO];
    //用户个人信息存在说名登录成功
    if (userinfo) {
        ret = TRUE;
    }
    return ret;
}

+(BOOL)GetUserObj {
    NSMutableDictionary* userinfo = [[NSUserDefaults standardUserDefaults] objectForKey:CUR_USERINFO];
    if (userinfo) {

        thirdPartyLoginUserId = [userinfo objectForKey:CUR_USERID];
        thirdPartyUseIcon = [userinfo objectForKey:CUR_USERICON];
        thirdPartyNickName = [userinfo objectForKey:CUR_USERNICKNAME];
        thirdPartyAccess_Token = [userinfo objectForKey:CUR_USERTOKEN];
        thirdPartyOpenID = [userinfo objectForKey:CUR_USEROPENID];
        return TRUE;
        
    } else {
        return FALSE;
    }
}

@end
