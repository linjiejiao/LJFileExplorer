//
//  AlbumGroupModel.m
//  MoviePlayer
//
//  Created by liangjiajian_mac on 16/8/5.
//  Copyright © 2016年 cn.ljj. All rights reserved.
//

#import "AlbumGroupModel.h"

@implementation AlbumGroupModel

- (NSMutableArray<AlbumItemModel *> *)assets {
    if(!_assets){
        _assets = [NSMutableArray new];
    }
    return _assets;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"AlbumGroupModel[name=%@, type=%@, count=%d]", self.name, self.type, self.count];
}

@end
