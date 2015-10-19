//
//  ChangeMessageViewController.m
//  GouWu568
//
//  Created by echo13 on 15/10/9.
//  Copyright (c) 2015年 echo. All rights reserved.
//

#import "ChangeMessageViewController.h"

@interface ChangeMessageViewController ()
@property (strong, nonatomic) IBOutlet UITextField *textF;

@end

@implementation ChangeMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _textF.text = _textFiledStr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//返回按钮
- (IBAction)backBtnClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
//确定btn点击事件
- (IBAction)subBtnClick:(UIButton *)sender {
    NSDictionary *dicTemp = [Tools getUser];
    [dicTemp setValue:_textF.text forKey:_changeKeyStr];
    NSString *changeMessageUrl = [NSString stringWithFormat:CONTENTS_URL_ChangeMessage,[dicTemp objectForKey:@"user_id"],[dicTemp objectForKey:@"user_name"],[dicTemp objectForKey:@"user_qq"],[dicTemp objectForKey:@"user_mail"],[dicTemp objectForKey:@"user_phone"],[dicTemp objectForKey:@"user_address"],[dicTemp objectForKey:@"user_phone2"],[dicTemp objectForKey:@"user_address2"],[dicTemp objectForKey:@"user_sex"],[dicTemp objectForKey:@"user_birthday"]];
    //get请求有汉字要转换编码格式
    [HttpTools getWithURL:[changeMessageUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] params:nil success:^(id json) {//请求返回的用户信息不是自己的，只需获得请求是否成功即可
        NSDictionary *dicTemp2 = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingMutableContainers error:nil];
        //输出请求状态
        UIAlertView *alerV = [[UIAlertView alloc] initWithTitle:@"提示信息" message:[dicTemp2 objectForKey:@"content"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alerV show];
        if ([[dicTemp2 objectForKey:@"status"] isEqualToString:@"1"]) {//如果修改成功
            [Tools logIn:dicTemp];//重新设置本地存储的用户信息
            [self.navigationController popViewControllerAnimated:YES];//返回上一个界面
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error.description);
    }];
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
