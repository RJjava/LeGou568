//
//  UserModel.h
//  GouWu568
//
//  Created by echo13 on 15/10/6.
//  Copyright (c) 2015年 echo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject
/**
 用户
 */
@property (strong, nonatomic) NSString *mybill;
/**
 用户
 */
@property (strong, nonatomic) NSString *next_integral;
/**
 用户
 */
@property (strong, nonatomic) NSString *user_address;
/**
 用户
 */
@property (strong, nonatomic) NSString *user_address2;
/**
 用户
 */
@property (strong, nonatomic) NSString *user_addtime;
/**
 用户
 */
@property (strong, nonatomic) NSString *user_birthday;
/**
 用户
 */
@property (strong, nonatomic) NSString *user_id;
/**
 用户
 */
@property (strong, nonatomic) NSString *user_integral;
/**
 用户
 */
@property (strong, nonatomic) NSString *user_mail;
/**
 用户
 */
@property (strong, nonatomic) NSString *user_name;
/**
 用户
 */
@property (strong, nonatomic) NSString *user_num;
/**
 用户
 */
@property (strong, nonatomic) NSString *user_password;
/**
 用户
 */
@property (strong, nonatomic) NSString *user_phone;
/**
 用户
 */
@property (strong, nonatomic) NSString *user_phone2;
/**
 用户
 */
@property (strong, nonatomic) NSString *user_qq;
/**
 用户
 */
@property (strong, nonatomic) NSString *user_sex;
/**
 用户
 */
@property (strong, nonatomic) NSString *user_status;
/**
 用户
 */
@property (strong, nonatomic) NSString *vip;
/**
 用户
 */
@property (strong, nonatomic) NSString *vip_content;

//通过dic设置用户信息
- (void)setUserByDic:(NSDictionary *)dic;


@end
