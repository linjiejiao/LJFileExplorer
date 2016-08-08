//
//  AlbumCollectionViewCell.h
//  MoviePlayer
//
//  Created by liangjiajian_mac on 16/8/5.
//  Copyright © 2016年 cn.ljj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlbumItemModel.h"

@interface AlbumCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) AlbumItemModel *model;

+ (CGSize)cellSize;
+ (UIEdgeInsets)cellInsets;
+ (UINib *)cellNib;
+ (NSString *)cellId;

@end
