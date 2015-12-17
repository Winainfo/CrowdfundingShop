//
//  SearchWordController.m
//  CrowdfundingShop
//
//  Created by 吴金林 on 15/12/17.
//  Copyright © 2015年 吴金林. All rights reserved.
//

#import "SearchWordController.h"

@interface SearchWordController ()
@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;
@property (retain,nonatomic) NSArray *keyWordArray;
@end

@implementation SearchWordController
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
    //导航栏左侧按钮
    UIButton *leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[UIImage imageNamed:@"navbar_back"] forState:UIControlStateNormal];
    [leftBtn setImage:[UIImage imageNamed:@"navbar_back"] forState:UIControlStateSelected];
    leftBtn.frame=CGRectMake(-5, 5, 30, 30);
    [leftBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem=left;
    //注册Cell
    [self.myCollectionView registerClass:[SearchWordCell class] forCellWithReuseIdentifier:@"SearchWordCell"];
    self.keyWordArray=@[@"iPhone6",@"宝马X5",@"iPad",@"汽车",@"单反相机",@"小米3",@"电视",@"奥迪",@"电脑"];
}

//返回
-(void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark 实现代理方法
//每个section的item个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.keyWordArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    SearchWordCell *cell = (SearchWordCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"SearchWordCell" forIndexPath:indexPath];
    cell.titleLabel.text=_keyWordArray[indexPath.row];
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
    return UIEdgeInsetsMake(5,10,15,10);
}


@end
