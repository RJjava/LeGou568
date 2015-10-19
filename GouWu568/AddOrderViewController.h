//
//  AddOrderViewController.h
//  GouWu568
//
//  Created by echo13 on 15/10/8.
//  Copyright (c) 2015年 echo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddOrderViewController : UIViewController
@property (nonatomic, strong) NSMutableArray *goodsArr;
@property (nonatomic, strong) NSMutableArray *goodsCountArr;
@property (assign, nonatomic) BOOL isFromShopingCar;
@end
