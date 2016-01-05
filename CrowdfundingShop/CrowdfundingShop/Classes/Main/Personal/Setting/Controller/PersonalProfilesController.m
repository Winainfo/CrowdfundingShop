//
//  PersonalProfilesController.m
//  CrowdfundingShop
//  编辑个人资料
//  Created by 吴金林 on 16/1/4.
//  Copyright © 2016年 吴金林. All rights reserved.
//

#import "PersonalProfilesController.h"
#import <AVFoundation/AVFoundation.h>
#import <FSMediaPicker.h>
#import "UpdateNicknameController.h"
#import "UIView+RGSize.h"
#import "DBManager.h"
#import "Province.h"
#import "City.h"
#import "KTSelectDatePicker.h"

#define kScreen_Height      ([UIScreen mainScreen].bounds.size.height)
#define kScreen_Width       ([UIScreen mainScreen].bounds.size.width)
#define kScreen_Frame       (CGRectMake(0, 0 ,kScreen_Width,kScreen_Height))
@interface PersonalProfilesController ()<UIPickerViewDataSource,UIPickerViewDelegate,FSMediaPickerDelegate>

@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic, strong) UIView *maskView; // 遮罩层
@property (nonatomic, strong) UIView *supPickerView; // 装载pickerView
@property (nonatomic, strong) UIPickerView *myPickerView; // pickerView
@property (nonatomic, strong) UIView *smallView; // 装载button
@property (nonatomic, strong) Province *currentProvince;
@property (nonatomic,strong)  NSString *cityName;
@property (nonatomic,strong)  NSString *oldCityName;
@property (assign,nonatomic) BOOL flag;

@property (strong, nonatomic) KTSelectDatePicker *selectPick;//日期
@end

@implementation PersonalProfilesController

//隐藏和显示底部标签栏
-(void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航栏标题颜色和字体大小UITextAttributeFont:[UIFont fontWithName:@"Heiti TC" size:0.0]
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Menlo" size:16.0],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.title=@"编辑个人资料";
    //导航栏右侧按钮
    UIButton *leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[UIImage imageNamed:@"navbar_back"] forState:UIControlStateNormal];
    [leftBtn setImage:[UIImage imageNamed:@"navbar_back"] forState:UIControlStateSelected];
    leftBtn.frame=CGRectMake(-5, 5, 30, 30);
    [leftBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem=left;
    [self setExtraCellLineHidden:self.myTableView];
    //头像圆角
    self.userImageView.layer.cornerRadius=self.userImageView.frame.size.height/2.0;
    self.userImageView.layer.masksToBounds=YES;
    
    [self initViews];
    [self getData];
}
/**
 *  返回
 */
-(void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}
/**
 *  去掉多余的分割线
 *
 *  @param tableView <#tableView description#>
 */
- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}
/**
 *  该方法在视图跳转时被触发
 *
 *  @param segue  <#segue description#>
 *  @param sender <#sender description#>
 */
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"updateNickname"]) {
        id theSegue=segue.destinationViewController;
        [theSegue setValue:self.userNameLabel.text forKey:@"nickname"];
    }else if ([segue.identifier isEqualToString:@"updateQQNumber"]){
        id theSegue=segue.destinationViewController;
        [theSegue setValue:self.userQQLabel.text forKey:@"qqNumber"];
    }else if ([segue.identifier isEqualToString:@"updateAutograph"]){
        id theSegue=segue.destinationViewController;
        [theSegue setValue:self.userAutographLabel.text forKey:@"autograph"];
    }
}
/**
 *  修改头像
 *
 *  @param sender <#sender description#>
 */
- (IBAction)updateHeadClick:(UIButton *)sender {
    FSMediaPicker *mediaPicker = [[FSMediaPicker alloc] init];
    mediaPicker.mediaType = 0;
    mediaPicker.editMode = 0;
    mediaPicker.delegate = self;
    [mediaPicker showFromView:sender];
}
- (void)mediaPicker:(FSMediaPicker *)mediaPicker didFinishWithMediaInfo:(NSDictionary *)mediaInfo
{
    if (mediaPicker.editMode == FSEditModeNone) {
        [self.userImageView setImage:mediaInfo.originalImage];
    }else {
        [self.userImageView setImage:mediaInfo.originalImage];
    }
}

/**
 *  修改性别
 *
 *  @param sender <#sender description#>
 */
- (IBAction)updateSexClick:(UIButton *)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle: UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
    }];
    
    UIAlertAction *maleAction = [UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        self.userSexLabel.text=@"男";
    }];
    UIAlertAction *femaleAction = [UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        self.userSexLabel.text=@"女";
    }];
    UIAlertAction *secrecyAction = [UIAlertAction actionWithTitle:@"保密" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        self.userSexLabel.text=@"保密";
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:maleAction];
    [alertController addAction:femaleAction];
    [alertController addAction:secrecyAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}
#pragma mark 城市
/**城市选择*/
- (IBAction)chooseCity:(UIButton *)sender {
    UIButton *btn = (UIButton *)sender;
    switch (btn.tag) {
        case 100:{
            _flag=true;
            [self.supPickerView addSubview:self.smallView];
            [self.view addSubview:self.maskView];
            [self.view addSubview:self.supPickerView];
            self.maskView.alpha = 0;
            self.supPickerView.top = self.view.height;
            
            [UIView animateWithDuration:0.3 animations:^{
                self.maskView.alpha = 0.3;
                self.supPickerView.bottom = self.view.height;
            }];
        }break;
        case 101:{
            _flag=false;
            [self.supPickerView addSubview:self.smallView];
            [self.view addSubview:self.maskView];
            [self.view addSubview:self.supPickerView];
            self.maskView.alpha = 0;
            self.supPickerView.top = self.view.height;
            [UIView animateWithDuration:0.3 animations:^{
                self.maskView.alpha = 0.3;
                self.supPickerView.bottom = self.view.height;
            }];
        }break;
            
        default:break;
    }
}

- (void) getData
{
    [[DBManager sharedDBManager] openDB];
    [[DBManager sharedDBManager] disposeProData];
    [[DBManager sharedDBManager] closeDB];
    self.currentProvince = [[DBManager sharedDBManager].allData objectAtIndex:0];
}
- (void) initViews
{
    self.maskView = [[UIView alloc] initWithFrame:kScreen_Frame];
    self.maskView.backgroundColor = [UIColor blackColor];
    self.maskView.alpha = 0;
    [self.maskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideMyPicker)]];
    
    self.supPickerView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreen_Height * 0.6, kScreen_Width, kScreen_Height * 0.45)];
    self.supPickerView.backgroundColor = [UIColor whiteColor];
    
    self.myPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 50, kScreen_Width, 200)];
    self.myPickerView.delegate = self;
    self.myPickerView.dataSource = self;
    [self.supPickerView addSubview:_myPickerView];
    
    self.smallView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 50)];
    self.smallView.backgroundColor = [UIColor colorWithRed:246.0/255.0 green:246.0/255.0 blue:246.0/255.0 alpha:1];
    
    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sureButton.frame = CGRectMake(kScreen_Width - 60, 0, 50, 50);
    sureButton.titleLabel.font = [UIFont systemFontOfSize: 22];
    [sureButton setTitle:@"确定" forState:UIControlStateNormal];
    [sureButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [sureButton addTarget:self action:@selector(makeSure) forControlEvents:UIControlEventTouchUpInside];
    [self.smallView addSubview:sureButton];
    
    UIButton *cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancleButton.frame = CGRectMake(10, 0, 50, 50);
    cancleButton.titleLabel.font = [UIFont systemFontOfSize: 22];
    [cancleButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancleButton addTarget:self action:@selector(makeCancel) forControlEvents:UIControlEventTouchUpInside];
    [self.smallView addSubview:cancleButton];
    
}

- (void) hideMyPicker
{
    [UIView animateWithDuration:0.3 animations:^{
        self.maskView.alpha = 0;
        self.supPickerView.top = self.view.height;
    } completion:^(BOOL finished) {
        [self.maskView removeFromSuperview];
        [self.supPickerView removeFromSuperview];
    }];
}

- (void) makeSure
{
    if (_flag) {
        self.userDomicileLabel.text=[NSString stringWithFormat:@"%@ %@",self.currentProvince.proName,self.cityName];
    }else{
        self.userHometownLabel.text=[NSString stringWithFormat:@"%@ %@",self.currentProvince.proName,self.cityName];
    }
     self.currentProvince = [[DBManager sharedDBManager].allData objectAtIndex:0];
    [self hideMyPicker];
}

- (void) makeCancel
{
    [self hideMyPicker];
}

#pragma mark - UIPickerViewDelegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 2;
    
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    if (component == 0) {
        return [DBManager sharedDBManager].allData.count;
    }
    else
    {
        if (self.currentProvince.citys.count == 1) {
            return ((City *)[self.currentProvince.citys objectAtIndex:0]).zones.count;
        }else{
            return self.currentProvince.citys.count;
        }
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return ((Province *)[[DBManager sharedDBManager].allData objectAtIndex:row]).proName;
    }
    else
    {
        if (self.currentProvince.citys.count == 1) {
            self.cityName=[((City *)[self.currentProvince.citys objectAtIndex:0]).zones objectAtIndex:row];
            return [((City *)[self.currentProvince.citys objectAtIndex:0]).zones objectAtIndex:row];
        }else{
            self.cityName=((City *)[self.currentProvince.citys objectAtIndex:row]).cityName;
            return ((City *)[self.currentProvince.citys objectAtIndex:row]).cityName;
        }
    }
}

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        self.currentProvince = [[DBManager sharedDBManager].allData objectAtIndex:row];
        [pickerView reloadComponent:1];
        [pickerView selectRow:0 inComponent:1 animated:YES];
    }
}
#pragma date 出生年月
/**
 *  日期
 *
 *  @param sender <#sender description#>
 */
- (IBAction)chooseDateTime:(id)sender {
    
    _selectPick = [[KTSelectDatePicker alloc] init];
    _selectPick.isBeforeTime = YES;
    _selectPick.datePickerMode = UIDatePickerModeDate;
    __weak typeof(self) weakSelf = self;
    [_selectPick didFinishSelectedDate:^(NSDate *selectedDate) {
        //实例化一个NSDateFormatter对象
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //设定时间格式,这里可以设置成自己需要的格式
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        //用[NSDate date]可以获取系统当前时间
        NSString *currentDateStr = [dateFormatter stringFromDate:selectedDate];
        NSString *string = [NSString stringWithFormat:@"%@",currentDateStr];
        weakSelf.userBrithdayLabel.text = string;
    }];
}

@end
