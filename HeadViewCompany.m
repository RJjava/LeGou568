//
//  HeadViewCompany.m
//  GouWu568
//
//  Created by echo13 on 15/9/29.
//  Copyright © 2015年 echo. All rights reserved.
//

#import "HeadViewCompany.h"

@implementation HeadViewCompany

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
    //设置左标签
    _leftLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, 40)];
    _leftLab.text = @"|";
    _leftLab.textColor = [UIColor blueColor];
    [self addSubview:_leftLab];
    //设置中间标签
    _midLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, 40)];
    _midLab.textColor = [UIColor blackColor];
    [self addSubview:_midLab];
    //设置右标签
    _rightLab = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-110, 0, 10, 40)];
    _rightLab.textColor = [UIColor lightGrayColor];
    [self addSubview:_rightLab];
    //设置右button
    _rightBtn = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-100, 0,  100, 40)];
    _rightBtn.titleLabel.textColor = [UIColor blackColor];
    [self addSubview:_rightBtn];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
