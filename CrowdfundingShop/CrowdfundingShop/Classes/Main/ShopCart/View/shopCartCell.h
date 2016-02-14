//
//  shopCartCell.h
//  CrowdfundingShop
//
//  Created by 吴金林 on 15/12/27.
//  Copyright © 2015年 吴金林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ARLabel.h"
//添加代理，用于按钮加减的实现
@protocol CartCellDelegate <NSObject>

-(void)btnClick:(UITableViewCell *)cell andFlag:(int)flag;

@end
@interface shopCartCell : UITableViewCell<UITextFieldDelegate>
/**商品图片*/
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;
/**商品名字*/
@property (weak, nonatomic) IBOutlet ARLabel *goodsTitle;
/**剩余人次*/
@property (weak, nonatomic) IBOutlet ARLabel *numLabel;
/**商品数量*/
@property (weak, nonatomic) IBOutlet UITextField *numTextField;
/**商品价格*/
@property (weak, nonatomic) IBOutlet ARLabel *goodsPriceLabel;
@property(assign,nonatomic)id<CartCellDelegate>delegate;
@end
