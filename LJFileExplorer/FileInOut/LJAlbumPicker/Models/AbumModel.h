//
//  AbumModel.h
//  MoviePlayer
//
//  Created by liangjiajian_mac on 16/8/5.
//  Copyright © 2016年 cn.ljj. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AlbumGroupModel;
@class AlbumItemModel;

@interface AbumModel : NSObject
@property (strong, nonatomic)NSMutableArray<AlbumGroupModel *> *groupList;
@property (strong, nonatomic)NSMutableArray<AlbumItemModel *> *allAlbumItems;
+ (AbumModel *)shareInstance;
- (void)getGroupListAsync:(void (^)(NSArray* list))callback;
@end
