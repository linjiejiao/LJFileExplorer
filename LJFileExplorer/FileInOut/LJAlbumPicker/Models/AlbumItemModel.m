//
//  AlbumItemModel.m
//  MoviePlayer
//
//  Created by liangjiajian_mac on 16/8/5.
//  Copyright © 2016年 cn.ljj. All rights reserved.
//

#import "AlbumItemModel.h"
#import <AssetsLibrary/AssetsLibrary.h>

@implementation AlbumItemModel

- (void)setAsset:(ALAsset *)asset {
    _asset = asset;
    self.type = [asset valueForProperty:ALAssetPropertyType];
    self.url = [asset valueForProperty:ALAssetPropertyAssetURL];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"AlbumItemModel[type=%@, url=%@]", self.type, self.url];
}
@end
