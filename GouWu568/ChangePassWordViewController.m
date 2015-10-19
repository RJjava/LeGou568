//
//  ChangePassWordViewController.m
//  GouWu568
//
//  Created by echo13 on 15/10/10.
//  Copyright (c) 2015年 echo. All rights reserved.
//

#import "ChangePassWordViewController.h"

@interface ChangePassWordViewController ()
@property (strong, nonatomic) IBOutlet UITextField *oldPassWordTF;
@property (strong, nonatomic) IBOutlet UITextField *changedPassWordTF;
@property (strong, nonatomic) IBOutlet UITextField *changedPassWordTF2;


@end

@implementation ChangePassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    if ([_changedPassWordTF.text isEqualToString:_changedPassWordTF2.text]) {
        //获取当前登录用户的user_id
        NSString *changePassUrl = [NSString stringWithFormat:CONTENTS_URL_ChangePassWord,[[Tools getUser] objectForKey:@"user_id"],_oldPassWordTF.text,_changedPassWordTF.text,_changedPassWordTF2.text];
        [HttpTools getWithURL:changePassUrl params:nil success:^(id json) {
            NSDictionary *dicTemp = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingMutableContainers error:nil];
            //输出请求状态
            UIAlertView *alerV = [[UIAlertView alloc] initWithTitle:@"提示信息" message:[dicTemp objectForKey:@"content"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alerV show];
            //如果修改成功则返回上个界面
            if ([[dicTemp objectForKey:@"status"] isEqualToString:@"1"]) {
                [self.navigationController popViewControllerAnimated:YES];
            }
        } failure:^(NSError *error) {
            NSLog(@"%@",error.description);
        }];
    }else{
        UIAlertView *alerV = [[UIAlertView alloc] initWithTitle:@"提示信息" message:@"请输入相同的新密码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alerV show];
    }
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
