//
//  DidAnnounceController.m
//  CrowdfundingShop
//  已揭晓页面
//  Created by 吴金林 on 15/12/13.
//  Copyright © 2015年 吴金林. All rights reserved.
//

#import "DidAnnounceController.h"
#import "CloudNumberCell.h"
#import "ARLabel.h"
@interface DidAnnounceController ()

@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;
/**商品图片*/
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;
/**用户头像*/
@property (weak, nonatomic) IBOutlet UIImageView *peopleImageView;
/**用户名字*/
@property (weak, nonatomic) IBOutlet ARLabel *peopleNameLabel;
/**用户所在城市*/
@property (weak, nonatomic) IBOutlet ARLabel *peopleCityLabel;
/**揭晓时间*/
@property (weak, nonatomic) IBOutlet ARLabel *time1Label;
/**云购时间*/
@property (weak, nonatomic) IBOutlet ARLabel *buyTimeLabel;
/**幸运号码*/
@property (weak, nonatomic) IBOutlet ARLabel *numberLabel;
/**参加次数*/
@property (weak, nonatomic) IBOutlet ARLabel *countLabel;
/**计算详情*/
@property (weak, nonatomic) IBOutlet UIButton *detailBtn;
@end

@implementation DidAnnounceController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.goodsImageView.layer.borderWidth=0.5;
    self.goodsImageView.layer.borderColor=[[UIColor colorWithRed:222.0/255.0 green:222.0/255.0 blue:222.0/255.0 alpha:1.0]CGColor];
    /**圆角*/
    [[self.goodsImageView layer]setCornerRadius:2.0];
    self.detailBtn.layer.cornerRadius=4.0;
    self.peopleImageView.layer.cornerRadius=25.0;
    self.peopleImageView.layer.masksToBounds=YES;
    //注册Cell
    [self.myCollectionView registerClass:[CloudNumberCell class] forCellWithReuseIdentifier:@"CloudNumberCell"];
}



#pragma mark 实现代理方法
//每个section的item个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 12;
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
    return UIEdgeInsetsMake(0,0,0,0);
}



@end