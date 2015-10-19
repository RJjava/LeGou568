//
//  OrderDetailViewController.m
//  GouWu568
//
//  Created by echo13 on 15/10/14.
//  Copyright (c) 2015年 echo. All rights reserved.
//

#import "OrderDetailViewController.h"

@interface OrderDetailViewController ()
@property (strong, nonatomic) NSDictionary *orderDic;
@property (strong, nonatomic) IBOutlet UITableView *tableV;

@end

@implementation OrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setData];
    _tableV.tableFooterView = [[UIView alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setData{
    NSString *orderDetailStr = [NSString stringWithFormat:CONTENTS_URL_OrderDetail,_order_sn];
    [HttpTools getWithURL:orderDetailStr params:nil success:^(id json) {
        _orderDic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingMutableContainers error:nil];
        [_tableV reloadData];
    } failure:^(NSError *error) {
        NSLog(@"%@",error.description);
    }];
    
}
//返回按钮
- (IBAction)backBtnClick:(UIButton *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
#pragma mark -TableView代理
//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 153;
    }else if (indexPath.section == 1){
        return 76;
    }else if (indexPath.section == 2){
        return 64;
    }else if (indexPath.section == 3){
        return 47;
    }
    return 44;
}
//头高
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }else if (section == 1){
        return 44;
    }else if (section == 2){
        return 44;
    }else if (section == 3){
        return 20;
    }
    return 44;
}
//头设置
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *viewTemp = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
    viewTemp.backgroundColor = [UIColor clearColor];
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, [UIScreen mainScreen].bounds.size.width-8, 44)];
    lab.textColor = [UIColor blackColor];
    lab.backgroundColor = [UIColor clearColor];
    lab.font = [UIFont systemFontOfSize:15];
    if (section == 0) {
        lab.text = @"";
    }else if (section == 1){
        lab.text = @"商品列表";
    }else if (section == 2){
        lab.text = @"收货信息";
    }else if (section == 3){
        lab.text = @"";
    }
    [viewTemp addSubview:lab];
    
    return viewTemp;
}
//组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
//行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1) {//如果是商品列表
        NSArray *goodsArr = [_orderDic objectForKey:@"listgoods"];
        return goodsArr.count;
    }
    return 1;
    
}
//执行显示
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *IdentCell = [[NSString alloc] init];
    UITableViewCell *cell;
    if (indexPath.section == 0) {//订单信息
        IdentCell = @"PayStateCell";
        cell = [tableView dequeueReusableCellWithIdentifier:IdentCell forIndexPath:indexPath];
        UILabel *lab1 = (UILabel *)[cell viewWithTag:101];//订单号
        lab1.text = [NSString stringWithFormat:@"订单号：%@",_order_sn];
        UILabel *lab2 = (UILabel *)[cell viewWithTag:102];//订单状态
        lab2.text = [NSString stringWithFormat:@"订单状态：%@",[_orderDic objectForKey:@"order_status_text"]];;
        UILabel *lab3 = (UILabel *)[cell viewWithTag:103];//支付状态
        lab3.text = [NSString stringWithFormat:@"支付状态：%@",[_orderDic objectForKey:@"order_pay_status_text"]];
        UILabel *lab4 = (UILabel *)[cell viewWithTag:104];//商品总价
        lab4.text = [NSString stringWithFormat:@"￥%@",[_orderDic objectForKey:@"order_amount"]];
        UIButton *payNowBtn = (UIButton *)[cell viewWithTag:105];
        [payNowBtn addTarget:self action:@selector(payOrder) forControlEvents:UIControlEventTouchUpInside];
        
    }else if (indexPath.section == 1){//商品列表
        IdentCell = @"GoodsCell";
        cell = [tableView dequeueReusableCellWithIdentifier:IdentCell forIndexPath:indexPath];
        //获取当前要显示的内容
        NSArray *goodsArr = [_orderDic objectForKey:@"listgoods"];
        NSMutableDictionary *goodsDicTemp = [goodsArr objectAtIndex:indexPath.row];//获取到商品信息dic
        //设置商品图片
        UIImageView *imageV = (UIImageView *)[cell viewWithTag:101];
        NSString *imageUrl = [NSString stringWithFormat:@"%@%@",CONTENTS_URL_ROOT,[goodsDicTemp objectForKey:@"goods_imgs"]];
        [imageV sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"net_error_icon.png"]];
        //设置商品名称
        UILabel *goodsNameLab = (UILabel *)[cell viewWithTag:102];
        goodsNameLab.text = [goodsDicTemp objectForKey:@"goods_name"];
        //设置购买商品数量
        UILabel *goodsCountLab = (UILabel *)[cell viewWithTag:103];
        goodsCountLab.text = [NSString stringWithFormat:@"×%@",[goodsDicTemp objectForKey:@"goods_number"]];
        //设置本店价格
        UILabel *selfPriceLab = (UILabel *)[cell viewWithTag:104];
        selfPriceLab.text = [NSString stringWithFormat:@"￥%@",[goodsDicTemp objectForKey:@"goods_price"]];
        //设置市场价格
        UILabel *markePriceLab = (UILabel *)[cell viewWithTag:105];
        markePriceLab.text = [NSString stringWithFormat:@"￥%@",[goodsDicTemp objectForKey:@"goods_marke_price"]];
    }else if (indexPath.section == 2){//收货信息
        IdentCell = @"AddressCell";
        cell = [tableView dequeueReusableCellWithIdentifier:IdentCell forIndexPath:indexPath];
        UILabel *userNameLab = (UILabel *)[cell viewWithTag:101];//联系人姓名
        userNameLab.text = [NSString stringWithFormat:@"收货人：%@",[_orderDic objectForKey:@"order_consignee"]];
        UILabel *userTelLab = (UILabel *)[cell viewWithTag:102];//联系人电话
        userTelLab.text = [NSString stringWithFormat:@"电话：%@",[_orderDic objectForKey:@"order_tel"]];
        UILabel *userAddressLab = (UILabel *)[cell viewWithTag:103];//联系人地址
        userAddressLab.text = [NSString stringWithFormat:@"收货地址：%@",[_orderDic objectForKey:@"order_address"]];
    }else if (indexPath.section == 3){//代发货
        IdentCell = @"FaHuoStateCell";
        cell = [tableView dequeueReusableCellWithIdentifier:IdentCell forIndexPath:indexPath];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;//设置cell的选中样式
    return cell;
}
//cell点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
//在线支付btn点击事件
- (void)payOrder{
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
