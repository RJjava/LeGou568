//
//  CollectionShopsViewController.m
//  GouWu568
//
//  Created by echo13 on 15/10/14.
//  Copyright (c) 2015年 echo. All rights reserved.
//

#import "CollectionShopsViewController.h"

@interface CollectionShopsViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableV;
@property (strong, nonatomic) NSMutableArray *collectionListArr;

@end

@implementation CollectionShopsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _collectionListArr = [[NSMutableArray alloc] init];
    [self setData];
    _tableV.tableFooterView = [[UITableView alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//初始化数据
- (void)setData{
    NSString *orderListStr = [NSString stringWithFormat:CONTENTS_URL_CollectionShopsList,[[Tools getUser] objectForKey:@"user_id"]];
    [HttpTools getWithURL:orderListStr params:nil success:^(id json) {
        _collectionListArr = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingMutableContainers error:nil];
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
    return _collectionListArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *IdentCell = @"CollectionShopsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IdentCell forIndexPath:indexPath];
    if (_collectionListArr.count != 0) {
        NSDictionary *dicTemp = [_collectionListArr objectAtIndex:indexPath.row];
        UIImageView *imageV = (UIImageView *)[cell viewWithTag:101];//显示图片
        NSString *imageStr = [NSString stringWithFormat:@"%@%@",CONTENTS_URL_ROOT,[dicTemp objectForKey:@"goods_imgs"]];
        [imageV sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:[UIImage imageNamed:@"net_error_icon.png"]];
        UILabel *lab1 = (UILabel *)[cell viewWithTag:102];//商品名称
        lab1.text = [NSString stringWithFormat:@"￥%@",[dicTemp objectForKey:@"goods_name"]];
        UILabel *lab2 = (UILabel *)[cell viewWithTag:103];//商品金额
        lab2.text = [NSString stringWithFormat:@"￥%@",[dicTemp objectForKey:@"goods_price"]];
        UILabel *lab3 = (UILabel *)[cell viewWithTag:104];//添加收藏的时间
        lab3.text = [dicTemp objectForKey:@"collect_addtime"];
        UIButton *btn2 = (UIButton *)[cell viewWithTag:105];//取消收藏button
        [btn2 addTarget:self action:@selector(deleteOrderBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;//设置选中样式无
    return cell;
}
//取消订单button点击事件
- (void)deleteOrderBtnClick:(UIButton *)btn{
    UITableViewCell *cellTemp = (UITableViewCell *)btn.superview.superview.superview;
    NSIndexPath *indexP = [_tableV indexPathForCell:cellTemp];
    NSString *deleteOrderStr = [NSString stringWithFormat:CONTENTS_URL_DeleteOneCollection,[[_collectionListArr objectAtIndex:indexP.row] objectForKey:@"collect_id"]];
    [HttpTools getWithURL:deleteOrderStr params:nil success:^(id json) {
        NSDictionary *dicTemp = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingMutableContainers error:nil];
        //提示请求消息
        UIAlertView *alerV = [[UIAlertView alloc] initWithTitle:@"提示信息" message:[dicTemp objectForKey:@"content"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alerV show];
        if ([[dicTemp objectForKey:@"status"] isEqualToString:@"1"]) {//如果取消收藏成功
            [_collectionListArr removeObjectAtIndex:indexP.row];//从该数组中删除
            [_tableV reloadData];
        }else if([[dicTemp objectForKey:@"status"] isEqualToString:@"0"]) {//如果取消收藏失败
            
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error.description);
    }];
}
////cell点击事件
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
