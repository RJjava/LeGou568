//
//  CompanyModel.h
//  GouWu568
//
//  Created by echo13 on 15/9/25.
//  Copyright © 2015年 echo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CompanyModel : NSObject
/**
 店铺 Id
 */
@property (strong, nonatomic) NSString *company_id;
/**
 店铺长名字
 */
@property (strong, nonatomic) NSString *company_name;
/**
 店铺短名字
 */
@property (strong, nonatomic) NSString *company_shortname;
/**
 店铺连接
 */
@property (strong, nonatomic) NSString *company_url;
/**
 店铺图标
 */
@property (strong, nonatomic) NSString *company_ico;
/**
 浏览人数
 */
@property (strong, nonatomic) NSString *company_hits;
/**
 店铺地址
 */
@property (strong, nonatomic) NSString *company_address;
/**
 店铺联系人
 */
@property (strong, nonatomic) NSString *company_contact;
/**
 店铺联系电话
 */
@property (strong, nonatomic) NSString *company_tel;
/**
 店铺介绍
 */
@property (strong, nonatomic) NSString *company_about;
/**
 店铺视频
 */
@property (strong, nonatomic) NSString *company_video;
/**
 店铺主营产品（数组）
 */
@property (strong, nonatomic) NSArray *company_pro;
/**
 店铺展示图片（数组）
 */
@property (strong, nonatomic) NSArray *company_imgs_new;
/**
 店铺所有评论（数组）
 */
@property (strong, nonatomic) NSArray *company_comment;





- (void)setCompanyModelByDic:(NSDictionary *)dic;

@end
