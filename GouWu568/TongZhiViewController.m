//
//  TongZhiViewController.m
//  GouWu568
//
//  Created by echo13 on 15/10/9.
//  Copyright (c) 2015年 echo. All rights reserved.
//

#import "TongZhiViewController.h"

@interface TongZhiViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableV;

@end

@implementation TongZhiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"%@",_tongZhiArr);
    _tableV.tableFooterView = [[UIView alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//返回按钮
- (IBAction)backBtnClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - TableView代理
//行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _tongZhiArr.count;
}
//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dicTemp = [_tongZhiArr objectAtIndex:indexPath.row];
    NSString *contentStr = [dicTemp objectForKey:@"notice_content"];
    return 74-21+[LZXHelper textHeightFromTextString:contentStr width:359 fontSize:17];
}
//执行显示
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *IdentCell = @"TongZhiCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IdentCell forIndexPath:indexPath];
    UILabel *neiRongLab = (UILabel *)[cell viewWithTag:101];
    UILabel *dateLab = (UILabel *)[cell viewWithTag:102];
    NSDictionary *dicTemp = [_tongZhiArr objectAtIndex:indexPath.row];
    neiRongLab.text = [dicTemp objectForKey:@"notice_content"];
    dateLab.text = [dicTemp objectForKey:@"notice_addtime"];
    
    return cell;
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
