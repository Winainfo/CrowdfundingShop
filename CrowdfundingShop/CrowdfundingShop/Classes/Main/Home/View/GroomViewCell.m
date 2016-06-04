//
//  GroomViewCell.m
//  CrowdfundingShop
//
//  Created by 吴金林 on 16/2/15.
//  Copyright © 2016年 吴金林. All rights reserved.
//

#import "GroomViewCell.h"

@implementation GroomViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // 初始化时加载collectionCell.xib文件
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"GroomViewCell" owner:self options:nil];
        
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
    //调用代理
    [self.delegate addCartClick:self];
}
@end
