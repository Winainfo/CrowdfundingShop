//
//  SelectCloudNumController.m
//  CrowdfundingShop
//
//  Created by 吴金林 on 15/12/14.
//  Copyright © 2015年 吴金林. All rights reserved.
//

#import "SelectCloudNumController.h"
#import "SelectCloudNumCell.h"
@interface SelectCloudNumController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;

@end

@implementation SelectCloudNumController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航栏标题颜色和字体大小UITextAttributeFont:[UIFont fontWithName:@"Heiti TC" size:0.0]
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Menlo" size:16.0],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.title=@"选择云数";
    //导航栏左侧按钮
    UIButton *leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[UIImage imageNamed:@"navbar_back"] forState:UIControlStateNormal];
    [leftBtn setImage:[UIImage imageNamed:@"navbar_back"] forState:UIControlStateSelected];
    leftBtn.frame=CGRectMake(-5, 5, 21, 21);
    [leftBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem=left;
    //注册Cell
    [self.myCollectionView registerClass:[SelectCloudNumCell class] forCellWithReuseIdentifier:@"SelectCloudNumCell"];
    self.myCollectionView.delegate=self;
    self.myCollectionView.dataSource=self;
}

//返回
-(void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 实现代理方法
//每个section的item个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 98;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    SelectCloudNumCell *cell = (SelectCloudNumCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"SelectCloudNumCell" forIndexPath:indexPath];
    
    return cell;
}

#pragma mark 实现UICollectionViewDelegateFlowLayout代理
/**
 *  定义每个UICollectionView的间距
 *
 *  @param collectionView       <#collectionView description#>
 *  @param collectionViewLayout <#collectionViewLayout description#>
 *  @param section              <#section description#>
 *
 *  @return <#return value description#>
 */
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0,0,0,0);
}
#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
     SelectCloudNumCell * cell = (SelectCloudNumCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithRed:220.0/255.0 green:50.0/255.0 blue:83.0/255.0 alpha:1.0];
    cell.numLabel.textColor=[UIColor whiteColor];
}
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

@end
