//
//  AddCompanyCommentViewController.m
//  GouWu568
//
//  Created by echo13 on 15/9/28.
//  Copyright © 2015年 echo. All rights reserved.
//

#import "AddCompanyCommentViewController.h"

@interface AddCompanyCommentViewController ()
@property (strong, nonatomic) IBOutlet UITextField *commentTF;

@end

@implementation AddCompanyCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//添加评论
- (IBAction)addCommenBtnClick:(UIButton *)sender {
    //获取评论内容
    NSString *commentStr = _commentTF.text;
    //获取用户id
    NSDictionary *userDic = [Tools getUser];
    NSString *userId = [userDic objectForKey:@"user_id"];
    //获取店铺id
    NSString *companyId = _companyM.company_id;
    //设置post请求的数据dic
    NSDictionary *postDic = [NSDictionary dictionaryWithObjectsAndKeys:userId,@"user_id",companyId,@"company_id",commentStr,@"comment_content", nil];
    [HttpTools postWithURL:CONTENTS_URL_AddComment params:postDic success:^(id responseObject) {
//        NSDictionary *commentDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//        //返回添加评论的状态
//        NSString *status = [commentDic objectForKey:@"status"];
//        //返回添加评论的结果描述（例如：添加成功）
//        NSString *content = [commentDic objectForKey:@"content"];
        [self.navigationController popViewControllerAnimated:YES];
        
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
