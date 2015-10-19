//
//  ShopingCarViewController.m
//  GouWu568
//
//  Created by echo13 on 15/10/10.
//  Copyright (c) 2015年 echo. All rights reserved.
//

#import "ShopingCarViewController.h"
#import "AddOrderViewController.h"

@interface ShopingCarViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableV;
@property (strong, nonatomic) IBOutlet UILabel *allPriceLab;//价格lab
@property (strong, nonatomic) IBOutlet UIButton *quanXuanBtn;//全选btn
@property (strong, nonatomic) NSMutableArray *shopingCarArr;//购物车中的所有商品
@property (strong, nonatomic) NSMutableArray *selectShopingCarArr;//购物车中被选中的商品(存储yes或no)
@property (assign, nonatomic) CGFloat selectAllFloat;//控制选中所有btn


@end

@implementation ShopingCarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _shopingCarArr = [[NSMutableArray alloc] init];
    _selectShopingCarArr = [NSMutableArray array];
    [self setData];
    _tableV.tableFooterView = [[UIView alloc] init];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//初始化数据
- (void)setData{
    NSString *getShopingCar = [NSString stringWithFormat:CONTENTS_URL_MyShopingCar,[[Tools getUser] objectForKey:@"user_id"]];
    [HttpTools getWithURL:getShopingCar params:nil success:^(id json) {
        _shopingCarArr = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingMutableContainers error:nil];
        for (int i = 0; i < _shopingCarArr.count; i ++) {
            [_selectShopingCarArr addObject:@"1"];
        }
        _selectAllFloat = _shopingCarArr.count;
        [self reSetAllPriceLab];
        [_tableV reloadData];
    } failure:^(NSError *error) {
        NSLog(@"%@",error.description);
    }];
}
//重新设置allPriceLab
- (void)reSetAllPriceLab{
    CGFloat allPrice = 0;
    for (int i = 0; i < _selectShopingCarArr.count; i ++) {
        if ([[_selectShopingCarArr objectAtIndex:i] isEqualToString:@"1"]) {
            NSDictionary *dic = [_shopingCarArr objectAtIndex:i];
            allPrice += [[dic objectForKey:@"goods_price"] floatValue] * [[dic objectForKey:@"goods_number"] floatValue];
        }
    }
    _allPriceLab.text = [NSString stringWithFormat:@"￥%.2f",allPrice];
}
//重新设置全部选中btn
- (void)reSetQuanSuanBtn{
    NSString *imageName = _selectAllFloat == _shopingCarArr.count?@"business_contacts_state_selected.png":@"business_contacts_state_unselect.png";
    //不可以用setBackgroundImage
  //  [_quanXuanBtn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [_quanXuanBtn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}
#pragma mark - TableView代理
//行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _shopingCarArr.count;
}
//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
//执行显示
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *IdentCell = @"ShopingCarCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IdentCell forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;//设置选中样式无
    NSDictionary *dicTemp = [_shopingCarArr objectAtIndex:indexPath.row];//当前行要显示的商品
    //设置选中单个商品btn
    UIButton *selectBtn = (UIButton *)[cell viewWithTag:101];
    [selectBtn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    NSString *imageName = [[_selectShopingCarArr objectAtIndex:indexPath.row] isEqualToString:@"1"]?@"business_contacts_state_selected.png":@"business_contacts_state_unselect.png";
    [selectBtn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];//设置背景图
    //设置商品图片
    UIImageView *imageV = (UIImageView *)[cell viewWithTag:102];
    NSString *imageStr = [NSString stringWithFormat:@"%@%@",CONTENTS_URL_ROOT,[dicTemp objectForKey:@"goods_imgs"]];
    [imageV sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:[UIImage imageNamed:@"net_error_icon.png"]];
    //设置商品名
    UILabel *nameLab = (UILabel *)[cell viewWithTag:103];
    nameLab.text = [dicTemp objectForKey:@"goods_name"];
    //设置本店价格
    UILabel *myPrice = (UILabel *)[cell viewWithTag:104];
    myPrice.text = [NSString stringWithFormat:@"商品价格：%@",[dicTemp objectForKey:@"goods_price"]];
    //设置市场价
    UILabel *markePrice = (UILabel *)[cell viewWithTag:105];
    markePrice.text = [NSString stringWithFormat:@"市场价格：%@",[dicTemp objectForKey:@"goods_marke_price"]];
    //设置购买数量
    UILabel *countLab = (UILabel *)[cell viewWithTag:106];
    countLab.text = [NSString stringWithFormat:@"购买数量：%@",[dicTemp objectForKey:@"goods_number"]];
    //设置编辑btn
    UIButton *editGoodsBtn = (UIButton *)[cell viewWithTag:107];
    [editGoodsBtn addTarget:self action:@selector(editGoodsBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [editGoodsBtn setTag:indexPath.row];
    //设置删除btn
    UIButton *deleteGoodsBtn = (UIButton *)[cell viewWithTag:108];
    [deleteGoodsBtn addTarget:self action:@selector(deleteGoodsBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [deleteGoodsBtn setTag:indexPath.row];
    
    return cell;
}
//选中单个商品btn点击事件
- (void)selectBtnClick:(UIButton *)btn{
    NSInteger btnRow = [_tableV indexPathForCell:(UITableViewCell *)btn.superview.superview].row;
    //设置_selectShopingCarArr数组
    [_selectShopingCarArr setObject:[[_selectShopingCarArr objectAtIndex:btnRow] isEqualToString:@"1"]?@"0":@"1" atIndexedSubscript:btnRow];
    [[_selectShopingCarArr objectAtIndex:btnRow] isEqualToString:@"1"]?_selectAllFloat++:_selectAllFloat--;
    //设置背景图
    NSString *imageName = [[_selectShopingCarArr objectAtIndex:btnRow] isEqualToString:@"1"]?@"business_contacts_state_selected.png":@"business_contacts_state_unselect.png";
    [btn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    //设置总价格Lab
    [self reSetAllPriceLab];
    //设置全选btn
    [self reSetQuanSuanBtn];
}
//编辑单个商品btn点击事件
- (void)editGoodsBtnClick:(UIButton *)btn{
    
}
//删除单个商品btn点击事件
- (void)deleteGoodsBtnClick:(UIButton *)btn{
    NSInteger btnRow = [_tableV indexPathForCell:(UITableViewCell *)btn.superview.superview].row;
    NSDictionary *goodDic = [_shopingCarArr objectAtIndex:btnRow];
    NSString *deleteOneGood = [NSString stringWithFormat:CONTENTS_URL_DeleteOneGoodInCar,[goodDic objectForKey:@"goods_id"],[[Tools getUser] objectForKey:@"user_id"]];
    [HttpTools getWithURL:deleteOneGood params:nil success:^(id json) {
        NSString *resultStr = [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
        NSString *showStr = [resultStr isEqualToString:@"\"success\""]?@"删除成功":@"删除失败";
        //输出请求状态
        UIAlertView *alerV = [[UIAlertView alloc] initWithTitle:@"提示信息" message:showStr delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alerV show];
        [_shopingCarArr removeObjectAtIndex:btnRow];
        [[_selectShopingCarArr objectAtIndex:btnRow] isEqualToString:@"1"]?_selectAllFloat--:_selectAllFloat;
        [_selectShopingCarArr removeObjectAtIndex:btnRow];
        [_tableV reloadData];//刷新TableView
        [self reSetQuanSuanBtn];//刷新全选btn
        [self reSetAllPriceLab];//刷新总价lab
        //        [self setData];//只调用setData方法也可以实现刷新tableView功能
    } failure:^(NSError *error) {
        NSLog(@"%@",error.description);
    }];
    
}
//返回按钮
- (IBAction)backBtnClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
//结算btn点击事件
- (IBAction)jieSuanBtnClick:(UIButton *)sender {
    if (_selectAllFloat != 0) {//当选中的商品列表不为空则跳转
        [self performSegueWithIdentifier:@"JieSuanSegue" sender:self];
    }else{//当选中商品列表为空
        UIAlertView *alerV = [[UIAlertView alloc] initWithTitle:@"提示信息" message:@"您还没有选择商品哦" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alerV show];
    }
    
}
//清空btn点击事件
- (IBAction)qingKongBtnClick:(UIButton *)sender {
    NSString *deleteAllGoods = [NSString stringWithFormat:CONTENTS_URL_DeleteAllGoodsInCar,[[Tools getUser] objectForKey:@"user_id"]];
    [HttpTools getWithURL:deleteAllGoods params:nil success:^(id json) {
        NSString *resultStr = [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
        NSString *showStr = [resultStr isEqualToString:@"\"success\""]?@"清空成功":@"清空失败";
        //输出请求状态
        UIAlertView *alerV = [[UIAlertView alloc] initWithTitle:@"提示信息" message:showStr delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alerV show];
        [_shopingCarArr removeAllObjects];
        [_selectShopingCarArr removeAllObjects];
        [_tableV reloadData];//刷新TableView
        _allPriceLab.text = @"￥0.00";//刷新总价lab
        [self reSetQuanSuanBtn];//刷新全选btn
        //        [self setData];//只调用setData方法也可以实现刷新tableView功能
    } failure:^(NSError *error) {
        NSLog(@"%@",error.description);
    }];
}
//全选btn点击事件
- (IBAction)quanXuanBtnClick:(UIButton *)sender {
    if (_selectAllFloat == _shopingCarArr.count) {//如果当前是全选状态,则改为全不选
        for (int i = 0; i < _shopingCarArr.count; i ++) {
            [_selectShopingCarArr setObject:@"0" atIndexedSubscript:i];
        }
        _selectAllFloat = 0;
        [_tableV reloadData];
        [_quanXuanBtn setImage:[UIImage imageNamed:@"business_contacts_state_unselect.png"] forState:UIControlStateNormal];
    }else{//当前不是全选状态,则改为全选
        for (int i = 0; i < _shopingCarArr.count; i ++) {
            [_selectShopingCarArr setObject:@"1" atIndexedSubscript:i];
        }
        _selectAllFloat = _shopingCarArr.count;
        [_tableV reloadData];
        [_quanXuanBtn setImage:[UIImage imageNamed:@"business_contacts_state_selected.png"] forState:UIControlStateNormal];
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[AddOrderViewController class]]) {
        AddOrderViewController *addOrderVC = segue.destinationViewController;
        addOrderVC.goodsArr = [[NSMutableArray alloc] init];//初始化选中的商品数组
        addOrderVC.goodsCountArr = [[NSMutableArray alloc] init];//初始化选中的商品数量数组
        for (int i = 0; i < _selectShopingCarArr.count; i++) {
            NSString *strTemp = [_selectShopingCarArr objectAtIndex:i];
            if ([strTemp isEqualToString:@"1"]) {//如果该商品被选中
                //添加商品
                [addOrderVC.goodsArr addObject:[_shopingCarArr objectAtIndex:i]];
                //添加数量
                NSString *countStr = [[_shopingCarArr objectAtIndex:i] objectForKey:@"goods_number"];
                [addOrderVC.goodsCountArr addObject:countStr];
            }
        }
        //设置是从购物车跳转的
        addOrderVC.isFromShopingCar = YES;
    }
}


@end
