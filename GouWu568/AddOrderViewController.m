//
//  AddOrderViewController.m
//  GouWu568
//
//  Created by echo13 on 15/10/8.
//  Copyright (c) 2015年 echo. All rights reserved.
//

#import "AddOrderViewController.h"
#import "ChangeCustomViewController.h"
#import "OrderDetailViewController.h"

@interface AddOrderViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableV;
@property (strong, nonatomic) IBOutlet UILabel *allPriceLab;
@property (assign, nonatomic) CGFloat allGoodsPriceFloat;//商品的总价格
@property (strong, nonatomic) NSDictionary *customerDic;//收货人信息
@property (strong, nonatomic) NSArray *payFormArr;//支付方式数组
@property (strong, nonatomic) NSArray *sendFormArr;//配送方式数组
@property (strong, nonatomic) NSString *orderSno;//提交订单后获得的订单编号

@end

@implementation AddOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    NSLog(@"%@",_goodsArr);
//    NSLog(@"%@",_goodsCountArr);
    // Do any additional setup after loading the view.
    //注册消息通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeCustomConfiger:) name:@"changeCustomConfiger" object:nil];
    _tableV.tableFooterView = [[UIView alloc] init];
    _allGoodsPriceFloat = 0;
    _orderSno = @"";
    [self setData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setData{
    //计算商品总价格
    for (int i = 0; i < _goodsArr.count; i++) {
        NSDictionary *dic = [_goodsArr objectAtIndex:i];
        //单价
        CGFloat goodsPrice = [[dic objectForKey:@"goods_price"] floatValue];
        //数量
        CGFloat goodsCount = [[_goodsCountArr objectAtIndex:i] floatValue];
        _allGoodsPriceFloat += goodsPrice*goodsCount;
    }
    //获取添加订单配置信息
    NSString *orderConfigureStr = [NSString stringWithFormat:CONTENTS_URL_GetAddOrderConfigure,[[Tools getUser] objectForKey:@"user_id"]];
    [HttpTools getWithURL:orderConfigureStr params:nil success:^(id json) {
        NSDictionary *dicTemp = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingMutableContainers error:nil];
        //设置收货人信息
        _customerDic = [dicTemp objectForKey:@"Consignee"];
        [_customerDic setValue:@"" forKey:@"user_remarks"];//添加备注键值
        [_customerDic setValue:@"0" forKey:@"order_pay_id"];//添加支付方式键值（默认为0）
        [_customerDic setValue:@"0" forKey:@"order_delivery"];//添加配送方式键值（默认为0）
        //设置支付方式
        _payFormArr = [dicTemp objectForKey:@"order_pay_id"];
        //设置配送方式
        _sendFormArr = [dicTemp objectForKey:@"order_delivery"];
        [_tableV reloadData];
        [self resetHeJiPrice];//重新设置合计价格
    } failure:^(NSError *error) {
        NSLog(@"%@",error.description);
    }];
}
//重新设置合计价格
- (void)resetHeJiPrice{
    CGFloat sendPrice = [[[_sendFormArr objectAtIndex:[[_customerDic objectForKey:@"order_delivery"] intValue]] objectForKey:@"money"] intValue];//计算邮费
    _allPriceLab.text = [NSString stringWithFormat:@"合计：%.2f",_allGoodsPriceFloat + sendPrice];
}

//消息通知被触发执行的方法
- (void)changeCustomConfiger:(NSNotification *)noti{
    NSDictionary *dicTemp = noti.object;
    [_customerDic setValue:[dicTemp objectForKey:@"user_name"] forKey:@"user_name"];
    [_customerDic setValue:[dicTemp objectForKey:@"user_phone"] forKey:@"user_phone"];
    [_customerDic setValue:[dicTemp objectForKey:@"user_address"] forKey:@"user_address"];
    [_customerDic setValue:[dicTemp objectForKey:@"user_remarks"] forKey:@"user_remarks"];
    //tableView刷新指定行
    NSIndexPath *indexPathTemp = [NSIndexPath indexPathForRow:0 inSection:1];
    [_tableV reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPathTemp, nil] withRowAnimation:UITableViewRowAnimationNone];
}
#pragma mark - TableView代理
//头显示
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    return section == 0 ? @"订单详情":@"收货地址" ;
//}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *viewTemp = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
    viewTemp.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, [UIScreen mainScreen].bounds.size.width-25, 44)];
    lab.textColor = [UIColor blackColor];
    lab.backgroundColor = [UIColor clearColor];
    lab.text = section == 0 ? @"订单详情":@"收货地址";
    [viewTemp addSubview:lab];
    return viewTemp;
}
//cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row < _goodsArr.count) {
            return 76;
        }else{
            return 44;
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            return 64;
        }else if(indexPath.row == 2){
            return 44;
        }else if(indexPath.row == 3){
            return 44;
        }
    }
    return 44;
}
//头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
    
}
//组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
//行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return _goodsArr.count+1;
    }
    return 3;
}
//执行显示
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *IdentCell = [[NSString alloc] init];
    UITableViewCell *cell;
    
    if (indexPath.section == 0) {//当是第一个分组
        if (indexPath.row < _goodsArr.count) {
            IdentCell = @"GoodsCell";
            cell = [tableView dequeueReusableCellWithIdentifier:IdentCell forIndexPath:indexPath];
            //获取当前要显示的内容
            NSMutableDictionary *goodsDicTemp = [_goodsArr objectAtIndex:indexPath.row];//获取到商品信息dic
            NSString *goodsCountStrTemp = [_goodsCountArr objectAtIndex:indexPath.row];
            //设置商品图片
            UIImageView *imageV = (UIImageView *)[cell viewWithTag:101];
            NSString *imageUrl = [NSString stringWithFormat:@"%@%@",CONTENTS_URL_ROOT,[goodsDicTemp objectForKey:@"goods_imgs"]];
            [imageV sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"net_error_icon.png"]];
            //设置商品名称
            UILabel *goodsNameLab = (UILabel *)[cell viewWithTag:102];
            goodsNameLab.text = [goodsDicTemp objectForKey:@"goods_name"];
            //设置购买商品数量
            UILabel *goodsCountLab = (UILabel *)[cell viewWithTag:103];
            goodsCountLab.text = [NSString stringWithFormat:@"×%@",goodsCountStrTemp];
            //设置本店价格
            UILabel *selfPriceLab = (UILabel *)[cell viewWithTag:104];
            selfPriceLab.text = [NSString stringWithFormat:@"￥%@",[goodsDicTemp objectForKey:@"goods_price"]];
            //设置市场价格
            UILabel *markePriceLab = (UILabel *)[cell viewWithTag:105];
            markePriceLab.text = [NSString stringWithFormat:@"￥%@",[goodsDicTemp objectForKey:@"goods_marke_price"]];
        }else if (indexPath.row == _goodsArr.count){//商品总价格
            IdentCell = @"AllPriceCell";
            cell = [tableView dequeueReusableCellWithIdentifier:IdentCell forIndexPath:indexPath];
            
            UILabel *lab = (UILabel *)[cell viewWithTag:101];
            lab.text = [NSString stringWithFormat:@"￥%0.2f",_allGoodsPriceFloat];
        }
    }else if(indexPath.section == 1){//当是第二个分组
        if (indexPath.row == 0){//收货人信息
            IdentCell = @"AddressCell";
            cell = [tableView dequeueReusableCellWithIdentifier:IdentCell forIndexPath:indexPath];
            UILabel *userNameLab = (UILabel *)[cell viewWithTag:101];//联系人姓名
            userNameLab.text = [NSString stringWithFormat:@"收货人：%@",[_customerDic objectForKey:@"user_name"]];
            UILabel *userTelLab = (UILabel *)[cell viewWithTag:102];//联系人电话
            userTelLab.text = [NSString stringWithFormat:@"电话：%@",[_customerDic objectForKey:@"user_phone"]];
            UILabel *userAddressLab = (UILabel *)[cell viewWithTag:103];//联系人地址
            userAddressLab.text = [NSString stringWithFormat:@"收货地址：%@",[_customerDic objectForKey:@"user_address"]];
            
        }else if (indexPath.row == 1){//支付方式
            IdentCell = @"PayFormCell";
            cell = [tableView dequeueReusableCellWithIdentifier:IdentCell forIndexPath:indexPath];
            if (_payFormArr.count != 0) {
                UILabel *lab = (UILabel *)[cell viewWithTag:101];
                NSInteger indexP = [[_customerDic objectForKey:@"order_pay_id"] intValue];
                lab.text = [[_payFormArr objectAtIndex:indexP] objectForKey:@"content"];
            }
        }else if (indexPath.row == 2){//配送方式
            IdentCell = @"SendFormCell";
            cell = [tableView dequeueReusableCellWithIdentifier:IdentCell forIndexPath:indexPath];
            if (_sendFormArr.count != 0) {
                UILabel *lab = (UILabel *)[cell viewWithTag:101];
                NSInteger indexS = [[_customerDic objectForKey:@"order_delivery"] intValue];
                lab.text = [[_sendFormArr objectAtIndex:indexS] objectForKey:@"content"];
            }
        }
    }
    
    return cell;
}
//cell点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {//第二个分组
        if (indexPath.row == 0) {//收货人信息
            [self performSegueWithIdentifier:@"ChangeCustomSegue" sender:self];
        }else if(indexPath.row == 1){//支付方式
            UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:nil message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
            alertV.tag = 101;
            [alertV addButtonWithTitle:@""];
            for (NSDictionary *dicTemp in _payFormArr) {
                [alertV addButtonWithTitle:[dicTemp objectForKey:@"content"]];
            }
            [alertV addButtonWithTitle:@""];
            [alertV show];
        }else if (indexPath.row == 2){//配送方式
            UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:nil message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
            alertV.tag = 102;
            [alertV addButtonWithTitle:@""];
            for (NSDictionary *dicTemp in _sendFormArr) {
                [alertV addButtonWithTitle:[dicTemp objectForKey:@"content"]];
            }
            [alertV addButtonWithTitle:@""];
            [alertV show];
        }
    }
}
//返回按钮
- (IBAction)backBtnClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
//提交订单
- (IBAction)addOrderBtnClick:(UIButton *)sender {
    if (_isFromShopingCar) {//从购物车跳转过来的
        NSMutableDictionary *dicPost = [[NSMutableDictionary alloc] init];//初始化post请求中传的词典
        NSMutableArray *goodsIdArr = [[NSMutableArray alloc] init];//该提交的订单中的所有商品的id数组
        for (NSDictionary *goodDicTemp in _goodsArr) {
            [goodsIdArr addObject:[goodDicTemp objectForKey:@"goods_id"]];
        }
        NSString *goodsIDStr = [goodsIdArr componentsJoinedByString:@","];//若请求参数中有词典要转成字符串
        [dicPost setObject:[[Tools getUser] objectForKey:@"user_id"] forKey:@"user_id"];
        [dicPost setObject:goodsIDStr forKey:@"goods_id"];
        [dicPost setObject:[_customerDic objectForKey:@"user_name"] forKey:@"order_consignee"];
        [dicPost setObject:[_customerDic objectForKey:@"user_phone"] forKey:@"order_tel"];
        [dicPost setObject:[_customerDic objectForKey:@"user_address"] forKey:@"order_address"];
        [dicPost setObject:[_customerDic objectForKey:@"order_pay_id"] forKey:@"order_pay_id"];
        //        NSLog(@"11111%@",[_customerDic objectForKey:@"user_remarks"]);
        [dicPost setObject:[_customerDic objectForKey:@"user_remarks"] forKey:@"order_remarks"];
        [dicPost setObject:[_customerDic objectForKey:@"order_delivery"] forKey:@"order_delivery"];
        //转换成符合json格式的字符串
        NSString *orderInfoStr = [self DataTOjsonString:dicPost];
        
        [HttpTools postWithURL:CONTENTS_URL_AddOrderFromCar params:@{@"orderInfo":orderInfoStr} success:^(id responseObject) {
            NSDictionary *dicTemp = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            //输出请求状态
            UIAlertView *alerV = [[UIAlertView alloc] initWithTitle:@"提示信息" message:[dicTemp objectForKey:@"content"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alerV show];
            if ([[dicTemp objectForKey:@"status"] isEqualToString:@"1"]) {//如果提交订单成功
                _orderSno = [dicTemp objectForKey:@"order_sn"];
                [self performSegueWithIdentifier:@"OrderDetailSegue" sender:self];
            }
        } failure:^(NSError *error) {
            NSLog(@"%@",error.description);
        }];
        
    }else{//不是从购物车跳转过来的
        NSDictionary *dicGoodTemp = [_goodsArr objectAtIndex:0];//获取要购买的这个商品
        NSString *goodCountStr = [_goodsCountArr objectAtIndex:0];//获取要购买的这个商品的数量
        NSString *orderPayId = [NSString stringWithFormat:@"%d",[[_customerDic objectForKey:@"order_pay_id"] intValue]+1];
        NSString *orderDelivery = [NSString stringWithFormat:@"%d",[[_customerDic objectForKey:@"order_delivery"] intValue]+1];
        NSString *addOrderStr = [NSString stringWithFormat:CONTENTS_URL_AddOrderNow,[dicGoodTemp objectForKey:@"goods_id"],goodCountStr,[[Tools getUser] objectForKey:@"user_id"],[_customerDic objectForKey:@"user_name"],[_customerDic objectForKey:@"user_phone"],[_customerDic objectForKey:@"user_address"],orderPayId,[_customerDic objectForKey:@"user_remarks"],orderDelivery];
        [HttpTools getWithURL:[addOrderStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] params:nil success:^(id json) {
            NSDictionary *dicTemp = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingMutableContainers error:nil];
            //输出请求状态
            UIAlertView *alerV = [[UIAlertView alloc] initWithTitle:@"提示信息" message:[dicTemp objectForKey:@"content"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alerV show];
            //如果修改成功
            if ([[dicTemp objectForKey:@"status"] isEqualToString:@"1"]) {
                _orderSno = [dicTemp objectForKey:@"order_sn"];
                [self performSegueWithIdentifier:@"OrderDetailSegue" sender:self];
            }
        } failure:^(NSError *error) {
            NSLog(@"%@",error.description);
        }];
        
        
    }
}
//转成符合json格式的String
-(NSString*)DataTOjsonString:(id)object{
    NSString *jsonString = nil;
    NSError *error;
    //NSJSONWritingPrettyPrinted Pass 0 if you don't care about the readability of the generated string
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        //        jsonString = [jsonString stringByReplacingOccurrencesOfString:@" " withString:@""];
        //        jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        //        jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    }
    return jsonString;
}
#pragma mark - UIAlertView代理
//根据被点击按钮的索引处理点击事件
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
//    NSLog(@"clickButtonAtIndex:%ld",(long)buttonIndex);
    if(alertView.tag == 101 && buttonIndex >= 1 && buttonIndex <= _payFormArr.count){//支付方式
        [_customerDic setValue:[NSString stringWithFormat:@"%ld",(long)buttonIndex-1] forKey:@"order_pay_id"];
        NSIndexPath *indexPathTemp = [NSIndexPath indexPathForRow:1 inSection:1];
        //tableView刷新指定行
        [_tableV reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPathTemp, nil] withRowAnimation:UITableViewRowAnimationNone];
    }else if(alertView.tag == 102 && buttonIndex >= 1 && buttonIndex <= _sendFormArr.count){//配送方式
        [_customerDic setValue:[NSString stringWithFormat:@"%ld",buttonIndex-1] forKey:@"order_delivery"];
        //tableView刷新指定行
        NSIndexPath *indexPathTemp = [NSIndexPath indexPathForRow:2 inSection:1];
        [_tableV reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPathTemp, nil] withRowAnimation:UITableViewRowAnimationNone];
        [self resetHeJiPrice];//重新设置合计价格
    }
    
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //修改收货信息连线器
    if ([segue.destinationViewController isKindOfClass:[ChangeCustomViewController class]]) {
        ChangeCustomViewController *changeCustomVC = segue.destinationViewController;
        changeCustomVC.customDic = [[NSMutableDictionary alloc] init];
        [changeCustomVC.customDic addEntriesFromDictionary:_customerDic];
    }
    //订单详情展示（提交订单成功后）
    if ([segue.destinationViewController isKindOfClass:[OrderDetailViewController class]]) {
        OrderDetailViewController *orderDetailVC = segue.destinationViewController;
        //设置订单编号
        orderDetailVC.order_sn = _orderSno;
    }
}


@end
