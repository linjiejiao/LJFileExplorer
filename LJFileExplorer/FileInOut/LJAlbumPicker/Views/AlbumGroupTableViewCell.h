//
//  AlbumGroupTableViewCell.h
//  MoviePlayer
//
//  Created by liangjiajian_mac on 16/8/5.
//  Copyright © 2016年 cn.ljj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlbumGroupModel.h"

@interface AlbumGroupTableViewCell : UITableViewCell
@property (strong, nonatomic) AlbumGroupModel *model;

+ (float)cellHeight;
+ (UINib *)cellNib;
+ (NSString *)cellId;

@end
