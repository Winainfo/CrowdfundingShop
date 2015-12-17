//
//  CloudNumberController.m
//  CrowdfundingShop
//  云购码
//  Created by 吴金林 on 15/12/13.
//  Copyright © 2015年 吴金林. All rights reserved.
//

#import "CloudNumberController.h"

@interface CloudNumberController ()
@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;

@end

@implementation CloudNumberController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航栏标题颜色和字体大小UITextAttributeFont:[UIFont fontWithName:@"Heiti TC" size:0.0]
   [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Menlo" size:16.0],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.title=@"云购码";
    //导航栏左侧按钮
    UIButton *leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[UIImage imageNamed:@"navbar_back"] forState:UIControlStateNormal];
    [leftBtn setImage:[UIImage imageNamed:@"navbar_back"] forState:UIControlStateSelected];
    leftBtn.frame=CGRectMake(-5, 5, 21, 21);
    [leftBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem=left;
    //注册Cell
    [self.myCollectionView registerClass:[CloudNumberCell class] forCellWithReuseIdentifier:@"CloudNumberCell"];
    
}
//返回
-(void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 实现代理方法
//每个section的item个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 2300;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CloudNumberCell *cell = (CloudNumberCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"CloudNumberCell" forIndexPath:indexPath];
    
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
    return UIEdgeInsetsMake(0,10,0,10);
}


@end
