//
//  UserModel.m
//  GouWu568
//
//  Created by echo13 on 15/10/6.
//  Copyright (c) 2015年 echo. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

- (void)setUserByDic:(NSDictionary *)dic{
    
    
    self.mybill = [[dic objectForKey:@"mybill"] isEqual:[NSNull null]]?@"":[dic objectForKey:@"mybill"];
    self.next_integral = [[dic objectForKey:@"next_integral"] isEqual:[NSNull null]]?@"":[dic objectForKey:@"next_integral"];
    self.user_address = [[dic objectForKey:@"user_address"] isEqual:[NSNull null]]?@"":[dic objectForKey:@"user_address"];
    self.user_address2 = [[dic objectForKey:@"user_address2"] isEqual:[NSNull null]]?@"":[dic objectForKey:@"user_address2"];
    self.user_addtime = [[dic objectForKey:@"user_addtime"] isEqual:[NSNull null]]?@"":[dic objectForKey:@"user_addtime"];
    self.user_birthday = [[dic objectForKey:@"user_birthday"] isEqual:[NSNull null]]?@"":[dic objectForKey:@"user_birthday"];
    self.user_id = [[dic objectForKey:@"user_id"] isEqual:[NSNull null]]?@"":[dic objectForKey:@"user_id"];
    self.user_integral = [[dic objectForKey:@"user_integral"] isEqual:[NSNull null]]?@"":[dic objectForKey:@"user_integral"];
    self.user_mail = [[dic objectForKey:@"user_mail"] isEqual:[NSNull null]]?@"":[dic objectForKey:@"user_mail"];
    self.user_name = [[dic objectForKey:@"user_name"] isEqual:[NSNull null]]?@"":[dic objectForKey:@"user_name"];
    self.user_num = [[dic objectForKey:@"user_num"] isEqual:[NSNull null]]?@"":[dic objectForKey:@"user_num"];
    self.user_password = [[dic objectForKey:@"user_password"] isEqual:[NSNull null]]?@"":[dic objectForKey:@"user_password"];
    self.user_phone = [[dic objectForKey:@"user_phone"] isEqual:[NSNull null]]?@"":[dic objectForKey:@"user_phone"];
    self.user_phone2 = [[dic objectForKey:@"user_phone2"] isEqual:[NSNull null]]?@"":[dic objectForKey:@"user_phone2"];
    self.user_qq = [[dic objectForKey:@"user_qq"] isEqual:[NSNull null]]?@"":[dic objectForKey:@"user_qq"];
    self.user_sex = [[dic objectForKey:@"user_sex"] isEqual:[NSNull null]]?@"":[dic objectForKey:@"user_sex"];
    self.user_status = [[dic objectForKey:@"user_status"] isEqual:[NSNull null]]?@"":[dic objectForKey:@"user_status"];
    self.vip = [[dic objectForKey:@"vip"] isEqual:[NSNull null]]?@"":[dic objectForKey:@"vip"];
    self.vip_content = [[dic objectForKey:@"vip_content"] isEqual:[NSNull null]]?@"":[dic objectForKey:@"vip_content"];
}


@end
