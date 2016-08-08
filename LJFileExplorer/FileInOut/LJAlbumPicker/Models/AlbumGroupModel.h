//
//  AlbumGroupModel.h
//  MoviePlayer
//
//  Created by liangjiajian_mac on 16/8/5.
//  Copyright © 2016年 cn.ljj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlbumItemModel.h"

@interface AlbumGroupModel : NSObject
@property (strong, nonatomic) UIImage *poster;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *type;
@property (assign, nonatomic) int count;
@property (strong, nonatomic) NSMutableArray<AlbumItemModel *> *assets;

@end
