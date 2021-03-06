//
//  MottoController.h
//  BrickMan
//
//  Created by 段永瑞 on 16/7/24.
//  Copyright © 2016年 BrickMan. All rights reserved.
//

#import "BaseViewController.h"

@interface MottoController : BaseViewController
@property (strong, nonatomic) NSString *mottoString;
@property (copy, nonatomic) void(^updateBlock)(NSString *value);

@end
