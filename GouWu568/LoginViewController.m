//
//  LoginViewController.m
//  GouWu568
//
//  Created by echo13 on 15/10/5.
//  Copyright © 2015年 echo. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()
@property (strong, nonatomic) IBOutlet UITextField *phoneNumTF;
@property (strong, nonatomic) IBOutlet UITextField *passWordTf;
@property (strong, nonatomic) IBOutlet UIButton *rememberNumBtn;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//记住账号按钮
- (IBAction)rememberNumBtnClick:(UIButton *)sender {
}

//登录按钮
- (IBAction)logInBtnClick:(UIButton *)sender {
    NSString *phoneNum = _phoneNumTF.text;
    NSString *passWord = _passWordTf.text;
    [HttpTools getWithURL:[NSString stringWithFormat:CONTENTS_URL_LogIn,phoneNum,passWord] params:nil success:^(id json) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingMutableContainers error:nil];
        //输出请求状态
        UIAlertView *alerV = [[UIAlertView alloc] initWithTitle:@"提示信息" message:[dic objectForKey:@"content"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alerV show];
        //如果修改成功则返回上个界面
        if ([[dic objectForKey:@"status"] isEqualToString:@"1"]) {//如果登录成功
            //返回的用户信息
            NSDictionary *userDic = [dic objectForKey:@"userinfo"];
            userDic = [Tools removeNullFromDic:userDic];//词典去空值
            [Tools logIn:userDic];//将用户信息词典写入本地
            //返回到上个界面
            [self.navigationController popViewControllerAnimated:YES];
        }
        
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error.description);
    }];
    
}

//返回
- (IBAction)backBtnClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
