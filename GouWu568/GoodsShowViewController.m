//
//  GoodsShowViewController.m
//  GouWu568
//
//  Created by echo13 on 15/10/7.
//  Copyright (c) 2015年 echo. All rights reserved.
//

#import "GoodsShowViewController.h"
#import "LoginViewController.h"
#import "AddOrderViewController.h"

@interface GoodsShowViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableV;
@property (assign, nonatomic) BOOL isChaKanDianPu;
@property (assign, nonatomic) NSInteger goodsCountOfCar;


@end

@implementation GoodsShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _isChaKanDianPu = YES;
    _goodsCountOfCar = 1;
    // Do any additional setup after loading the view.
    _tableV.tableFooterView = [[UIView alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - TableView代理
//行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_isChaKanDianPu) {
        return 12;
    }
    return 8;
}
//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 170;
    }else if (indexPath.row == 1){
        return 44;
    }else if (indexPath.row == 2){
        return 44;
    }else if (indexPath.row == 3){
        return 51;
    }else if (indexPath.row == 4){
        return 38;
    }else if (indexPath.row == 5){
        return 44;
    }else if (indexPath.row == 6){
        NSString *goodsContent = [_goodsDetailDic objectForKey:@"goods_content"];
        return 44-21+[LZXHelper textHeightFromTextString:goodsContent width:342 fontSize:15.0];
    }else if (indexPath.row == 7){
        return 44;
    }else if (indexPath.row == 8){
        return 44;
    }else if (indexPath.row == 9){
        return 44;
    }else if (indexPath.row == 10){
        return 44;
    }else if (indexPath.row == 11){
        NSDictionary *contentShopDic = [_goodsDetailDic objectForKey:@"contentShop"];//获取到该商品所属的店铺Dic信息
        NSString *goodsContent = [contentShopDic objectForKey:@"shop_about"];
        return 44-21+[LZXHelper textHeightFromTextString:goodsContent width:342 fontSize:15.0];
    }
    return 44;
}
//执行显示
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *contentShopDic = [_goodsDetailDic objectForKey:@"contentShop"];//获取到该商品所属的店铺Dic信息
    NSString *IdentCell = [[NSString alloc] init];
    UITableViewCell *cell;
    if (indexPath.row == 0) {
        IdentCell = @"CellScollView";
        cell = [tableView dequeueReusableCellWithIdentifier:IdentCell forIndexPath:indexPath];
        UIScrollView *scrollV = (UIScrollView *)[cell viewWithTag:101];
        for (UIImageView *imageV in scrollV.subviews) {
            [imageV removeFromSuperview];
        }
        //设置ScrollView的contentSize值
        NSArray *goodsImagesNewArr = [_goodsDetailDic objectForKey:@"goods_imgs_new"];
        scrollV.contentSize = CGSizeMake(scrollV.frame.size.width * goodsImagesNewArr.count, scrollV.frame.size.height);
        for (int i = 0; i<goodsImagesNewArr.count; i++) {
            NSDictionary *dicTemp = [goodsImagesNewArr objectAtIndex:i];
            //        NSLog(@"%@",adStr);
            NSString *adStr = [[NSString alloc] initWithFormat:@"%@%@",CONTENTS_URL_ROOT,[dicTemp objectForKey:@"img"]];
            UIImageView *imageViewTemp = [[UIImageView alloc] initWithFrame:CGRectMake(i*scrollV.frame.size.width, 0, scrollV.frame.size.width, scrollV.frame.size.height)];
            [imageViewTemp sd_setImageWithURL:[NSURL URLWithString:adStr] placeholderImage:[UIImage imageNamed:@"net_error_icon.png"]];
            [scrollV addSubview:imageViewTemp];
            
        }
    }else if (indexPath.row == 1){
        //商品名
        IdentCell = @"Cell02";
        cell = [tableView dequeueReusableCellWithIdentifier:IdentCell forIndexPath:indexPath];
        UILabel *lab = (UILabel *)[cell viewWithTag:101];
        lab.text = [_goodsDetailDic objectForKey:@"goods_title"];
        //收藏按钮
        UIButton *shouCangBtn = (UIButton *)[cell viewWithTag:102];
        [shouCangBtn addTarget:self action:@selector(ShouCangBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }else if (indexPath.row == 2){
        IdentCell = @"Cell03";
        cell = [tableView dequeueReusableCellWithIdentifier:IdentCell forIndexPath:indexPath];
        UILabel *lab = (UILabel *)[cell viewWithTag:101];
        lab.text = [_goodsDetailDic objectForKey:@"goods_typename"];
    }else if (indexPath.row == 3){
        IdentCell = @"Cell04";
        cell = [tableView dequeueReusableCellWithIdentifier:IdentCell forIndexPath:indexPath];
        UILabel *priceLab = (UILabel *)[cell viewWithTag:101];
        priceLab.text = [NSString stringWithFormat:@"%@.0元",[_goodsDetailDic objectForKey:@"goods_price"]];
        UILabel *markePriceLab = (UILabel *)[cell viewWithTag:102];
        NSString *str2 = [NSString stringWithFormat:@"%@.0元",[_goodsDetailDic objectForKey:@"goods_marke_price"]];
        //设置一个字符串中间加横线
        NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
        NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:str2 attributes:attribtDic];
        markePriceLab.attributedText = attribtStr;
        //数量减一button
        UIButton *reduceGoodsCountBtn = (UIButton *)[cell viewWithTag:103];
        [reduceGoodsCountBtn addTarget:self action:@selector(reduceGoodsCountBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [reduceGoodsCountBtn setImage:[UIImage imageNamed:_goodsCountOfCar==1?@"jian_gray.png":@"jian.png"] forState:UIControlStateNormal];
        //数量加一button
        UIButton *addGoodsCountBtn = (UIButton *)[cell viewWithTag:105];
        [addGoodsCountBtn addTarget:self action:@selector(addGoodsCountBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        //显示商品数量的button
        UIButton *goodsCountBtn = (UIButton *)[cell viewWithTag:104];
        [goodsCountBtn setTitle:[NSString stringWithFormat:@"%ld",(long)_goodsCountOfCar] forState:UIControlStateNormal];
    }else if (indexPath.row == 4){
        IdentCell = @"Cell05";
        cell = [tableView dequeueReusableCellWithIdentifier:IdentCell forIndexPath:indexPath];
        UILabel *lab = (UILabel *)[cell viewWithTag:101];
        lab.text = [NSString stringWithFormat:@"购买可以获得%@积分",[_goodsDetailDic objectForKey:@"goods_price"]];
    }else if (indexPath.row == 5){
        IdentCell = @"Cell06";
        cell = [tableView dequeueReusableCellWithIdentifier:IdentCell forIndexPath:indexPath];
    }else if (indexPath.row == 6){
        IdentCell = @"Cell07";
        cell = [tableView dequeueReusableCellWithIdentifier:IdentCell forIndexPath:indexPath];
        UILabel *lab = (UILabel *)[cell viewWithTag:101];
        lab.text = [_goodsDetailDic objectForKey:@"goods_content"];
    }else if (indexPath.row == 7){//从此开始是该商品的店铺信息
        IdentCell = @"Cell08";
        cell = [tableView dequeueReusableCellWithIdentifier:IdentCell forIndexPath:indexPath];
    }else if (indexPath.row == 8){
        IdentCell = @"Cell09";
        cell = [tableView dequeueReusableCellWithIdentifier:IdentCell forIndexPath:indexPath];
        UILabel *lab2 = (UILabel *)[cell viewWithTag:102];
        lab2.text = [contentShopDic objectForKey:@"shop_address"];
    }else if (indexPath.row == 9){
        IdentCell = @"Cell10";
        cell = [tableView dequeueReusableCellWithIdentifier:IdentCell forIndexPath:indexPath];
        UILabel *lab1 = (UILabel *)[cell viewWithTag:101];
        lab1.text = [NSString stringWithFormat:@"联系人：%@",[contentShopDic objectForKey:@"shop_contact"]];
        UILabel *lab2 = (UILabel *)[cell viewWithTag:102];
        lab2.text = [NSString stringWithFormat:@"电话：%@",[contentShopDic objectForKey:@"shop_tel"]];
    }else if (indexPath.row == 10){
        IdentCell = @"Cell11";
        cell = [tableView dequeueReusableCellWithIdentifier:IdentCell forIndexPath:indexPath];
    }else if (indexPath.row == 11){
        IdentCell = @"Cell12";
        cell = [tableView dequeueReusableCellWithIdentifier:IdentCell forIndexPath:indexPath];
        UILabel *lab = (UILabel *)[cell viewWithTag:101];
        lab.text = [contentShopDic objectForKey:@"shop_about"];
    }
    return cell;
}
//收藏button点击事件
- (void)ShouCangBtnClick{
    if ([Tools isLogin]) {
        //从本地获取用户对象
        NSDictionary *userDic = [Tools getUser];
        NSString *userId = [userDic objectForKey:@"user_id"];
        //从_goodsDetailDic获取商品id
        NSString *goodsId = [_goodsDetailDic objectForKey:@"goods_id"];
        //get请求时注意参数的顺序
        [HttpTools getWithURL:[NSString stringWithFormat:CONTENTS_URL_AddShouCang,goodsId,userId] params:nil success:^(id json) {
            NSDictionary *shouCangDic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingMutableContainers error:nil];
//            NSString *statusStr = [shouCangDic objectForKey:@"status"];//1表示添加收藏成功，0表示失败
            NSString *contentStr = [shouCangDic objectForKey:@"content"];//提示内容
            UIAlertView *alerV = [[UIAlertView alloc] initWithTitle:@"提示信息" message:contentStr delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alerV show];
            
        } failure:^(NSError *error) {
            NSLog(@"%@",error.description);
        }];
    }else{
        [self performSegueWithIdentifier:@"LogIn" sender:self];
    }
}
//返回按钮
- (IBAction)backBtnClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
//商品数量减一
- (void)reduceGoodsCountBtnClick:(UIButton *)btn{
    if (_goodsCountOfCar > 1) {
        _goodsCountOfCar --;
        if (_goodsCountOfCar == 1) {//设置btn的背景图片为不可点击图片,其实是设置btn上的imageView
            [btn setImage:[UIImage imageNamed:@"jian_gray.png"] forState:UIControlStateNormal];
        }
    }
    //刷新tableView的指定行
    NSIndexPath *indexPathTemp = [NSIndexPath indexPathForRow:3 inSection:0];
    [_tableV reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPathTemp, nil] withRowAnimation:UITableViewRowAnimationNone];
}
//商品数量加一
- (void)addGoodsCountBtnClick:(UIButton *)btn{
    _goodsCountOfCar ++;
    UIView *viewTemp = btn.superview;
    if (_goodsCountOfCar == 2) {//设置减一btn的背景图片为可点击图片,其实是设置btn上的imageView
        UIButton *reduceGoodsCountBtn = (UIButton *)[viewTemp viewWithTag:103];
        [reduceGoodsCountBtn setImage:[UIImage imageNamed:@"jian.png"] forState:UIControlStateNormal];
    }
    NSIndexPath *indexPathTemp = [NSIndexPath indexPathForRow:3 inSection:0];
    [_tableV reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPathTemp, nil] withRowAnimation:UITableViewRowAnimationNone];
}
//加入购物车按钮
- (IBAction)addIntoShopCarBtnClick:(UIButton *)sender {
    if ([Tools isLogin]) {//
        //从本地获取用户对象
        NSDictionary *userDic = [Tools getUser];
        NSString *userId = [userDic objectForKey:@"user_id"];
        //从_goodsDetailDic获取商品id
        NSString *goodsId = [_goodsDetailDic objectForKey:@"goods_id"];
        //获取要添加的商品数量
        NSString *goodsCount = [NSString stringWithFormat:@"%ld",(long)_goodsCountOfCar];
        //get请求时注意参数的顺序
        [HttpTools getWithURL:[NSString stringWithFormat:CONTENTS_URL_AddGoodsIntoCar,goodsId,goodsCount,userId] params:nil success:^(id json) {
            //此处不用json解析
            NSString *addCarStr = [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
            UIAlertView *alerV = [[UIAlertView alloc] initWithTitle:@"提示信息" message:addCarStr delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alerV show];
            if ([addCarStr isEqualToString:@"\"success\""]) {
                [alerV setMessage:@"加入购物车成功"];
            }else if([addCarStr isEqualToString:@"\"false\""]){
                [alerV setMessage:@"加入购物车失败"];
            }else{
                [alerV setMessage:@"貌似出错了"];
            }
        } failure:^(NSError *error) {
            NSLog(@"%@",error.description);
        }];
        
    }else{
        [self performSegueWithIdentifier:@"LogIn" sender:self];
    }
}
//立即购买按钮
- (IBAction)buyBtnClick:(UIButton *)sender {
    if ([Tools isLogin]) {
        [self performSegueWithIdentifier:@"AddOrderSegue" sender:self];
    }else{
        [self performSegueWithIdentifier:@"LogIn" sender:self];
    }
}



#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[LoginViewController class]]) {
        
    }else if ([segue.destinationViewController isKindOfClass:[AddOrderViewController class]]) {
        AddOrderViewController *addOrderVC = segue.destinationViewController;
        //传递商品信息数组
        addOrderVC.goodsArr = [[NSMutableArray alloc] init];
        [addOrderVC.goodsArr addObject:_goodsDetailDic];
        //传递商品数量数组
        addOrderVC.goodsCountArr = [[NSMutableArray alloc] init];
        [addOrderVC.goodsCountArr addObject:[NSString stringWithFormat:@"%ld",(long)_goodsCountOfCar]];
        //设置不是从购物车跳转的
        addOrderVC.isFromShopingCar = NO;
    }
}


@end
