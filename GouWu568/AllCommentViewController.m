//
//  AllCommentViewController.m
//  GouWu568
//
//  Created by echo13 on 15/10/5.
//  Copyright © 2015年 echo. All rights reserved.
//

#import "AllCommentViewController.h"

@interface AllCommentViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableV;

@end

@implementation AllCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    NSLog(@"%@",_commentArr);
    _tableV.tableFooterView = [[UIView alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//TableView代理
//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = [_commentArr objectAtIndex:indexPath.row];
    NSString *strContent = [dic objectForKey:@"comment_content"];
    return 73-21+ [LZXHelper textHeightFromTextString:strContent width:359 fontSize:16.0];
}
//行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _commentArr.count;
}
//执行显示
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *IdentCell = @"AllCommentCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IdentCell forIndexPath:indexPath];
    if (cell) {
        NSDictionary *dic = [_commentArr objectAtIndex:indexPath.row];
        UILabel *userLab = (UILabel *)[cell viewWithTag:101];
        UILabel *timeLab = (UILabel *)[cell viewWithTag:102];
        UILabel *contentLab = (UILabel *)[cell viewWithTag:103];
        userLab.text = [dic objectForKey:@"user_name"];
        timeLab.text = [dic objectForKey:@"comment_addtime"];
        contentLab.text = [dic objectForKey:@"comment_content"];
    }
    return cell;
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
