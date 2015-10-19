//
//  FaXianTypeViewController.m
//  GouWu568
//
//  Created by echo13 on 15/10/17.
//  Copyright (c) 2015年 echo. All rights reserved.
//

#import "FaXianTypeViewController.h"

@interface FaXianTypeViewController ()
@property (strong, nonatomic) NSMutableArray *typeNameArr;//scrollView中要显示的类型名字数组
@property (strong, nonatomic) NSMutableArray *typeListArr;//tableView中显示的类型列表数组（该数组中存的是list数组）

@end

@implementation FaXianTypeViewController



- (void)viewDidLoad{
    [super viewDidLoad];
    _typeNameArr = [NSMutableArray array];
    _typeListArr = [NSMutableArray array];
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView *topShadowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 44, kScreenSizeWith, 5)];
    [topShadowImageView setImage:[UIImage imageNamed:@"top_background_shadow.png"]];
    [self.view addSubview:topShadowImageView];
    [self setData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setData{
    for (NSDictionary *dicTemp01 in _typeArr) {
        [_typeNameArr addObject:[dicTemp01 objectForKey:@"info_type_name"]];
    }
    
    
//    dispatch_group_t ddd = dispatch_group_create();
//    dispatch_queue_t  ddd222 = dispatch_queue_create("111", 0);
//    
//    
//    dispatch_group_async(ddd, ddd222, ^{
//        dispatch_group_notify(<#dispatch_group_t group#>, <#dispatch_queue_t queue#>, ^{
//            <#code#>
//        })
//    });
    
    
    
    
    for (int i; i < _typeArr.count; i++) {
        NSString *getTypeStr = [NSString stringWithFormat:CONTENTS_URL_FaXianType,[[_typeArr objectAtIndex:i] objectForKey:@"info_type_pid"],[[_typeArr objectAtIndex:i] objectForKey:@"info_type_id"]];
        [HttpTools getWithURL:getTypeStr params:nil success:^(id json) {
            NSDictionary *dicTemp = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingMutableContainers error:nil];
            [_typeListArr addObject:[dicTemp objectForKey:@"listInfo"]];
            if (_typeListArr.count == _typeArr.count) {
                SVTopScrollView *topScrollView = [SVTopScrollView shareInstance];
                SVRootScrollView *rootScrollView = [SVRootScrollView shareInstance];
                
                topScrollView.nameArray = _typeNameArr;
                rootScrollView.viewNameArray = _typeListArr;
                
                [self.view addSubview:topScrollView];
                [self.view addSubview:rootScrollView];
                
                [topScrollView initWithNameButtons];
                [rootScrollView initWithViews];
            }
        } failure:^(NSError *error) {
            NSLog(@"%@",error.description);
        }];
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
#pragma mark - TableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *IdentCell = @"viewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IdentCell];
    if (!cell) {
        cell = [[UITableViewCell alloc] init];
        cell.backgroundColor = [UIColor orangeColor];
    }
    return cell;
}
@end
