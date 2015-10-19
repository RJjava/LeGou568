//
//  ShouYeViewController.m
//  GouWu568
//
//  Created by echo13 on 15/9/25.
//  Copyright © 2015年 echo. All rights reserved.
//

#import "ShouYeViewController.h"
#import "HeadViewShouYe.h"
#import "CompanyViewController.h"

@interface ShouYeViewController ()<UITableViewDataSource, UITableViewDelegate>
//分类中的collectionView
@property (strong, nonatomic) IBOutlet UICollectionView *collectionV;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollV;
@property (strong, nonatomic) IBOutlet UITableView *tableV;
@property (strong, nonatomic) NSMutableArray *adArray;//有广告的店铺
//通过www.lg568.com/index.php/Home/API/CompanyType/city_id/2/获取到所有店铺的数组
@property (strong, nonatomic) NSMutableArray *allCompanyArray;
//三级分类数组
@property (strong, nonatomic) NSMutableArray *allCompanyModelArr;
//被点击的button的Tag值
@property (strong, nonatomic) NSString *selectBtnTag;
//通过被点击的button查询到的company对象
@property (strong, nonatomic) CompanyModel *selectCompany;


//通过www.lg568.com/index.php/Home/API/recommendCompany/city_id/2获取到推荐店铺的数组
@property (strong, nonatomic) NSMutableArray *recommendCompanyArray;



@end

@implementation ShouYeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _adArray = [NSMutableArray array];
    _allCompanyArray = [NSMutableArray array];
    _allCompanyModelArr = [NSMutableArray array];
    [self getRecommendCompany];
    [self getAllCompanyDate];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//获取推荐Company数据
- (void)getRecommendCompany{
    NSString *urlStr = [[NSString alloc] initWithFormat:@"%@%@%@",CONTENTS_URL_ROOT,CONTENTS_URL_MIDLE,CONTENTS_URL_CompanyRecommend];
    [HttpTools getWithURL:urlStr params:nil success:^(id json) {
        _recommendCompanyArray = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
//        NSLog(@"%@",_recommendCompanyArray);
        [_collectionV reloadData];
    } failure:^(NSError *error) {
        NSLog(@"%@",error.description);
    }];

}
//获取所有Company数据
- (void)getAllCompanyDate{
    
    //设置_allCompanyArray数组
    NSString *urlStr = [[NSString alloc]initWithFormat:@"%@%@%@",CONTENTS_URL_ROOT,CONTENTS_URL_MIDLE,CONTENTS_URL_CompanyType];
    [HttpTools getWithURL:urlStr params:nil success:^(id json) {
        _allCompanyArray = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
//        NSLog(@"%@",_allCompanyArray);
        //同时获取广告
        for (NSMutableDictionary *allDic in _allCompanyArray) {
            NSMutableArray *add_companyArr = [allDic objectForKey:@"add_company"];
            for (NSMutableDictionary *companyDic in add_companyArr) {
                NSString *company_ad = [companyDic objectForKey:@"company_ad"];
                if (![company_ad isEqualToString:@""]) {
                    [_adArray addObject:company_ad];
                }
                
            }
        }
        //同时获取三级分类数组
        for (NSMutableDictionary *dic1 in _allCompanyArray) {
            NSMutableArray *smallCompany = [dic1 objectForKey:@"small_company_type"];
            NSMutableArray *arrTemp01 = [[NSMutableArray alloc] init];
            for (NSMutableDictionary *dic2 in smallCompany) {
                NSMutableArray *arrT = [dic2 objectForKey:@"company"];
                NSMutableArray *arrTemp02 = [NSMutableArray array];
                for (NSMutableDictionary *dic3 in arrT) {
                    CompanyModel *companyM = [[CompanyModel alloc] init];
                    [companyM setCompanyModelByDic:dic3];
                    [arrTemp02 addObject:companyM];
                }
                [arrTemp01 addObject:arrTemp02];
            }
            [_allCompanyModelArr addObject:arrTemp01];
        }
        
        [_tableV reloadData];
        [self addScroView];
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error.description);
    }];
    
}
//添加滚动视图
- (void)addScroView{
    //先清空之前_backScrollView
    for (UIImageView *imageV in _scrollV.subviews) {
        [imageV removeFromSuperview];
    }
    //设置ScrollView的contentSize值
    _scrollV.contentSize = CGSizeMake(_scrollV.frame.size.width * _adArray.count, _scrollV.frame.size.height);
    for (int i = 0; i<_adArray.count; i++) {
        NSString *adStr = [_adArray objectAtIndex:i];
//        NSLog(@"%@",adStr);
        NSString *adUrl = [[NSString alloc] initWithFormat:@"%@%@",CONTENTS_URL_ROOT,adStr];
        UIImageView *imageViewTemp = [[UIImageView alloc] initWithFrame:CGRectMake(i*_scrollV.frame.size.width, 0, _scrollV.frame.size.width, _scrollV.frame.size.height)];
        [imageViewTemp sd_setImageWithURL:[NSURL URLWithString:adUrl] placeholderImage:[UIImage imageNamed:@"net_error_icon.png"]];
        [_scrollV addSubview:imageViewTemp];
        
    }
}
#pragma mark - TableView代理
//组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _allCompanyArray.count;
}
//行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSDictionary *dic = _allCompanyArray[section];//得到当前分组的全部内容
    NSArray *arr = [dic objectForKey:@"small_company_type"];//获得当前分组的二级分类全部内容
    return arr.count;
    
}
//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
//设置tableView的头（页眉）
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    static NSString *headIdent = @"headView";
    //复用头View
    HeadViewShouYe *headV = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headIdent];
    if (!headV) {
        headV = [[HeadViewShouYe alloc] initWithReuseIdentifier:headIdent];
    }
    NSDictionary *dic = _allCompanyArray[section];
    headV.dic = dic;
    
    return headV;
}
//头(页眉)高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
//执行显示
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdent = @"ShouYeCell01";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdent forIndexPath:indexPath];
    if (cell) {
        NSDictionary *dic1 = _allCompanyArray[indexPath.section];//得到当前分组的全部内容
        NSArray *arr = [dic1 objectForKey:@"small_company_type"];//获得当前分组的二级分类全部内容
        NSDictionary *dic2 = arr[indexPath.row];//获得当前行的分类
        
        
        NSString *company_type_name = [dic2 objectForKey:@"company_type_name"];//获得当前分类的company_type_name
        UIButton *btnType2 = (UIButton *)[cell viewWithTag:101];
        [btnType2 setTitle:company_type_name forState:UIControlStateNormal];
        
        
        //解决复用cell时出现的问题
        for (UIView *uV in cell.contentView.subviews) {
            if (uV .tag == 102) {
                for (UIView *tempView in uV.subviews) {
                    [tempView removeFromSuperview];
                }
            }
        }
        
        UIView *viewBtns = [cell viewWithTag:102];//获取UIView
        viewBtns.backgroundColor = [UIColor clearColor];
        if (_allCompanyModelArr.count > indexPath.section) {
            NSMutableArray *arrTemp1 = [_allCompanyModelArr objectAtIndex:indexPath.section];
            if (arrTemp1.count > indexPath.row) {
                NSMutableArray *arrTemp2 = [arrTemp1 objectAtIndex:indexPath.row];
                if (arrTemp2.count != 0) {
//                    double ceil (double); 取上整
//                    double floor (double); 取下整
                    int hNumOfView = (arrTemp2.count+2.5)/3;//也可以用向上取整方法
                    CGFloat originX = viewBtns.bounds.origin.x;//storyBar中viewBtns的x坐标
                    CGFloat originY = viewBtns.bounds.origin.y;//storyBar中viewBtns的y坐标
                    CGFloat sizeW = viewBtns.bounds.size.width;//storyBar中viewBtns的宽度
                    CGFloat sizeH = viewBtns.bounds.size.height;//storyBar中viewBtns的高度
                    [viewBtns setBounds:CGRectMake(originX, originY, sizeW, sizeH * hNumOfView)];
                    for (int i = 0; i<arrTemp2.count; i++) {
                        CompanyModel *companyM = arrTemp2[i];
                        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                        [btn setFrame:CGRectMake(i%3*(sizeW/3), ceil(i/3)*sizeH, sizeW/3, sizeH)];
                        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];//设置字体颜色
                        [btn setBackgroundColor:[UIColor clearColor]];//设置背景颜色
                        [btn setContentEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
                        btn.titleLabel.font = [UIFont systemFontOfSize:14.0];//设置字体大小
                        [btn setTag:[companyM.company_id intValue]];//设置tag值
                        [btn addTarget:self action:@selector(companyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                        [btn setTitle:companyM.company_name forState:UIControlStateNormal];
                        [viewBtns addSubview:btn];
                    }
                    
                    
                }
            }
        }
    }
    return cell;
}


#pragma mark - collectionView代理
//分组数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if (collectionView == _collectionV) {//判断是推荐collectionView
        return 1;
    }
    return 0;
}
//每个分组中的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (collectionView == _collectionV) {//判断是推荐collectionView
        return 18;
    }
    return 0;
}
//返回cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView == _collectionV) {//判断是推荐collectionView
        return CGSizeMake(120, 29);
    }
    return CGSizeMake(0, 0);
}
//最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    if (collectionView == _collectionV) {//判断是推荐collectionView
        return 1;
    }
    return 0;
}
//最小列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    if (collectionView == _collectionV) {//判断是推荐collectionView
        return 0;
    }
    return 0;
}
//执行显示
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdent = @"ShouYeCollectionCell";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdent forIndexPath:indexPath];
    //    UICollectionViewCell *cell = [[UICollectionViewCell alloc]init];
    if (cell) {
        //解决复用cell时出现的问题
        for (UIView *uV in cell.contentView.subviews) {
            if (uV .tag == 103) {
                for (UIView *tempView in uV.subviews) {
                    [tempView removeFromSuperview];
                }
            }
        }
        
        //获取到当前推荐的company词典
        NSMutableDictionary *dic = _recommendCompanyArray[indexPath.row];
        //获取到当前推荐的company的company_ico（图片地址）
        NSString *strUrl = [dic objectForKey:@"company_ico"];
        NSString *picUrl = [NSString stringWithFormat:@"%@%@",CONTENTS_URL_ROOT,strUrl];
        //获取到当前推荐的company的company_shortname（短名称）
        NSString *shortName = [dic objectForKey:@"company_shortname"];
        //获取当前推荐的company的company_id
        NSString *companyId = [dic objectForKey:@"company_id"];
        
        UIImageView *imageV = (UIImageView *)[cell viewWithTag:101];
        UILabel *lab = (UILabel *)[cell viewWithTag:102];
        
        UIView *viewTemp = (UIView *)[cell viewWithTag:103];
        
        //设置图片
        [imageV sd_setImageWithURL:[NSURL URLWithString:picUrl] placeholderImage:[UIImage imageNamed:@"net_error_icon.png"]];
        //设置label
        lab.text = shortName;
        
        UIButton *btn = [[UIButton alloc] initWithFrame:viewTemp.bounds];
        //设置tag值
        [btn setTag:[companyId intValue]];
        //添加Button点击事件
        [btn addTarget:self action:@selector(companyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [viewTemp addSubview:btn];
        
    }
    return cell;
}
//点击button进入店铺详情页
- (void)companyBtnClick:(UIButton *)btn{
    _selectBtnTag = [NSString stringWithFormat:@"%ld",(long)btn.tag];
    _selectCompany = [[CompanyModel alloc] init];
    NSString *selectCompanyUrl = [NSString stringWithFormat:CONTENTS_URL_SelectCompanyById,_selectBtnTag];
//    NSLog(@"%@",selectCompanyUrl);
    [HttpTools getWithURL:selectCompanyUrl params:nil success:^(id json) {
        NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingMutableContainers error:nil];
//        NSLog(@"%@",dic);
        [_selectCompany setCompanyModelByDic:dic];
        [self performSegueWithIdentifier:@"CompanyShow" sender:self];
    } failure:^(NSError *error) {
        NSLog(@"%@",error.description);
    }];

//    NSLog(@"company == %@",_selectCompany);
    
    
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[CompanyViewController class]]) {
        CompanyViewController *companyVC = segue.destinationViewController;
        companyVC.companyM = _selectCompany;
    }
}


@end
