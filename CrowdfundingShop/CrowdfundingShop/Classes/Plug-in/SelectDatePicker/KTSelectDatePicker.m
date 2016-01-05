//
//  KTSelectDatePicker.m
//  KTSelectDatePicker
//
//  Created by hcl on 15/10/9.
//  Copyright (c) 2015年 hcl. All rights reserved.
//

#import "KTSelectDatePicker.h"

#define kWinH self.view.frame.size.height
#define kWinW self.view.frame.size.width

// pickerView高度
#define kPVH (kWinH*0.35>230 ? 230:(kWinH*0.35<200 ? 200:kWinH*0.35))

@interface KTSelectDatePicker()
@property (strong, nonatomic) UIView *view;
@property (strong, nonatomic) UIButton *bgButton;
@property (strong, nonatomic) KTSelectPickerView *pickerView;

@property (strong, nonatomic) NSDate *selectDate;
@property (strong, nonatomic) DataTimeSelect selectBlock;
@end

@implementation KTSelectDatePicker

- (instancetype)init
{
    if (self = [super init]) {
        _view = [[UIApplication sharedApplication].delegate window].rootViewController.view;

        //半透明背景按钮
        _bgButton = [[UIButton alloc] init];
        [_view addSubview:_bgButton];
        [_bgButton addTarget:self action:@selector(dismissDatePicker) forControlEvents:UIControlEventTouchUpInside];
        _bgButton.backgroundColor = [UIColor blackColor];
        _bgButton.alpha = 0.0;
        _bgButton.frame = CGRectMake(0, 0, kWinW, kWinH);
        
        //时间选择View
        _pickerView = [[NSBundle mainBundle] loadNibNamed:@"KTSelectPickerView" owner:self options:nil].lastObject;
        [_view addSubview:_pickerView];
        _pickerView.frame = CGRectMake(0, kWinH, kWinW, kPVH);
        [_pickerView.cancleBtn addTarget:self action:@selector(dismissDatePicker) forControlEvents:UIControlEventTouchUpInside];
        [_pickerView.confirmBtn addTarget:self action:@selector(confirmBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_pickerView.datePicker addTarget:self action:@selector(datePickerValueChange:) forControlEvents:UIControlEventValueChanged];
        
        //DatePicker属性设置
        _selectDate = [NSDate date];
        _pickerView.datePicker.date = _selectDate;
        _pickerView.datePicker.minimumDate = _selectDate;
        _pickerView.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
        
        [self pushDatePicker];
    }
    return self;
}

- (void)setDatePickerMode:(UIDatePickerMode)datePickerMode
{
    _pickerView.datePicker.datePickerMode = datePickerMode;
}

- (void)setIsBeforeTime:(BOOL)isBeforeTime
{
    if (isBeforeTime) {
        [_pickerView.datePicker setMinimumDate:[NSDate dateWithTimeIntervalSince1970:0]];
    }
    else {
        [_pickerView.datePicker setMinimumDate:[NSDate date]];
    }
}

- (void)didFinishSelectedDate:(DataTimeSelect)selectDataTime
{
    _selectBlock = selectDataTime;
}

//DatePicker值改变
- (void)datePickerValueChange:(id)sender
{
    _selectDate = [sender date];
}

//确定
- (void)confirmBtnClick:(id)sender
{
    if (_selectBlock) {
        _selectBlock(_selectDate);
    }
    [self dismissDatePicker];
}

//出现
- (void)pushDatePicker
{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.pickerView.frame = CGRectMake(0, kWinH - kPVH, kWinW, kPVH);
        weakSelf.bgButton.alpha = 0.2;
    }];
}

//消失
- (void)dismissDatePicker
{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.pickerView.frame = CGRectMake(0, kWinH, kWinW, kPVH);
        weakSelf.bgButton.alpha = 0.0;
    } completion:^(BOOL finished) {
        [weakSelf.pickerView removeFromSuperview];
        [weakSelf.bgButton removeFromSuperview];
    }];
}

@end
