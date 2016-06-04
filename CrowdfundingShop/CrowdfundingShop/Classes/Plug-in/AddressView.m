//
//  AddressView.m
//  uipickerView
//
//  Created by wujianqiang on 15/12/28.
//  Copyright © 2015年 wujianqiang. All rights reserved.
//

#import "AddressView.h"

@interface AddressView ()<UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic, strong) NSMutableArray *provinces;
@property (nonatomic, strong) NSMutableArray *cityArray;    // 城市数据
@property (nonatomic, strong) NSMutableArray *areaArray;    // 区信息
@property (nonatomic, strong) NSMutableArray *selectedArray;

@property (nonatomic, strong) UIPickerView *pickerView;

@end

@implementation AddressView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init{
    self = [super init];
    if (self) {
        self.bounds = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 200);
        self.pickerView = [[UIPickerView alloc] initWithFrame:self.bounds];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"area" ofType:@"plist"];
        NSArray *provinceArray = [[NSArray alloc] initWithContentsOfFile:path];
        [provinceArray enumerateObjectsUsingBlock:^(NSDictionary  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.provinces addObject:obj[@"state"]];
        }];
        NSMutableArray *citys = [NSMutableArray arrayWithArray:[provinceArray firstObject][@"cities"]];
        [citys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.cityArray addObject:obj[@"city"]];
        }];
        self.areaArray = [NSMutableArray arrayWithArray:[citys firstObject][@"areas"]];
        
        [self addSubview:_pickerView];
    }
    return self;
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return self.provinces.count;
    }else if (component == 1) {
        return self.cityArray.count;
    }else{
        return self.areaArray.count;
    }
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"area" ofType:@"plist"];
    NSArray *provinceArray = [[NSArray alloc] initWithContentsOfFile:path];
    if (component == 0) {
        self.selectedArray = provinceArray[row][@"cities"];
        [self.cityArray removeAllObjects];
        [self.selectedArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.cityArray addObject:obj[@"city"]];
        }];
        self.areaArray = [NSMutableArray arrayWithArray:[self.selectedArray firstObject][@"areas"]];
        [pickerView reloadComponent:1];
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:1 animated:YES];
        [pickerView selectRow:0 inComponent:2 animated:YES];
    }else if (component == 1) {
        if (self.selectedArray.count == 0) {
            self.selectedArray = [provinceArray firstObject][@"cities"];
        }
        self.areaArray = [NSMutableArray arrayWithArray:[self.selectedArray objectAtIndex:row][@"areas"]];
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:2 animated:YES];
    }else{
        
    }
    
    NSInteger index = [_pickerView selectedRowInComponent:0];
    NSInteger index1 = [_pickerView selectedRowInComponent:1];
    NSInteger index2 = [_pickerView selectedRowInComponent:2];
    self.province = self.provinces[index];
    self.city = self.cityArray[index1];
    if (self.areaArray.count != 0) {
        self.area = self.areaArray[index2];
    }else{
        self.area = @"";
    }
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component == 0) {
        return self.provinces[row];
    }else if (component == 1){
        return self.cityArray[row];
    }else{
        if (self.areaArray.count != 0) {
            return self.areaArray[row];
        }else{
            return nil;
        }
    }
}

- (void)showInView:(UIView *) view
{
    self.frame = CGRectMake(0, view.frame.size.height, self.frame.size.width, self.frame.size.height);
    [view addSubview:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, view.frame.size.height - self.frame.size.height, self.frame.size.width, self.frame.size.height);
    }];
    
}

- (void)cancelPicker
{
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.frame = CGRectMake(0, self.frame.origin.y+self.frame.size.height, self.frame.size.width, self.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         [self removeFromSuperview];
                         
                     }];
    
}

- (NSMutableArray *)provinces{
    if (!_provinces) {
        self.provinces = [@[] mutableCopy];
    }
    return _provinces;
}

- (NSMutableArray *)cityArray{
    if (!_cityArray) {
        self.cityArray = [@[] mutableCopy];
    }
    return _cityArray;
}
- (NSMutableArray *)areaArray{
    if (!_areaArray) {
        self.areaArray = [@[] mutableCopy];
    }
    return _areaArray;
}
- (NSMutableArray *)selectedArray{
    if (!_selectedArray) {
        self.selectedArray = [@[] mutableCopy];
    }
    return _selectedArray;
}

@end
