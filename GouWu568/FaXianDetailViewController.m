//
//  FaXianDetailViewController.m
//  GouWu568
//
//  Created by echo13 on 15/10/15.
//  Copyright (c) 2015年 echo. All rights reserved.
//

#import "FaXianDetailViewController.h"
#import "UMSocial.h"

@interface FaXianDetailViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableV;
@property (strong, nonatomic) IBOutlet UILabel *lianXiRenLab;//联系人lab
@property (strong, nonatomic) IBOutlet UILabel *phoneLab;//联系人电话lab

@property (strong, nonatomic) NSDictionary *faXianDetailDic;


@end

@implementation FaXianDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setData];
    _faXianDetailDic = [[NSMutableDictionary alloc] init];
    _tableV.tableFooterView = [[UIView alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setData{
    NSString *faxianDetailStr = [NSString stringWithFormat:CONTENTS_URL_FaXianDetail,_infoIdStr];
    [HttpTools getWithURL:faxianDetailStr params:nil success:^(id json) {
        _faXianDetailDic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingMutableContainers error:nil];
        _faXianDetailDic = [Tools removeNullFromDic:_faXianDetailDic];
        _phoneLab.text = [_faXianDetailDic objectForKey:@"info_tel"];
        _lianXiRenLab.text = [_faXianDetailDic objectForKey:@"info_contact"];
        [_tableV reloadData];
    } failure:^(NSError *error) {
        NSLog(@"%@",error.description);
    }];
}
//返回btn点击事件
- (IBAction)backBtnClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
//分享btn点击事件
- (IBAction)shareBtnClick:(UIButton *)sender {
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:CONTENTS_URL_YouMengAppKey
                                      shareText:@"你要分享的文字"
                                     shareImage:[UIImage imageNamed:@"icon.png"]
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQzone,UMShareToQQ,UMShareToRenren,UMShareToDouban,UMShareToEmail,UMShareToSms,UMShareToFacebook,UMShareToTwitter,nil]
                                       delegate:nil];
}
#pragma mark - TableView代理
//行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_isFangChan) {
        return 6;
    }else{
        return 7;
    }
    return 6;
}
//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {//scrollView图片
        return 165;
    }else if(indexPath.row == 1){//浏览人数
        return 44;
    }else if(indexPath.row == 2){//薪资
        return 51;
    }else if(indexPath.row == 3){//地址
        return 44;
    }else if(indexPath.row == 4&& !_isFangChan){//招聘人数（只有招聘有）8321
        return 83-21+[LZXHelper textHeightFromTextString:[_faXianDetailDic objectForKey:@"info_job_requirement"] width:302 fontSize:15.0];
    }else if((_isFangChan && indexPath.row == 4)||(!_isFangChan && indexPath.row == 5)){//公司待遇
        NSArray *arrTemp = [_faXianDetailDic objectForKey:_isFangChan?@"info_home_config_new":@"info_job_weal_new"];
        return 44+(arrTemp.count+2.5)/3*30-30;
    }else if((_isFangChan && indexPath.row == 5)||(!_isFangChan && indexPath.row == 6)){//公司介绍
        return 72-21+[LZXHelper textHeightFromTextString:[_faXianDetailDic objectForKey:_isFangChan? @"info_home_explain": @"info_job_companyintro"] width:359 fontSize:15.0];
    }
    return 44;
}
//执行显示
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    if (indexPath.row == 0) {//scrollView显示图片
        cell = [tableView dequeueReusableCellWithIdentifier:@"ScrollViewCell" forIndexPath:indexPath];
        UIScrollView *scrollV = (UIScrollView *)[cell viewWithTag:101];
        NSMutableArray *picArr = [_faXianDetailDic objectForKey:@"info_imgs_new"];//获取图片数组
        //先清空之前_backScrollView
        for (UIImageView *imageV in scrollV.subviews) {
            [imageV removeFromSuperview];
        }
        //设置ScrollView的contentSize值
        scrollV.contentSize = CGSizeMake(scrollV.frame.size.width * picArr.count, scrollV.frame.size.height);
        for (int i = 0; i< picArr.count; i++) {
            NSString *adStr = [[picArr objectAtIndex:i] objectForKey:@"img"];
            NSString *imgsUrl = [[NSString alloc] initWithFormat:@"%@%@",CONTENTS_URL_ROOT,adStr];
            UIImageView *imageViewTemp = [[UIImageView alloc] initWithFrame:CGRectMake(i*scrollV.frame.size.width, 0, scrollV.frame.size.width, scrollV.frame.size.height)];
            [imageViewTemp sd_setImageWithURL:[NSURL URLWithString:imgsUrl] placeholderImage:[UIImage imageNamed:@"net_error_icon.png"]];
            [scrollV addSubview:imageViewTemp];
        }
    }else if (indexPath.row == 1){//标题和浏览人数
        cell = [tableView dequeueReusableCellWithIdentifier:@"GongSiXinXiCell" forIndexPath:indexPath];
        UILabel *titleLab = (UILabel *)[cell viewWithTag:101];//标题
        titleLab.text = [_faXianDetailDic objectForKey:@"info_title"];
        UILabel *hitsLab = (UILabel *)[cell viewWithTag:102];//浏览人数
        hitsLab.text = [NSString stringWithFormat:@"%@人浏览",[_faXianDetailDic objectForKey:@"info_hits"]];
    }else if (indexPath.row == 2){//每月钱数和日期
        cell = [tableView dequeueReusableCellWithIdentifier:@"SalaryCell" forIndexPath:indexPath];
        UILabel *moneyLab = (UILabel *)[cell viewWithTag:101];
        moneyLab.text = [_faXianDetailDic objectForKey:_isFangChan?@"info_home_price" : @"info_job_salary"];
        UILabel *dateLab = (UILabel *)[cell viewWithTag:102];
        dateLab.text = [_faXianDetailDic objectForKey:@"info_addtime"];
    }else if (indexPath.row == 3){//地址
        cell = [tableView dequeueReusableCellWithIdentifier:@"AddressCell" forIndexPath:indexPath];
        UILabel *addressLab = (UILabel *)[cell viewWithTag:101];
        addressLab.text = [_faXianDetailDic objectForKey:_isFangChan?@"info_home_address" : @"info_job_position"];
    }else if (indexPath.row == 4&& !_isFangChan){//招聘中招聘人数等
        cell = [tableView dequeueReusableCellWithIdentifier:@"ZhaoPinXinXiCell" forIndexPath:indexPath];
        UILabel *companyNameLab = (UILabel *)[cell viewWithTag:101];//公司名称
        companyNameLab.text = [_faXianDetailDic objectForKey:@"info_job_companyname"];
        UILabel *numberLab = (UILabel *)[cell viewWithTag:102];//招聘人数
        numberLab.text = [NSString stringWithFormat:@"%@人",[_faXianDetailDic objectForKey:@"info_job_number"]];
        UILabel *requirementLab = (UILabel *)[cell viewWithTag:103];//要求
        requirementLab.text = [_faXianDetailDic objectForKey:@"info_job_requirement"];
    }else if ((_isFangChan && indexPath.row == 4)||(!_isFangChan && indexPath.row == 5)){//房屋配置或公司福利
        cell = [tableView dequeueReusableCellWithIdentifier:@"FuLiCell" forIndexPath:indexPath];
        NSArray *arrTemp = [_faXianDetailDic objectForKey:_isFangChan?@"info_home_config_new":@"info_job_weal_new"];
        if (arrTemp.count != 0) {
            UIView *viewCell = (UIView *)[cell viewWithTag:101];
            //                    double ceil (double); 取上整
            //                    double floor (double); 取下整
            int hNumOfView = (arrTemp.count+2.5)/3;//也可以用向上取整方法
            CGFloat originX = viewCell.bounds.origin.x;//storyBar中viewBtns的x坐标
            CGFloat originY = viewCell.bounds.origin.y;//storyBar中viewBtns的y坐标
            CGFloat sizeW = viewCell.bounds.size.width;//storyBar中viewBtns的宽度
            CGFloat sizeH = viewCell.bounds.size.height;//storyBar中viewBtns的高度
            [viewCell setBounds:CGRectMake(originX, originY, sizeW, sizeH * hNumOfView)];
            for (int i = 0; i<arrTemp.count; i++) {
                UIView *viewTemp = [[UIView alloc] initWithFrame:CGRectMake(i%3*(sizeW/3), ceil(i/3)*sizeH, sizeW/3, sizeH)];
                UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, 10, 10)];
                imageV.image = [UIImage imageNamed:@"star.png"];//添加图片
                [viewTemp addSubview:imageV];
                UILabel *labTemp = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 90, 20)];
                NSDictionary *dicTemp = [arrTemp objectAtIndex:i];
                labTemp.text = [dicTemp objectForKey:@"text"];
                labTemp.font = [UIFont systemFontOfSize:14.0];
                labTemp.textColor = [UIColor blackColor];//设置lab字体颜色
                labTemp.backgroundColor = [UIColor clearColor];
                [viewTemp addSubview:labTemp];
                
                viewTemp.backgroundColor = [UIColor clearColor];
                [viewCell addSubview:viewTemp];
            }
        }
        
        
//        for (int i = 0; i < arrTemp.count; i++) {
//            UIView *viewTemp = [[UIView alloc] init];
//            UIView *viewTemp2 = (UIView *)[cell viewWithTag:102];
//            viewTemp = viewTemp2;
//            viewTemp.frame = CGRectMake(i%3*viewTemp.bounds.size.width+viewTemp.bounds.origin.x, ceil(i/3)*viewTemp.bounds.size.height+viewTemp.bounds.origin.y, viewTemp.bounds.size.width, viewTemp.bounds.size.height);
//            [[tableView cellForRowAtIndexPath:indexPath].contentView addSubview:viewTemp];
//        }
    }else if ((_isFangChan && indexPath.row == 5)||(!_isFangChan && indexPath.row == 6)){//公司介绍
        cell = [tableView dequeueReusableCellWithIdentifier:@"GongSiJieShaoCell" forIndexPath:indexPath];
        UILabel *companyIntroLab = (UILabel *)[cell viewWithTag:101];
        companyIntroLab.text = [_faXianDetailDic objectForKey:_isFangChan? @"info_home_explain": @"info_job_companyintro"];
    }
    return cell;
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
