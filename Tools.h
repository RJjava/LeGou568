//
//  Tools.h
//  GouWu568
//
//  Created by echo13 on 15/9/29.
//  Copyright © 2015年 echo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"

@interface Tools : NSObject

+ (CompanyModel *)selectCompanyById:(NSString *)str;
//判断是否登录
+ (BOOL)isLogin;
//登录（将用户信息以词典的形式归档到本地）
+ (void)logIn:(NSDictionary *)userDic;
//获取本地存储的uer对象
+ (NSDictionary *)getUser;
//登出
+ (void)logOut;
/**
 词典去空值
 */
+ (NSDictionary *)removeNullFromDic:(NSDictionary *)dic;
@end
