//
//  goodsViewCell.m
//  CrowdfundingShop
//
//  Created by 吴金林 on 15/12/20.
//  Copyright © 2015年 吴金林. All rights reserved.
//

#import "goodsViewCell.h"
#import "RequestData.h"
//获得当前屏幕宽高点数（非像素）
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
@implementation goodsViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // 初始化时加载collectionCell.xib文件
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"goodsViewCell" owner:self options:nil];
        
        // 如果路径不存在，return nil
        if (arrayOfViews.count < 1)
        {
            return nil;
        }
        // 如果xib中view不属于UICollectionViewCell类，return nil
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]])
        {
            return nil;
        }
        // 加载nib
        self = [arrayOfViews objectAtIndex:0];
    }
    return self;
}

- (void)awakeFromNib {
    //更改进度条高度
    self.progressView.transform=CGAffineTransformMakeScale(1.0f, 2.0f);
}
/**
 *  添加购物车
 *
 *  @param sender <#sender description#>
 */
- (IBAction)addShopCart:(UIButton *)sender {
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:self.goodsID.text,@"ShopId",@"1",@"ShopNum",@"10",@"cartbs",nil];
    [RequestData addShopCart:params FinishCallbackBlock:^(NSDictionary *data) {
    }];
    NSLog(@"----%@",self.goodsID.text);
}

@end
