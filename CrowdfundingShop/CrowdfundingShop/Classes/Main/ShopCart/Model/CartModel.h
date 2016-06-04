//
//  CartModel.h
//  CrowdfundingShop
//
//  Created by 吴金林 on 16/2/14.
//  Copyright © 2016年 吴金林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CartModel : NSObject
/**主键ID*/
@property(assign,nonatomic)int pk_id;
/**商品ID*/
@property(retain,nonatomic)NSString *shopId;
/**商品标题*/
@property(retain,nonatomic)NSString *title;
/**剩余人数*/
@property(retain,nonatomic)NSString *shenyurenshu;
/**商品图片*/
@property(retain,nonatomic)NSString *thumb;
/**购买次数*/
@property(assign,nonatomic)int num;
/**金额*/
@property(assign,nonatomic)int price;
@end
