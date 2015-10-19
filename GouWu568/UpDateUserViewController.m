//
//  UpDateUserViewController.m
//  GouWu568
//
//  Created by echo13 on 15/10/9.
//  Copyright (c) 2015年 echo. All rights reserved.
//

#import "UpDateUserViewController.h"
#import "ChangeMessageViewController.h"

@interface UpDateUserViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableV;
//@property (strong, nonatomic) NSMutableDictionary *userDic;//用户信息dic
@property (strong, nonatomic) NSArray *titleArr;
@property (strong, nonatomic) NSArray *contentArr;
@property (assign, nonatomic) CGFloat indexPathRow;
@end

@implementation UpDateUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    _userDic = (NSMutableDictionary *)[Tools getUser];
    _titleArr = [[NSArray alloc] initWithObjects:@"用户名",@"性别",@"生日",@"手机号",@"QQ",@"地址",@"邮箱",@"备用号码",@"备用地址", nil];
    _contentArr = [[NSArray alloc] initWithObjects:@"user_name",@"user_sex",@"user_birthday",@"user_phone",@"user_qq",@"user_address",@"user_mail",@"user_phone2",@"user_address2",nil];
    _tableV.tableFooterView = [[UIView alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated{
    [_tableV reloadData];
}
//组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
//行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return section == 0?9:2;
}
//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
//头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section == 0?40:20;
    
}
//头设置
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *viewTemp = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
    viewTemp.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, [UIScreen mainScreen].bounds.size.width-8, 44)];
    lab.textColor = [UIColor blackColor];
    lab.backgroundColor = [UIColor clearColor];
    lab.font = [UIFont systemFontOfSize:15];
    lab.text = section == 0?[NSString stringWithFormat:@"你好：%@",[[Tools getUser] objectForKey:@"user_name"]]:@"";
    [viewTemp addSubview:lab];
    
    return viewTemp;
}
//执行显示
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *IdentCell = @"GeRenCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IdentCell forIndexPath:indexPath];
    if (indexPath.section == 0) {//第一个分组
        UILabel *titleLab = (UILabel *)[cell viewWithTag:101];//左侧label
        titleLab.text = [_titleArr objectAtIndex:indexPath.row];
        UILabel *contentLab = (UILabel *)[cell viewWithTag:102];//右侧label
        contentLab.text = [[Tools getUser] objectForKey:[_contentArr objectAtIndex:indexPath.row]];
    }else{
        UILabel *titleLab = (UILabel *)[cell viewWithTag:101];//左侧label
        titleLab.text = indexPath.row == 0?@"修改密码":@"安全退出";
        UILabel *contentLab = (UILabel *)[cell viewWithTag:102];//右侧label
        contentLab.text = @"";
    }
    
    return cell;
}
//cell点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        _indexPathRow = indexPath.row;
        [self performSegueWithIdentifier:@"ChangeMessageCell" sender:self];
    }else{
        if (indexPath.row == 0) {//修改密码
            [self performSegueWithIdentifier:@"ChangePassWordSegue" sender:self];
        }else{//退出登录
            [Tools logOut];
            UIAlertView *alerV = [[UIAlertView alloc] initWithTitle:@"提示信息" message:@"退出成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alerV show];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }
    
}
//保存btn点击事件
- (IBAction)saveBtnClick:(UIButton *)sender {
}
//返回按钮
- (IBAction)backBtnClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[ChangeMessageViewController class]]) {
        ChangeMessageViewController *changeMessageVC = segue.destinationViewController;
        changeMessageVC.changeKeyStr = [_contentArr objectAtIndex:_indexPathRow];
        changeMessageVC.textFiledStr = [NSString stringWithFormat:@"请输入修改的%@",[_titleArr objectAtIndex:_indexPathRow]];
    }
}


@end
