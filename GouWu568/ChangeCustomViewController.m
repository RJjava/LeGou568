//
//  ChangeCustomViewController.m
//  GouWu568
//
//  Created by echo13 on 15/10/13.
//  Copyright (c) 2015年 echo. All rights reserved.
//

#import "ChangeCustomViewController.h"

@interface ChangeCustomViewController ()
@property (strong, nonatomic) IBOutlet UITextField *nameTF;//姓名
@property (strong, nonatomic) IBOutlet UITextField *phoneTF;//电话
@property (strong, nonatomic) IBOutlet UITextField *addressTF;//地址
@property (strong, nonatomic) IBOutlet UITextField *beiZhuTF;//备注



@end

@implementation ChangeCustomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _nameTF.text = [_customDic objectForKey:@"user_name"];
    _phoneTF.text = [_customDic objectForKey:@"user_phone"];
    _addressTF.text = [_customDic objectForKey:@"user_address"];
    _beiZhuTF.text = @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//确定btn点击事件
- (IBAction)subBtnClick:(UIButton *)sender {
    [_customDic setValue:_nameTF.text forKey:@"user_name"];
    [_customDic setValue:_phoneTF.text forKey:@"user_phone"];
    [_customDic setValue:_addressTF.text forKey:@"user_address"];
    [_customDic setValue:_beiZhuTF.text forKey:@"user_remarks"];
    //触发消息通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeCustomConfiger" object:_customDic];
    [self.navigationController popViewControllerAnimated:YES];
}
//返回按钮
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
