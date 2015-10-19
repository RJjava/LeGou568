//
//  WoDeViewController.m
//  GouWu568
//
//  Created by echo13 on 15/9/25.
//  Copyright © 2015年 echo. All rights reserved.
//

#import "WoDeViewController.h"
#import "LoginViewController.h"
#import "TongZhiViewController.h"
#import "UpDateUserViewController.h"
#import "ShopingCarViewController.h"
#import "OrderListViewController.h"
#import "CollectionShopsViewController.h"

@interface WoDeViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) NSArray *picArr;
@property (strong, nonatomic) NSArray *titleArr;
@property (strong, nonatomic) IBOutlet UITableView *tableV;
@property (strong, nonatomic) NSArray *tongZhiArr;

@end

@implementation WoDeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _picArr = [[NSArray alloc] initWithObjects:@"grzx_icon1.png",@"grzx_icon5.png",@"grzx_icon6.png",@"grzx_icon3.png",@"grzx_icon2.png",@"grzx_icon4.png",@"grzx_icon8.png", nil];
    _titleArr = [[NSArray alloc] initWithObjects:@"订单管理",@"我的账单",@"我的购物车",@"我的店铺",@"我的收藏",@"浏览信息",@"版本升级", nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated{
    [_tableV reloadData];
}
#pragma mark -TableView代理
//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 165;
    }else if (indexPath.section == 3){
        return 72;
    }
    return 44;
}
//头高
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section == 1 || section == 2?44:0;
    
}
//头设置
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *viewTemp = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
    viewTemp.backgroundColor = [UIColor clearColor];
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, [UIScreen mainScreen].bounds.size.width-8, 44)];
    lab.textColor = [UIColor blackColor];
    lab.backgroundColor = [UIColor clearColor];
    lab.font = [UIFont systemFontOfSize:15];
    lab.text = section == 1?@"订单管理":@"其他";
    [viewTemp addSubview:lab];
    
    return viewTemp;
}
//组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
//行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else if(section == 1){
        return 3;
    }else if(section == 2){
        return 4;
    }
    return 1;
        
}
//执行显示
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *IdentCell = [[NSString alloc] init];
    UITableViewCell *cell;
    if (indexPath.section == 0) {
        IdentCell = [Tools isLogin]?@"CellHead2":@"CellHead1";
        cell = [tableView dequeueReusableCellWithIdentifier:IdentCell forIndexPath:indexPath];
        if ([Tools isLogin]) {
            NSDictionary *userDic = [Tools getUser];
            UILabel *nameLab = (UILabel *)[cell viewWithTag:101];//用户名
            nameLab.text = [userDic objectForKey:@"user_name"];
            UILabel *jiFenLab = (UILabel *)[cell viewWithTag:102];//积分
            jiFenLab.text = [userDic objectForKey:@"user_integral"];
            UILabel *vipLab = (UILabel *)[cell viewWithTag:103];//vip等级
            vipLab.text = [userDic objectForKey:@"vip"];
            UILabel *shengJiLab = (UILabel *)[cell viewWithTag:104];//升级所需要的积分
            shengJiLab.text = [userDic objectForKey:@"next_integral"];
            UIButton *updataUserBtn = (UIButton *)[cell viewWithTag:105];//个人资料btn
            [updataUserBtn addTarget:self action:@selector(geRenSheZhiBtnClick) forControlEvents:UIControlEventTouchUpInside];
            UIButton *dengJiBtn = (UIButton *)[cell viewWithTag:106];//等级说明btn
            [dengJiBtn addTarget:self action:@selector(dengJiShuoMingBtnClick) forControlEvents:UIControlEventTouchUpInside];
            
        }else{
            UIButton *loginBtn = (UIButton *)[cell viewWithTag:101];
            [loginBtn addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventTouchUpInside];
        }
    }else if (indexPath.section == 1){
        IdentCell = @"CellContent";
        cell = [tableView dequeueReusableCellWithIdentifier:IdentCell forIndexPath:indexPath];
        //设置图片
        UIImageView *imageV = (UIImageView *)[cell viewWithTag:101];
        imageV.image = [UIImage imageNamed:[_picArr objectAtIndex:indexPath.row]];
        //设置lab
        UILabel *lab = (UILabel *)[cell viewWithTag:102];
        lab.text = [_titleArr objectAtIndex:indexPath.row];
        
    }else if (indexPath.section == 2){
        IdentCell = @"CellContent";
        cell = [tableView dequeueReusableCellWithIdentifier:IdentCell forIndexPath:indexPath];
        //设置图片
        UIImageView *imageV = (UIImageView *)[cell viewWithTag:101];
        imageV.image = [UIImage imageNamed:[_picArr objectAtIndex:indexPath.row+3]];
        //设置lab
        UILabel *lab = (UILabel *)[cell viewWithTag:102];
        lab.text = [_titleArr objectAtIndex:indexPath.row+3];
    }else if (indexPath.section == 3){
        IdentCell = @"TelephoneCell";
        cell = [tableView dequeueReusableCellWithIdentifier:IdentCell forIndexPath:indexPath];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;//设置选中样式无
    return cell;
}
//cell点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {//订单管理
            [self performSegueWithIdentifier:@"OrderListSegue" sender:self];
        }else if (indexPath.row == 1){//我的账单
            
        }else if (indexPath.row == 2){//我的购物车
            [self performSegueWithIdentifier:@"ShopingCarSegue" sender:self];
        }
    }else if(indexPath.section == 2){
        if (indexPath.row == 0) {//我的店铺
            
        }else if (indexPath.row == 1){//我的收藏
            [self performSegueWithIdentifier:@"CollectionShopsSegue" sender:self];
        }else if (indexPath.row == 2){//浏览信息
            
        }else if (indexPath.row == 2){//版本升级
            
        }
    }
}
//登录button点击事件
- (void)loginBtnClick{
    [self performSegueWithIdentifier:@"LoginSegue" sender:self];
}
//通知btn点击事件
- (IBAction)tongZhiBtnClick:(UIButton *)sender {
    //获取消息通知
    [HttpTools getWithURL:CONTENTS_URL_TongZhi params:nil success:^(id json) {
        _tongZhiArr = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingMutableContainers error:nil];
        [self performSegueWithIdentifier:@"TongZhiSegue" sender:self];
    } failure:^(NSError *error) {
        NSLog(@"%@",error.description);
    }];
}
//个人资料Btn点击事件
- (void)geRenSheZhiBtnClick{
    [self performSegueWithIdentifier:@"GeRenShtZhiSegue" sender:self];
}
//等级说明btn点击事件
- (void)dengJiShuoMingBtnClick{
    
}
#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[LoginViewController class]]) {//跳转到登录界面
        
    }
    if ([segue.destinationViewController isKindOfClass:[TongZhiViewController class]]) {//跳转到消息通知界面
        TongZhiViewController *tongZhiVC = segue.destinationViewController;
        tongZhiVC.tongZhiArr = _tongZhiArr;
    }
    if ([segue.destinationViewController isKindOfClass:[UpDateUserViewController class]]) {//跳转到修改用户基本信息界面
        
    }
    if ([segue.destinationViewController isKindOfClass:[ShopingCarViewController class]]) {//跳转到购物车界面
        
    }
    if ([segue.destinationViewController isKindOfClass:[OrderListViewController class]]) {//跳转到订单管理界面
        
    }
    if ([segue.destinationViewController isKindOfClass:[CollectionShopsViewController class]]) {//跳转到收藏界面
        
    }
}


@end
