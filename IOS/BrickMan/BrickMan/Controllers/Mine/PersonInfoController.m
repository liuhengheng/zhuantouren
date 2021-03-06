//
//  PersonInfoController.m
//  BrickMan
//
//  Created by 段永瑞 on 16/7/22.
//  Copyright © 2016年 BrickMan. All rights reserved.
//

#import "PersonInfoController.h"
#import "Mine_infoCell.h"
#import "HeadEditController.h"
#import "MottoController.h"
#import "ChangeUserInfoController.h"


#define kMaxLength 10
#define kMinLength 2

@interface PersonInfoController ()<UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate> {
    UIButton *_oldSelected;
}

@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) NSArray *titles;
/**
 *  自定义性别选择视图
 */
@property (nonatomic, strong) UIView *mySexSelection;
@property (nonatomic, strong) UIButton *male;
@property (nonatomic, strong) UIButton *female;

@end

@implementation PersonInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人资料";

    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"compose"] style:UIBarButtonItemStylePlain target:self action:@selector(compose:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.myTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    self.myTableView.rowHeight = [Mine_infoCell cellHeight] * kMineCellHeightRadio;
    self.myTableView.tableFooterView = [UIView new];
    [self.myTableView registerClass:[Mine_infoCell class] forCellReuseIdentifier:kCellIdentifier_Mine_infoCell];
    [self.view addSubview:self.self.myTableView];
    [self.myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.user = [BMUser getUserModel];
}

- (void)compose:(UIBarButtonItem *)sender {
    
}

#pragma mark - TableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Mine_infoCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_Mine_infoCell forIndexPath:indexPath];
    cell.titleLabel.text = self.titles[indexPath.row];
    if (indexPath.row == 0) {
        
        NSString *imagePath = self.user.userHead;
        [cell.subImgView sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:nil];
        [cell.subLabel setHidden:YES];
        [cell.subImgView setHidden:NO];
    } else {
        if (indexPath.row == 1) {
            
            cell.subLabel.text = self.user.userAlias;
        }else if(indexPath.row == 2) {
            cell.subLabel.text = self.user.userSexStr;
            cell.accessoryType = UITableViewCellAccessoryNone;
        }else if (indexPath.row == 3) {
            cell.subLabel.text = self.user.motto.length > 0 ? self.user.motto : @"路见不平,拍砖相助!";
        }
        [cell.subLabel setHidden:NO];
        [cell.subImgView setHidden:YES];
    }
    [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:kPaddingLeft];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    __weak typeof(self) weakSelf = self;
    switch (indexPath.row) {
        case 0: { //更改头像
            HeadEditController *headEdit = [[HeadEditController alloc]init];
            headEdit.updateBlock = ^(NSString *value){
                weakSelf.user.userHead = value;
                [weakSelf.myTableView reloadData];
            };
            NSString *imagePath = self.user.userHead;
            [headEdit.headImgView sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:nil];
            [self.navigationController pushViewController:headEdit animated:YES];
        }
            break;
        case 1: { //更改昵称
            ChangeUserInfoController *vc = [[ChangeUserInfoController alloc] init];
            __weak typeof(self) weakSelf = self;
            vc.updateBlock = ^(NSString *value){
                weakSelf.user.userAlias = value;
                [weakSelf.myTableView reloadData];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2: { //更改性别
//            [self presentMySexSelection];
        }
            break;
        case 3: { //更改座右铭
            MottoController *motto = [[MottoController alloc]init];
            motto.mottoString = self.user.motto.length > 0 ? self.user.motto : @"路见不平,拍砖相助!";
            motto.updateBlock = ^(NSString *value){
                weakSelf.user.motto = value;
                [weakSelf.myTableView reloadData];
            };
            [self.navigationController pushViewController:motto animated:YES];
        }
            break;
        default:
            break;
    }
}

#pragma mark - Custome View
- (void)presentMySexSelection {
    Mine_infoCell *cell = [self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    if ([cell.subLabel.text isEqualToString:@"男"]) {
        [self.male setImage:[UIImage imageNamed:@"man_sel"] forState:UIControlStateNormal];
        _oldSelected = self.male;
    } else {
        [self.female setImage:[UIImage imageNamed:@"woman_sel"] forState:UIControlStateNormal];
        _oldSelected = self.female;
    }
    self.mySexSelection = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
    self.mySexSelection.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.4];
    UIView *sexView = [[UIView alloc]init];
    sexView.layer.masksToBounds = YES;
    sexView.layer.cornerRadius = 10;
    sexView.backgroundColor = [UIColor whiteColor];
    sexView.bounds = CGRectMake(0, 0, kScreen_Width - 35, (kScreen_Width - 35) * 256/344 );
    sexView.center = self.mySexSelection.center;
    [self.mySexSelection addSubview:sexView];
    UILabel *label = [[UILabel alloc]init];
    label.text = @"选择性别";
    label.layer.borderWidth = 1.f;
    label.textAlignment = NSTextAlignmentCenter;
    label.layer.borderColor = [UIColor colorWithWhite:0.902 alpha:1.000].CGColor;
    [sexView addSubview:label];
    self.female.bounds = CGRectMake(0, 0, sexView.height * 140/256 - 20, sexView.height * 140/256);
    self.female.center = CGPointMake(sexView.width/4 + 30, sexView.height/2);
    self.female.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 20, -13);
    self.female.titleEdgeInsets = UIEdgeInsetsMake(self.female.height/2 + 20, -self.female.imageView.width/2 - 10 * self.female.imageView.width/20, 0, 0);
    self.male.bounds = CGRectMake(0, 0, sexView.height * 140/256 - 20, sexView.height * 140/256);
    self.male.center = CGPointMake(sexView.width*3/4 - 30, sexView.height/2);
    self.male.imageEdgeInsets = self.female.imageEdgeInsets;
    self.male.titleEdgeInsets = self.female.titleEdgeInsets;
    [sexView addSubview:self.male];
    [sexView addSubview:self.female];
    label.frame = CGRectMake(-1, -1, sexView.width + 2, self.female.top + 2);
    UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    cancel.frame = CGRectMake(0, self.female.bottom, sexView.width/2, sexView.height - self.female.bottom);
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    cancel.titleLabel.enabled = NO;
    [cancel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancel addTarget:self action:@selector(cancelSelection:) forControlEvents:UIControlEventTouchUpInside];
    [sexView addSubview:cancel];
    UIButton *confirm = [UIButton buttonWithType:UIButtonTypeCustom];
    confirm.frame = CGRectMake(sexView.width/2, self.female.bottom, sexView.width/2, sexView.height - self.female.bottom);
    [confirm setTitle:@"确定" forState:UIControlStateNormal];
    [confirm setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [confirm addTarget:self action:@selector(confirmSelection:) forControlEvents:UIControlEventTouchUpInside];
    [sexView addSubview:confirm];
    CALayer *horizontalLine = [[CALayer alloc]init];
    horizontalLine.frame = CGRectMake(0, cancel.top, sexView.width, 1);
    horizontalLine.backgroundColor = label.layer.borderColor;
    [sexView.layer addSublayer:horizontalLine];
    CALayer *verticalLine = [[CALayer alloc]init];
    verticalLine.backgroundColor = label.layer.borderColor;
    verticalLine.frame = CGRectMake(cancel.right - 0.5, cancel.top + 10, 1, cancel.height - 20);
    [sexView.layer addSublayer:verticalLine];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window.rootViewController.view addSubview:self.mySexSelection];
}

- (void)cancelSelection:(UIButton *)sender {
    [self.mySexSelection removeFromSuperview];
}

- (void)confirmSelection:(UIButton *)sender {
    NSString *sexString = _oldSelected.titleLabel.text;
    __weak typeof(self) weakSelf = self;
    [[BrickManAPIManager shareInstance] requestUpdateUserInfoWithParams:@{@"userId" : self.user.userId, @"userSexStr" : sexString} andBlock:^(id data, NSError *error) {
        if (data) {
            [weakSelf.mySexSelection removeFromSuperview];
            weakSelf.user.userSexStr = sexString;
            [weakSelf.myTableView reloadData];
            //刷新数据
            NSString *userId = [BMUser getUserModel].userId;
            [[BrickManAPIManager shareInstance] requestUserInfoWithParams:@{@"userId" : userId} andBlock:^(id data, NSError *error) {
                if (data) {
                    [BMUser saveUserInfo:data];
                }
            }];
        }
    }];
}

//控制最长输入长度,不允许输入emoji
- (void)textFiledEditChanged:(NSNotification *)notify {
    UITextField *textField = (UITextField *)notify.object;
    NSString *toBeString = textField.text;
    NSString *lang = [textField.textInputMode primaryLanguage]; // 键盘输入模式
    toBeString = [textField disable_emoji:toBeString];
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        //没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if(!position) {
            if (toBeString.length > kMaxLength) {
                textField.text = [toBeString substringToIndex:kMaxLength];
            }
        }
        //有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }else if (toBeString.length > kMaxLength) {
        textField.text = [toBeString substringToIndex:kMaxLength];
    } else {
        textField.text = toBeString;
    }
}

- (void)selectedSex:(UIButton *)sender {
    if (sender == _oldSelected) {
        return;
    }
    if (_oldSelected == self.male) {
        [_oldSelected setImage:[UIImage imageNamed:@"man_nor"] forState:UIControlStateNormal];
        [sender setImage:[UIImage imageNamed:@"woman_sel"] forState:UIControlStateNormal];
    } else {
        [_oldSelected setImage:[UIImage imageNamed:@"woman_nor"] forState:UIControlStateNormal];
        [sender setImage:[UIImage imageNamed:@"man_sel"] forState:UIControlStateNormal];
    }
    _oldSelected = sender;
}

#pragma mark - 懒加载
- (NSArray *)titles {
    if (!_titles) {
        _titles = @[@"我的头像",@"我的昵称",@"我的性别",@"座右铭"];
    }
    return _titles;
}

- (UIButton *)male {
    if (!_male) {
        _male = [UIButton buttonWithType:UIButtonTypeCustom];
        [_male setImage:[UIImage imageNamed:@"man_nor"] forState:UIControlStateNormal];
        [_male setTitle:@"男" forState:UIControlStateNormal];
        _male.titleLabel.font = [UIFont systemFontOfSize:13];
        [_male addTarget:self action:@selector(selectedSex:) forControlEvents:UIControlEventTouchUpInside];
        [_male setTitleColor:RGBCOLOR(100, 202, 234) forState:UIControlStateNormal];
        _male.adjustsImageWhenHighlighted = NO;
    }
    return _male;
}

- (UIButton *)female {
    if (!_female) {
        _female = [UIButton buttonWithType:UIButtonTypeCustom];
        [_female setImage:[UIImage imageNamed:@"woman_nor"] forState:UIControlStateNormal];
        [_female setTitle:@"女" forState:UIControlStateNormal];
        _female.titleLabel.font = [UIFont systemFontOfSize:13];
        [_female addTarget:self action:@selector(selectedSex:) forControlEvents:UIControlEventTouchUpInside];
        [_female setTitleColor:kNavigationBarColor forState:UIControlStateNormal];
        _female.adjustsImageWhenHighlighted = NO;
    }
    return _female;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
