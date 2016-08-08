//
//  FileTableViewCell.h
//  MoviePlayer
//
//  Created by liangjiajian_mac on 16/7/30.
//  Copyright © 2016年 cn.ljj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FileModel.h"

@interface FileTableViewCell : UITableViewCell
@property (assign, nonatomic) BOOL selectMode;
@property (strong, nonatomic) FileModel *model;
+ (float)cellHeight;
+ (UINib *)cellNib;
+ (NSString *)cellId;

- (void)setModel:(FileModel *)model;
@end
