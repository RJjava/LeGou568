//
//  Define.h
//  Connotation
//
//  Created by LZXuan on 15-5-25.
//  Copyright (c) 2015年 轩哥. All rights reserved.
//

//当前 头文件一般 存放一些 导入常用头文件 宏定义
//在把Define.h放在 预编译文件


#ifndef Connotation_Define_h
#define Connotation_Define_h



//开发过程中 调试代码用
//上线的时候 可以

//#define __UpLine__ // 上线的时候打开

#ifndef __UpLine__
//如果没有定义上面的宏 NSLog(...) 表示一个变参宏 用后面的代码替换NSLog(__VA_ARGS__) 接收前面的变参

// NSLog(__VA_ARGS__)就是以前的NSLog 函数

#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define NSLog(...)
#endif


#define CONTENTS_URL_ROOT @"http://www.lg568.com"
#define CONTENTS_URL_MIDLE @"/index.php/Home/API"
//获取店铺分类及店铺（添加了广告字段）
#define CONTENTS_URL_CompanyType @"/CompanyType/city_id/2/"
//获取推荐店铺信息
#define CONTENTS_URL_CompanyRecommend @"/recommendCompany/city_id/2"
//获取当前城市指定一级店铺分类下的二级分类以及店铺
#define CONTENTS_URL_SecCompany @"http://www.lg568.com/index.php/Home/API/listCompany/city_id/2/company_type_id/%@/page_num/1/page_size/10"
//通过id查询company
#define CONTENTS_URL_SelectCompanyById @"http://www.lg568.com/index.php/Home/API/content_company/company_id/%@"
//会员登录
#define CONTENTS_URL_LogIn @"http://www.lg568.com/index.php/Home/APIuser/loginUser/user_phone/%@/user_password/%@"
//添加评论
#define CONTENTS_URL_AddComment @"http://www.lg568.com/index.php/Home/API/add_comment"
//添加举报
#define CONTENTS_URL_AddReport @"http://www.lg568.com/index.php/Home/API/add_report"
//获取所有商品分类及商品
#define CONTENTS_URL_AllGoods @"http://www.lg568.com/index.php/Home/APIgoods/goodsType/city_id/2"
//通过id获取指定商品的详细内容
#define CONTENTS_URL_GetGoodsDetail @"http://www.lg568.com/index.php/Home/APIgoods/contentGoods/goods_id/%@"
//添加收藏
#define CONTENTS_URL_AddShouCang @"http://www.lg568.com/index.php/Home/APIuser/add_collect/goods_id/%@/user_id/%@"
//用于商品加入购物车，需要登陆才能使用
#define CONTENTS_URL_AddGoodsIntoCar @"http://www.lg568.com/index.php/Home/APIgoods/addcart/goods_id/%@/goods_number/%@/user_id/%@"
//"发现"界面数据请求（房产和招聘）
#define CONTENTS_URL_FaXian @"http://www.lg568.com/index.php/Home/APIinfo/typeInfo/city_id/%@"
//“发现”界面详情页信息
#define CONTENTS_URL_FaXianDetail @"http://www.lg568.com/index.php/Home/APIinfo/contentInfo/info_id/%@"
//发现界面一级分类info_type_pid下二级分类info_type_id的所有内容
#define CONTENTS_URL_FaXianType @"http://www.lg568.com//index.php/Home/APIinfo/typelistInfo/info_type_pid/%@/info_type_id/%@/city_id/2/page_num/1/page_size/10"
//消息通知
#define CONTENTS_URL_TongZhi @"http://www.lg568.com/index.php/Home/APIuser/list_notice"
//修改密码
#define CONTENTS_URL_ChangePassWord @"http://www.lg568.com/index.php/Home/APIuser/updatepass/user_id/%@/oldpass/%@/newpass/%@/newpass2/%@/"
//修改基本信息
#define CONTENTS_URL_ChangeMessage @"http://www.lg568.com/index.php/Home/APIuser/updateinfo/user_id/%@/user_name/%@/user_qq/%@/user_mail/%@/user_phone/%@/user_address/%@/user_phone2/%@/user_address2/%@/user_sex/%@/user_birthday/%@"
//查看购物车
#define CONTENTS_URL_MyShopingCar @"http://www.lg568.com/index.php/Home/APIgoods/listcart/user_id/%@"
//删除购物车中的单个商品
#define CONTENTS_URL_DeleteOneGoodInCar @"http://www.lg568.com/index.php/Home/APIgoods/deletecartgoods/goods_id/%@/user_id/%@"
//清空购物车
#define CONTENTS_URL_DeleteAllGoodsInCar @"http://www.lg568.com/index.php/Home/APIgoods/deletecart/user_id/%@"
//用于获取下订单配置
#define CONTENTS_URL_GetAddOrderConfigure @"http://www.lg568.com/index.php/Home/APIgoods/confOrder/user_id/%@"
//从购物车提交订单
#define CONTENTS_URL_AddOrderFromCar @"http://www.lg568.com/index.php/Home/APIgoods/addorder"
//直接购买下单
#define CONTENTS_URL_AddOrderNow @"http://www.lg568.com/index.php/Home/APIgoods/buyorder/goods_id/%@/goods_number/%@/user_id/%@/order_consignee/%@/order_tel/%@/order_address/%@/order_pay_id/%@/order_remarks/%@/order_delivery/%@"
//我的订单列表
#define CONTENTS_URL_OrderList @"http://www.lg568.com/index.php/Home/APIuser/listorder/user_id/%@/"
//获取订单详情
#define CONTENTS_URL_OrderDetail @"http://www.lg568.com/index.php/Home/APIuser/infoorder/order_sn/%@"
//取消顶大
#define CONTENTS_URL_DeleteOrder @"http://www.lg568.com/index.php/Home/APIuser/cancelorder/order_sn/%@/"
//收藏列表
#define CONTENTS_URL_CollectionShopsList @"http://www.lg568.com/index.php/Home/APIuser/list_collect/user_id/%@/"
//取消收藏
#define CONTENTS_URL_DeleteOneCollection @"http://www.lg568.com/index.php/Home/APIuser/cancle_collect/collect_id/%@"


//友盟561b2d4367e58e216d002ebf
#define CONTENTS_URL_YouMengAppKey @"561b2d4367e58e216d002ebf"






//获取 屏幕的大小
#define kScreenSize [UIScreen mainScreen].bounds.size
#define kScreenSizeWith [UIScreen mainScreen].bounds.size.width
#define kScreenSizeHeight [UIScreen mainScreen].bounds.size.height



#import "LZXHelper.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
//#import "BaseViewController.h"
//#import "ConnotationModel.h"
#import "HttpTools.h"

// category对应的字符串为:
#define JOKES @"weibo_jokes"  // 段子
#define PICS @"weibo_pics"    // 趣图
#define VIDEOS @"weibo_videos"// 视频
#define GIRLS @"weibo_girls"  // 美女

// 段子 趣图 视频 美女 接口
#define CONTENTS_URL @"http://223.6.252.214/weibofun/weibo_list.php?apiver=10500&category=%@&page=%ld&page_size=%ld&max_timestamp=%@"
// 页面从第0页开始30条开始，然后是第1页15条，第2页15条...
// max_timestamp 第0页，或者下拉刷新，值为-1，否则，为最后一个条目的update_time字段的值!(特别注意)
//-1 用于下拉刷新  page == 0 下拉刷新 最多刷新30条
//上拉加载 的时候max_timestamp应该是 数据源中最后一条数据的时间
//默认加载15条

// 评论接口
// fid为对应的wid，category同上
#define COMMENTS_URL @"http://223.6.252.214/weibofun/comments_list.php?apiver=10600&fid=%@&&category=%@&page=0&page_size=15&max_timestamp=-1"

// 点赞接口，post请求
// fid为对应的wid，category同上
#define kZanUrl @"http://223.6.252.214/weibofun/add_count.php?apiver=10500&vip=1&platform=iphone&appver=1.6&udid=6762BA9C-789C-417A-8DEA-B8D731EFDC0B"
//请求体拼接参数是下面的形式参数
// type=like&category=weibo_girls&fid=30310


#endif
