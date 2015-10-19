//
//  Tools.m
//  GouWu568
//
//  Created by echo13 on 15/9/29.
//  Copyright © 2015年 echo. All rights reserved.
//

#import "Tools.h"

@implementation Tools

+ (CompanyModel *)selectCompanyById:(NSString *)str{
    CompanyModel *companyM = [[CompanyModel alloc] init];
    NSString *selectCompanyUrl = [NSString stringWithFormat:CONTENTS_URL_SelectCompanyById,str];
    NSLog(@"%@",selectCompanyUrl);
    [HttpTools getWithURL:selectCompanyUrl params:nil success:^(id json) {
        NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",dic);
        [companyM setCompanyModelByDic:dic];
    } failure:^(NSError *error) {
        NSLog(@"%@",error.description);
    }];
    
    
    return companyM;
}
//判断是否登录
+ (BOOL)isLogin{
    //保存用户的文件路径
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *dicPath = [documentPath stringByAppendingPathComponent:@"userDic.plist"];
    NSLog(@"%@",dicPath);
    //判断路径是否存在
    NSFileManager *fileM = [[NSFileManager alloc] init];
    if ([fileM fileExistsAtPath:dicPath]) {//如果存在该路径
        return YES;
    }
    return NO;
}
//登录（将用户信息以词典的形式保存到本地）
+ (void)logIn:(NSDictionary *)userDic{
    //设置写入路径
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *dicPath = [documentPath stringByAppendingPathComponent:@"userDic.plist"];
    NSLog(@"%@",dicPath);
    
    //写入文件 atomically表示是否在写入前用临时文件
    [userDic writeToFile:dicPath atomically:YES];

    
}
//获取本地存储的uer对象
+ (NSDictionary *)getUser{
    //设置读取文件的路径
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *dicPath = [documentPath stringByAppendingPathComponent:@"userDic.plist"];
    //读取词典
    NSDictionary *getDic = [NSDictionary dictionaryWithContentsOfFile:dicPath];
    return getDic;
}
//登出
+ (void)logOut{
    //保存用户的文件路径
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *dicPath = [documentPath stringByAppendingPathComponent:@"userDic.plist"];
    //判断路径是否存在
    NSFileManager *fileM = [[NSFileManager alloc] init];
    if ([fileM fileExistsAtPath:dicPath]) {//如果存在该路径则删除
        NSFileManager *fileM = [[NSFileManager alloc] init];
        [fileM removeItemAtPath:dicPath error:nil];
        
    }
   
}
/**
 词典去空值
 */
+ (NSDictionary *)removeNullFromDic:(NSDictionary *)dic{
    for (NSString *keyStr in [dic allKeys]) {
        if ([[dic objectForKey:keyStr] isEqual:[NSNull null]]) {
            [dic setValue:@"" forKey:keyStr];
        }
    }
    return dic;
}
@end
