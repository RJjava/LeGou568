//
//  FindPasswordViewController.m
//  GouWu568
//
//  Created by echo13 on 15/10/5.
//  Copyright © 2015年 echo. All rights reserved.
//

#import "FindPasswordViewController.h"

@interface FindPasswordViewController ()

@end

@implementation FindPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
