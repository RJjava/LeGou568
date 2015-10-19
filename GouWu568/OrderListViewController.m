//
//  OrderListViewController.m
//  GouWu568
//
//  Created by echo13 on 15/10/14.
//  Copyright (c) 2015年 echo. All rights reserved.
//

#import "OrderListViewController.h"
#import "OrderDetailViewController.h"

@interface OrderListViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableV;
@property (strong, nonatomic) NSMutableArray *orderListArr;
@property (strong, nonatomic) NSString *orderSnoStr;//传输到跳转的订单详情页

@end

@implementation OrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _orderListArr = [NSMutableArray array];
    // Do any additional setup after loading the view.
    _tableV.tableFooterView = [[UIView alloc] init];
    
    [self setData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//初始化数据
- (void)setData{
    NSString *orderListStr = [NSString stringWithFormat:CONTENTS_URL_OrderList,[[Tools getUser] objectForKey:@"user_id"]];
    [HttpTools getWithURL:orderListStr params:nil success:^(id json) {
        _orderListArr = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingMutableContainers error:nil];
        [_tableV reloadData];
    } failure:^(NSError *error) {
        NSLog(@"%@",error.description);
    }];
    
}
//返回按钮
- (IBAction)backBtnClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - TableView代理
//行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _orderListArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *IdentCell = @"OrderListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IdentCell forIndexPath:indexPath];
    if (_orderListArr.count != 0) {
        NSDictionary *dicTemp = [_orderListArr objectAtIndex:indexPath.row];
        UILabel *lab1 = (UILabel *)[cell viewWithTag:101];//订单号
        lab1.text = [NSString stringWithFormat:@"订单号：%@",[dicTemp objectForKey:@"order_sn"]];
        UILabel *lab2 = (UILabel *)[cell viewWithTag:102];//订单金额
        lab2.text = [NSString stringWithFormat:@"￥%@",[dicTemp objectForKey:@"order_amount"]];
        UILabel *lab3 = (UILabel *)[cell viewWithTag:103];//下单时间
        lab3.text = [NSString stringWithFormat:@"下单时间：%@",[dicTemp objectForKey:@"order_edittime"]];
//        UIButton *btn1 = (UIButton *)[cell viewWithTag:104];//订单状态button
        UIButton *btn2 = (UIButton *)[cell viewWithTag:105];//取消订单button
        [btn2 addTarget:self action:@selector(deleteOrderBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;//设置选中样式无
    return cell;
}
//取消订单button点击事件
- (void)deleteOrderBtnClick:(UIButton *)btn{
    UITableViewCell *cellTemp = (UITableViewCell *)btn.superview.superview.superview;
    NSIndexPath *indexP = [_tableV indexPathForCell:cellTemp];
    NSString *deleteOrderStr = [NSString stringWithFormat:CONTENTS_URL_DeleteOrder,[[_orderListArr objectAtIndex:indexP.row] objectForKey:@"order_sn"]];
    [HttpTools getWithURL:deleteOrderStr params:nil success:^(id json) {
        NSString *strTemp = [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
        if ([strTemp isEqualToString:@"\"success\""]) {//如果删除订单成功
            UIAlertView *alerV = [[UIAlertView alloc] initWithTitle:@"提示信息" message:@"成功取消订单" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alerV show];
            [_orderListArr removeObjectAtIndex:indexP.row];//从该数组中删除
            [_tableV reloadData];
        }else if([strTemp isEqualToString:@"\"false\""]) {//如果删除订单失败
            UIAlertView *alerV = [[UIAlertView alloc] initWithTitle:@"提示信息" message:@"取消订单失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alerV show];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error.description);
    }];
}
//cell点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _orderSnoStr = [[_orderListArr objectAtIndex:indexPath.row] objectForKey:@"order_sn"];
    [self performSegueWithIdentifier:@"OrderDetailSegue" sender:self];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[OrderDetailViewController class]]) {//跳转的是订单详情页
        OrderDetailViewController *orderDetailVC = segue.destinationViewController;
        orderDetailVC.order_sn = _orderSnoStr;
    }
}


@end
