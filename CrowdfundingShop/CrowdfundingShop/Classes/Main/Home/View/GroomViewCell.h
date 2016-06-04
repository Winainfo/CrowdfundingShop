//
//  GroomViewCell.h
//  CrowdfundingShop
//
//  Created by 吴金林 on 16/2/15.
//  Copyright © 2016年 吴金林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ARLabel.h"
//添加代理，用于按钮加减的实现
@protocol AddCartDelegate <NSObject>

-(void)addCartClick:(UICollectionViewCell *)cell;

@end
@interface GroomViewCell : UICollectionViewCell
/**商品照片*/
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;
/**商品名字*/
@property (weak, nonatomic) IBOutlet ARLabel *goodsTitle;
/**总需人数*/
@property (weak, nonatomic) IBOutlet ARLabel *numLabel1;
/**剩余人次*/
@property (weak, nonatomic) IBOutlet ARLabel *numLabel2;
/**进度条*/
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
/**商品ID*/
@property (weak, nonatomic) IBOutlet UILabel *goodsID;
/**添加*/
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property(assign,nonatomic)id<AddCartDelegate>delegate;
@end
