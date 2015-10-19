//
//  FaXianViewController.m
//  GouWu568
//
//  Created by echo13 on 15/9/25.
//  Copyright © 2015年 echo. All rights reserved.
//

#import "FaXianViewController.h"
#import "LoginViewController.h"
#import "FaXianDetailViewController.h"
#import "FaXianTypeViewController.h"
#import "SVGloble.h"

@interface FaXianViewController ()<UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *fangChanImageV;//房产图标
@property (strong, nonatomic) IBOutlet UIImageView *zhaoPinImageV;//招聘图标
@property (strong, nonatomic) IBOutlet UIImageView *fangChanRedImageV;//房产下滑红线图标
@property (strong, nonatomic) IBOutlet UIImageView *zhaoPinRedImageV;//招聘下滑红线图标
@property (strong, nonatomic) IBOutlet UICollectionView *collectionV;//collectionView
@property (strong, nonatomic) IBOutlet UITableView *tableV;//tableView
@property (strong, nonatomic) IBOutlet UILabel *faBuXinXiLab;//免费发布信息Label

@property (strong, nonatomic) NSDictionary *faXianDic;//此界面所有信息
@property (strong, nonatomic) NSArray *typeFangChanArr;//房产信息分类
@property (strong, nonatomic) NSArray *listFangChanArr;//所有房产信息
@property (strong, nonatomic) NSArray *typeZhaoPinArr;//招聘信息分类
@property (strong, nonatomic) NSArray *listZhaoPinArr;//所有招聘信息
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *heightForCollectionV;//CollectionView高度
@property (strong, nonatomic) NSString *infoIdStr;//传递给发现信息详情页
@property (assign, nonatomic) BOOL isFangChan;
@property (assign, nonatomic) BOOL showCollectionV;

@end

@implementation FaXianViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _isFangChan = YES;
    _showCollectionV = NO;
    _fangChanRedImageV.hidden = YES;
    _zhaoPinRedImageV.hidden = YES;
    _heightForCollectionV.constant = 0;//设置collectionView高度
    _faXianDic = [[NSDictionary alloc] init];
    _typeFangChanArr = [[NSArray alloc] init];
    _listFangChanArr = [[NSArray alloc] init];
    _typeZhaoPinArr = [[NSArray alloc] init];
    _listZhaoPinArr = [[NSArray alloc] init];
    [self setData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setData{
    NSString *faXianStr = [NSString stringWithFormat:CONTENTS_URL_FaXian,@"2"];
    [HttpTools getWithURL:faXianStr params:nil success:^(id json) {
        _faXianDic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingMutableContainers error:nil];
        NSArray *arrTemp = [_faXianDic objectForKey:@"type"];
        
        NSDictionary *dicTemp1 = [arrTemp objectAtIndex:0];//房产
        //设置typeFangChanArr
        _typeFangChanArr = [dicTemp1 objectForKey:@"small_infp_type"];
        //设置listFangChanArr
        _listFangChanArr = [dicTemp1 objectForKey:@"listinfo"];
        NSDictionary *dicTemp2 = [arrTemp objectAtIndex:1];//招聘
        //设置typeZhaoPinArr
        _typeZhaoPinArr = [dicTemp2 objectForKey:@"small_infp_type"];
        //设置listZhaoPinArr
        _listZhaoPinArr = [dicTemp2 objectForKey:@"listinfo"];
        [_collectionV reloadData];
        [_tableV reloadData];
    } failure:^(NSError *error) {
        NSLog(@"error == %@",error.description);
    }];
}
//房产Btn点击事件
- (IBAction)fangChanBtnClick:(UIButton *)sender {
    if (_isFangChan) {
        if (_showCollectionV) {
            _showCollectionV = NO;
            _fangChanRedImageV.hidden = YES;
            _heightForCollectionV.constant = 0;
        }else{
            _showCollectionV = YES;
            _fangChanRedImageV.hidden = NO;
            _heightForCollectionV.constant = 70;
        }
    }else{
        _isFangChan = YES;
        _showCollectionV = NO;
        _fangChanRedImageV.hidden = YES;
        _zhaoPinRedImageV.hidden = YES;
        _heightForCollectionV.constant = 0;
        
        _faBuXinXiLab.text = @"免费发布房产信息";
        [_tableV reloadData];
        [_collectionV reloadData];
    }
}
//招聘Btn点击事件
- (IBAction)zhaoPinBtnClick:(UIButton *)sender {
    if (!_isFangChan) {
        if (_showCollectionV) {
            _showCollectionV = NO;
            _zhaoPinRedImageV.hidden = YES;
            _heightForCollectionV.constant = 0;
        }else{
            _showCollectionV = YES;
            _zhaoPinRedImageV.hidden = NO;
            _heightForCollectionV.constant = 70;
        }
    }else{
        _isFangChan = NO;
        _showCollectionV = NO;
        _fangChanRedImageV.hidden = YES;
        _zhaoPinRedImageV.hidden = YES;
        _heightForCollectionV.constant = 0;
        
        _faBuXinXiLab.text = @"免费发布招聘信息";
        [_tableV reloadData];
        [_collectionV reloadData];
    }
}
//免费发布信息Btn点击事件
- (IBAction)faBuXinXiBtnClick:(UIButton *)sender {
}
#pragma mark - TableView代理
//行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_isFangChan) {//如果是房产
        return _listFangChanArr.count;
    }
    return _listZhaoPinArr.count;//如果是招聘
}
//执行显示
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *IdentCell = @"ShowMessageCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IdentCell forIndexPath:indexPath];
    
    if (_listZhaoPinArr.count!=0 && _listFangChanArr.count!=0) {
        //获取到当前要显示的数据
        NSDictionary *dicTemp = [_isFangChan ? _listFangChanArr : _listZhaoPinArr objectAtIndex:indexPath.row];
        //设置图片
        UIImageView *imageV = (UIImageView *)[cell viewWithTag:101];
        NSString *imageStr = [NSString stringWithFormat:@"%@%@",CONTENTS_URL_ROOT,[dicTemp objectForKey:@"info_imgs"]];
        [imageV sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:[UIImage imageNamed:@"net_error_icon.png"]];
        //设置名称
        UILabel *nameLab = (UILabel *)[cell viewWithTag:102];
        nameLab.text = [dicTemp objectForKey:@"info_title"];
        //设置地址
        UILabel *addressLab = (UILabel *)[cell viewWithTag:103];
        addressLab.text = [dicTemp objectForKey:@"info_address"];
        //设置价格
        UILabel *priceLab = (UILabel *)[cell viewWithTag:104];
        priceLab.text = [dicTemp objectForKey:@"info_money"];
        //设置发布日期
        UILabel *dateLab = (UILabel *)[cell viewWithTag:105];
        dateLab.text = [dicTemp objectForKey:@"info_addtime"];
    }
    
    return cell;
    
}
//TableViewCell 点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _infoIdStr = [[_isFangChan ? _listFangChanArr : _listZhaoPinArr objectAtIndex:indexPath.row] objectForKey:@"info_id"];
    [self performSegueWithIdentifier:@"FaXianDetailSegue" sender:self];
}
#pragma mark -CollectionView代理
//行数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (_isFangChan) {//如果是房产
        return _typeFangChanArr.count;
    }
    return _typeZhaoPinArr.count;//如果是招聘
}
//执行显示
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *IdentCell = @"ShowTypeCell";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:IdentCell forIndexPath:indexPath];
    //获取当前要显示的数据
    NSDictionary *dicTemp = [_isFangChan ? _typeFangChanArr : _typeZhaoPinArr objectAtIndex:indexPath.row];
    UILabel *lab = (UILabel *)[cell viewWithTag:101];
    lab.text = [dicTemp objectForKey:@"info_type_name"];
    return cell;
}
//cell点击事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    NSLog(@"%ld",(long)indexPath.row);
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    [SVGloble shareInstance].globleWidth = screenRect.size.width; //屏幕宽度
    [SVGloble shareInstance].globleHeight = screenRect.size.height-20;  //屏幕高度（无顶栏）
    [SVGloble shareInstance].globleAllHeight = screenRect.size.height;  //屏幕高度（有顶栏）
    
    FaXianTypeViewController *faXianVC = [[FaXianTypeViewController alloc] init];
    faXianVC.typeArr = [[NSMutableArray alloc] init];
    faXianVC.typeArr = (NSMutableArray *)(_isFangChan?_typeFangChanArr:_typeZhaoPinArr);
    self.hidesBottomBarWhenPushed = YES;//隐藏TabBarController
//    [self hidesBottomBarWhenPushed];//不可以用这个
    [self.navigationController pushViewController:faXianVC animated:YES];
}
#pragma mark - Navigation
//FaXianDetailSegue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[LoginViewController class]]) {//跳到登录界面
        
    }else if ([segue.destinationViewController isKindOfClass:[FaXianDetailViewController class]]){//跳到发现详情页
        FaXianDetailViewController *faxianDetailVC = segue.destinationViewController;
        faxianDetailVC.infoIdStr = _infoIdStr;
        faxianDetailVC.isFangChan = _isFangChan;
    }
}


@end
