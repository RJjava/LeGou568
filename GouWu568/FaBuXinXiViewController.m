//
//  FaBuXinXiViewController.m
//  GouWu568
//
//  Created by echo13 on 15/10/9.
//  Copyright (c) 2015年 echo. All rights reserved.
//

#import "FaBuXinXiViewController.h"

@interface FaBuXinXiViewController ()

@end

@implementation FaBuXinXiViewController

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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
