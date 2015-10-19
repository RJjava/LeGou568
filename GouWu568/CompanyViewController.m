//
//  CompanyViewController.m
//  GouWu568
//
//  Created by echo13 on 15/9/28.
//  Copyright © 2015年 echo. All rights reserved.
//

#import "CompanyViewController.h"
#import "AllCommentViewController.h"
#import "LoginViewController.h"
#import "AddCompanyCommentViewController.h"
#import "ReportCompanyViewController.h"
#import "UMSocial.h"

@interface CompanyViewController ()<UITabBarDelegate, UITableViewDataSource>
//店铺名称
@property (strong, nonatomic) IBOutlet UILabel *companyNameLab;
//展示店铺图片的scrollView
@property (strong, nonatomic) IBOutlet UIScrollView *imageScrollView;
@property (strong, nonatomic) IBOutlet UITableView *tableV;

@property (strong, nonatomic) NSArray *proArr;//产品数组


@end

@implementation CompanyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //    [self hidesBottomBarWhenPushed];
    _proArr = [[NSArray alloc] init];
//    [self addCustomTabBar];//自定义TabBar
    _tableV.tableFooterView = [[UIView alloc] init];
    [self showCopany];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//添加自定义TabBar
- (void)addCustomTabBar{
    //设置背景view
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-49, [UIScreen mainScreen].bounds.size.width, 49)];
    backView.backgroundColor = [UIColor clearColor];
    //    NSArray *tabBarNameArr = @[@"添加评论",@"所有评论",@"分享",@"举报"];
    //    NSArray *tabBarPicArr = @[@"qydp_pinglun.png",@"qydp_chakan.png",@"qydp_share.png",@"qydp_jubao.png"];
    [self.view addSubview:backView];
    for (int i = 0; i<4; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        CGFloat btnWith = [UIScreen mainScreen].bounds.size.width/4;//button的宽
        button.frame = CGRectMake(btnWith*i, 0, btnWith, 49);
        button.backgroundColor = [UIColor clearColor];
        //        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        //        [button setTitle:tabBarNameArr[i] forState:UIControlStateNormal];//设置标题
        //        [button setBackgroundImage:[UIImage imageNamed:tabBarPicArr[i]] forState:UIControlStateNormal];//设置背景图片
        [button addTarget:self action:@selector(buttonClick:)forControlEvents:UIControlEventTouchUpInside];
        button.tag = i;
        [backView addSubview:button];
        
    }
    //    _btnView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, ([UIScreen mainScreen].bounds.size.width-50)/4, 30)];
    //    _btnView.backgroundColor = [UIColor blueColor];
    //    _btnView.alpha = 0.5;
    //    [backView addSubview:_btnView];
}
//显示详细店铺信息
- (void)showCopany{
    //设置产品数组
    _proArr = _companyM.company_pro;
    //设置标题
    _companyNameLab.text = _companyM.company_shortname;
    
    //设置展示图片的scrollView
    NSArray *scroViewImageArr = _companyM.company_imgs_new;
    //先清空之前_backScrollView
    for (UIImageView *imageV in _imageScrollView.subviews) {
        [imageV removeFromSuperview];
    }
    //设置ScrollView的contentSize值
    _imageScrollView.contentSize = CGSizeMake(_imageScrollView.frame.size.width * scroViewImageArr.count, _imageScrollView.frame.size.height);
    for (int i = 0; i<scroViewImageArr.count; i++) {
        NSDictionary *dic = [scroViewImageArr objectAtIndex:i];
        NSString *adStr = [dic objectForKey:@"img"];
        //        NSLog(@"%@",adStr);
        NSString *adUrl = [[NSString alloc] initWithFormat:@"%@%@",CONTENTS_URL_ROOT,adStr];
        UIImageView *imageViewTemp = [[UIImageView alloc] initWithFrame:CGRectMake(i*_imageScrollView.frame.size.width, 0, _imageScrollView.frame.size.width, _imageScrollView.frame.size.height)];
        [imageViewTemp sd_setImageWithURL:[NSURL URLWithString:adUrl] placeholderImage:[UIImage imageNamed:@"net_error_icon.png"]];
        [_imageScrollView addSubview:imageViewTemp];
        
    }
}
//行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([_companyM.company_video isEqualToString:@""]) {
        return 7+_proArr.count;
    }
    return 7+_proArr.count+1;
}
//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 4){//店铺介绍的具体内容
        NSString *strTemp = _companyM.company_about;
        
        return 44-17+[LZXHelper textHeightFromTextString:strTemp width:325 fontSize:16];
    }else if(indexPath.row >= 7){
        return [_companyM.company_video isEqualToString:@""]? 71:44;
    }
    return 44;
}
//执行显示
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdent = [[NSString alloc] init];
    if (indexPath.row <= 5) {
        CellIdent = [NSString stringWithFormat:@"ConTentCell%ld",(long)indexPath.row+1];
    }else if(indexPath.row == 6 ){
        CellIdent = [_companyM.company_video isEqualToString:@""]? @"ConTentCell8":@"ConTentCell7";
    }else if(indexPath.row == 7 ){
        CellIdent = [_companyM.company_video isEqualToString:@""]? @"ConTentCell9" : @"ConTentCell8";
    }else if(indexPath.row >= 8){
        CellIdent = @"ConTentCell9";
    }

    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdent forIndexPath:indexPath];
    
    
    
    if (indexPath.row == 0) {
        UILabel *lab1 = (UILabel *)[cell viewWithTag:101];
        lab1.text = [NSString stringWithFormat:@"%@人浏览",_companyM.company_hits];
    }else if (indexPath.row == 1){
        UILabel *lab1 = (UILabel *)[cell viewWithTag:101];
        UILabel *lab2 = (UILabel *)[cell viewWithTag:102];
        lab1.text = _companyM.company_name;
        lab2.text = _companyM.company_address;
    }else if (indexPath.row == 2){
        UILabel *lab1 = (UILabel *)[cell viewWithTag:101];
        //            UIButton *btn1 = (UIButton *)[cell viewWithTag:102];
        lab1.text = [NSString stringWithFormat:@"%@:%@",_companyM.company_contact,_companyM.company_tel];
    }else if (indexPath.row == 3){
        
    }else if (indexPath.row == 4){
        UILabel *lab1 = (UILabel *)[cell viewWithTag:101];
        lab1.text = _companyM.company_about;
    }else if (indexPath.row == 5){
        if (![_companyM.company_video isEqualToString:@""]) {
            UILabel *lab1 = (UILabel *)[cell viewWithTag:101];
            lab1.text = @"有视频";
        }
    }else if ((indexPath.row == 7&&[_companyM.company_video isEqualToString:@""])||indexPath.row >=8){
        if ([_companyM.company_video isEqualToString:@""]) {
            long index = [_companyM.company_video isEqualToString:@""]? indexPath.row-7:indexPath.row-8;
            NSArray *proArr = _companyM.company_pro;
            NSMutableDictionary *dicTemp = [proArr objectAtIndex:index];
            
            
            UIImageView *imageV = (UIImageView *)[cell viewWithTag:101];
            NSString *imageStr = [NSString stringWithFormat:@"%@%@",CONTENTS_URL_ROOT,[dicTemp objectForKey:@"company_pro_imgsrc"]];
            [imageV sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:[UIImage imageNamed:@"net_error_icon.png"]];
            UILabel *lab1 = (UILabel *)[cell viewWithTag:102];
            lab1.text = [dicTemp objectForKey:@"company_pro_title"];
            UILabel *lab2 = (UILabel *)[cell viewWithTag:103];
            lab2.text = [dicTemp objectForKey:@"company_pro_content"];
            UILabel *lab3 = (UILabel *)[cell viewWithTag:104];
            lab3.text = [dicTemp objectForKey:@"company_pro_remarks"];
            
        }
    }
    return cell;
}
//自定的TabBar Button点击事件
- (void)buttonClick:(UIButton *)btn{
    
}
- (IBAction)backBtnClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
//添加评论按钮
- (IBAction)AddCommentBtnClick:(UIButton *)sender {
    if ([Tools isLogin]) {//如果已经登录跳转到评论页面
        [self performSegueWithIdentifier:@"AddComment" sender:self];
    }else{//如果尚未登录跳转到登陆界面
        [self performSegueWithIdentifier:@"LogIn" sender:self];
    }
}
//所有评论
- (IBAction)AllCommentBtnClick:(UIButton *)sender {
    [self performSegueWithIdentifier:@"AllComment" sender:self];
}
//分享按钮（系统的是：@"53290df956240b6b4a0084b3"）
- (IBAction)ShareBtnClick:(UIButton *)sender {
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:CONTENTS_URL_YouMengAppKey
                                      shareText:@"你要分享的文字"
                                     shareImage:[UIImage imageNamed:@"icon.png"]
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQzone,UMShareToQQ,UMShareToRenren,UMShareToDouban,UMShareToEmail,UMShareToSms,UMShareToFacebook,UMShareToTwitter,nil]
                                       delegate:nil];
}
//举报按钮
- (IBAction)ReportBtnClick:(UIButton *)sender {
    if ([Tools isLogin]) {//如果已经登录跳转到举报页面
        [self performSegueWithIdentifier:@"Report" sender:self];
    }else{//如果尚未登录跳转到登陆界面
        [self performSegueWithIdentifier:@"LogIn" sender:self];
    }
    
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //跳转到添加评论的连线器
    if ([segue.destinationViewController isKindOfClass:[AddCompanyCommentViewController class]]) {
        AddCompanyCommentViewController *addCommentVC = segue.destinationViewController;
        addCommentVC.companyM = _companyM;
    }
    //跳转到所有评论的连线器
    if ([segue.destinationViewController isKindOfClass:[AllCommentViewController class]]) {
        AllCommentViewController *allCommentVC = segue.destinationViewController;
        allCommentVC.commentArr = _companyM.company_comment;
    }
    //跳转到分享的连线器
    
    //跳转到举报的连线器
    if ([segue.destinationViewController isKindOfClass:[ReportCompanyViewController class]]) {
//        ReportCompanyViewController *reportVC = segue.destinationViewController;
    }
    
    
    //跳转到登录的连线器
    if ([segue.destinationViewController isKindOfClass:[LoginViewController class]]) {
        
    }

}


@end
