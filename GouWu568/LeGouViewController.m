//
//  LeGouViewController.m
//  GouWu568
//
//  Created by echo13 on 15/9/25.
//  Copyright © 2015年 echo. All rights reserved.
//

#import "LeGouViewController.h"
#import "GoodsShowViewController.h"

@interface LeGouViewController ()<UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate>
@property (strong, nonatomic) NSArray *allGoodsArr;//商品分类
@property (strong, nonatomic) NSArray *selectGoodsArr;//当前选中的商品数组
@property (strong, nonatomic) NSArray *adsArr;//当前选中组的广告数组
@property (assign, nonatomic) NSInteger selectGoodsIndex;//当前选中的商品序号（在数组中的位置）
@property (strong, nonatomic) IBOutlet UITableView *kindOfGoodsTableView;
@property (strong, nonatomic) IBOutlet UICollectionView *goodsCollectionView;
@property (strong, nonatomic) NSDictionary *goodDetailDic;//跳转到商品详细界面时传递商品数据

@end

@implementation LeGouViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _allGoodsArr = [[NSArray alloc] init];
    _adsArr = [NSArray array];
    _selectGoodsArr = [[NSArray alloc] init];
    _selectGoodsIndex = 0;
    _kindOfGoodsTableView.tableFooterView = [[UIView alloc] init];
    _goodDetailDic = [[NSDictionary alloc] init];
    [self getData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//从服务器获取数据CONTENTS_URL_AllGoods
- (void)getData{
    NSString *allGoodsStr = CONTENTS_URL_AllGoods;
    [HttpTools getWithURL:allGoodsStr params:nil success:^(id json) {
        _allGoodsArr = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingMutableContainers error:nil];
//        NSLog(@"%@",_allGoodsArr);
        NSDictionary *dic = [_allGoodsArr objectAtIndex:_selectGoodsIndex];
        _selectGoodsArr = [dic objectForKey:@"listgoods"];
        [_kindOfGoodsTableView reloadData];
        [_goodsCollectionView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"%@",error.description);
    }];
}
#pragma mark - TableView 代理
//行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _allGoodsArr.count;
}
//执行显示
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *IdentCell = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IdentCell];
    if (!cell) {
//        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:IdentCell];
        cell = [[UITableViewCell alloc] init];
        //设置选中样式
//        cell.selectionStyle = UITableViewScrollPositionNone;
        //设置背景色
//        cell.bounds.size.width = _kindOfGoodsTableView.bounds.size.width;
        cell.backgroundColor = [UIColor whiteColor];
    }
    NSDictionary *dic = [_allGoodsArr objectAtIndex:indexPath.row];
    cell.textLabel.text = [dic objectForKey:@"goods_type_name"];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.font = [UIFont systemFontOfSize:15.0];
    
    return cell;
}
//cell点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _selectGoodsIndex = indexPath.row;
    NSDictionary *dic = [_allGoodsArr objectAtIndex:_selectGoodsIndex];
    _selectGoodsArr = [dic objectForKey:@"listgoods"];
    [_goodsCollectionView reloadData];
}
#pragma mark - CollectionView 代理
//行数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSDictionary *dic = [[NSDictionary alloc] init];
    if (_allGoodsArr.count != 0) {
        dic = [_allGoodsArr objectAtIndex:_selectGoodsIndex];
    }
    
    _adsArr = [dic objectForKey:@"add_goods"];
    if (_adsArr.count != 0) {
        return _selectGoodsArr.count+1;
    }
    return _selectGoodsArr.count;
}
//头高度
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
//}
//最小列间距
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
//
//}
//返回cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (_adsArr.count != 0 && indexPath.row == 0) {//判断是推荐collectionView
        return CGSizeMake(258, 85);
    }
    return CGSizeMake(85, 105);
}
//执行显示
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *IdentCell = [[NSString alloc] init];
    if (_adsArr.count != 0 && indexPath.row == 0) {
        IdentCell = @"CollectionHeadCell";
    }else{
        IdentCell = @"CollectionCell";
    }
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:IdentCell forIndexPath:indexPath];
    if (_adsArr.count != 0 && indexPath.row == 0) {
        UIScrollView *scrollV = (UIScrollView *)[cell viewWithTag:101];
        for (UIImageView *imageV in scrollV.subviews) {
            [imageV removeFromSuperview];
        }
        //设置ScrollView的contentSize值
        scrollV.contentSize = CGSizeMake(scrollV.frame.size.width * _adsArr.count, scrollV.frame.size.height);
        for (int i = 0; i<_adsArr.count; i++) {
            NSDictionary *dicTemp = [_adsArr objectAtIndex:i];
            //        NSLog(@"%@",adStr);
            NSString *adStr = [[NSString alloc] initWithFormat:@"%@%@",CONTENTS_URL_ROOT,[dicTemp objectForKey:@"goods_ad"]];
            UIImageView *imageViewTemp = [[UIImageView alloc] initWithFrame:CGRectMake(i*scrollV.frame.size.width, 0, scrollV.frame.size.width, scrollV.frame.size.height)];
            [imageViewTemp sd_setImageWithURL:[NSURL URLWithString:adStr] placeholderImage:[UIImage imageNamed:@"net_error_icon.png"]];
            [scrollV addSubview:imageViewTemp];
            
        }
    }else{
        UIImageView *imageV = (UIImageView *)[cell viewWithTag:101];
        UILabel *lab = (UILabel *)[cell viewWithTag:102];
        NSDictionary *dic = [_selectGoodsArr objectAtIndex:_adsArr.count == 0 ? indexPath.row:indexPath.row-1];
        NSString *imageStr = [NSString stringWithFormat:@"%@%@",CONTENTS_URL_ROOT,[dic objectForKey:@"goods_imgs"]];
        //    NSLog(@"imageStr == %@",imageStr);
        [imageV sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:[UIImage imageNamed:@"net_error_icon.png"]];
        lab.text = [dic objectForKey:@"goods_name"];
    }
    
    return cell;
}
//cell点击事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *goodDic = [_selectGoodsArr objectAtIndex:_adsArr.count == 0 ? indexPath.row:indexPath.row-1];
//    NSLog(@"goodDic = %@",goodDic);
    NSString *goodId = [goodDic objectForKey:@"goods_id"];
    NSString *goodUrl = [NSString stringWithFormat:CONTENTS_URL_GetGoodsDetail,goodId];
    [HttpTools getWithURL:goodUrl params:nil success:^(id json) {
        _goodDetailDic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingMutableContainers error:nil];
//        NSLog(@"%@",_goodDetailDic);
        [self performSegueWithIdentifier:@"GoodsShowSegue" sender:self];
    } failure:^(NSError *error) {
        NSLog(@"%@",error.description);
    }];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[GoodsShowViewController class]]) {
        GoodsShowViewController *goodsShowVC = segue.destinationViewController;
        goodsShowVC.goodsDetailDic = _goodDetailDic;
    }
}

@end
