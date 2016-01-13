//
//  PopularGoodsCell.m
//  CrowdfundingShop
//
//  Created by 吴金林 on 15/12/1.
//  Copyright © 2015年 吴金林. All rights reserved.
//

#import "PopularGoodsCell.h"

@implementation PopularGoodsCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // 初始化时加载collectionCell.xib文件
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"PopularGoodsCell" owner:self options:nil];

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
    /**设置圆角*/
    self.timeView.layer.cornerRadius=8.0;
    self.timeView.layer.masksToBounds=YES;
}

@end
