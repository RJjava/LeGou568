//
//  HeadViewShouYe.m
//  GouWu568
//
//  Created by echo13 on 15/9/25.
//  Copyright © 2015年 echo. All rights reserved.
//

#import "HeadViewShouYe.h"

@implementation HeadViewShouYe
//重写系统方法
-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.frame = CGRectMake(0, 0, kScreenSize.width, 40);
        //自定义的addContentView方法
        [self addContentView];
        
    }
    return self;
}
//设置视图
- (void)addContentView{
    //设置背景图
    UIImageView *imageVTemp = [[UIImageView alloc] initWithFrame:self.bounds];
    imageVTemp.image = [UIImage imageNamed:@"chat_bottom_bg@2x.png"];
    [self addSubview:imageVTemp];
    //设置图标
    _tuBiao = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 20, 20)];
    [_tuBiao setBackgroundColor:[UIColor clearColor]];
    [self addSubview:_tuBiao];
    //设置name
    _headNameLab = [[UILabel alloc] initWithFrame:CGRectMake(40, 10, 100, 20)];
    _headNameLab.backgroundColor = [UIColor clearColor];
    _headNameLab.textColor = [UIColor blackColor];
    [self addSubview:_headNameLab];
    //设置方向
    _fangXiangImageV = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenSize.width-25, 15, 10, 10)];
    _fangXiangImageV.image = [UIImage imageNamed:@"arrow_up.png"];
    [self addSubview:_fangXiangImageV];
    //设置点击button
    _headBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_headBtn setBackgroundColor:[UIColor redColor]];
    [_headBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _headBtn.frame = self.bounds;
//    [self addSubview:_headBtn];
    
}
- (void)setDic:(NSDictionary *)dic{
    //设置图标
    NSString *tubiaoStr = [dic objectForKey:@"company_type_ico"];
    NSString *tubiaoUrl = [NSString stringWithFormat:@"%@%@",CONTENTS_URL_ROOT,tubiaoStr];
    [self.tuBiao sd_setImageWithURL:[NSURL URLWithString:tubiaoUrl] placeholderImage:[UIImage imageNamed:@"net_error_icon.png"]];
    //设置组名
    self.headNameLab.text = [dic objectForKey:@"company_type_name"];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
