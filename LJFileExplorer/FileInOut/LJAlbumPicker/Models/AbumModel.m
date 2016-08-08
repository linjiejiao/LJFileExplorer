//
//  AbumModel.m
//  MoviePlayer
//
//  Created by liangjiajian_mac on 16/8/5.
//  Copyright © 2016年 cn.ljj. All rights reserved.
//

#import "AbumModel.h"
#import "AlbumGroupModel.h"
#import "AlbumItemModel.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface AbumModel ()
@property (strong, nonatomic)ALAssetsLibrary *assetsLibrary;

@end

@implementation AbumModel
static AbumModel * _instance;

+ (AbumModel *)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [AbumModel new];
    });
    return _instance;
}

- (ALAssetsLibrary *)assetsLibrary {
    if(!_assetsLibrary) {
        _assetsLibrary = [[ALAssetsLibrary alloc] init];
    }
    return _assetsLibrary;
}

- (NSMutableArray *)groupList {
    if(!_groupList) {
        _groupList = [[NSMutableArray alloc] init];
    }
    return _groupList;
}

- (NSMutableArray<AlbumItemModel *> *)allAlbumItems {
    if(!_allAlbumItems) {
        _allAlbumItems = [[NSMutableArray alloc] init];
    }
    return _allAlbumItems;
}

- (void)getGroupListAsync:(void (^)(NSArray* list))callback{
    NSMutableArray<AlbumGroupModel *> *tempGroupList = [[NSMutableArray alloc] init];
    NSMutableArray<AlbumItemModel *> *tempAllAlbumItems = [[NSMutableArray alloc] init];
    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if(!group){
            self.groupList = tempGroupList;
            self.allAlbumItems = tempAllAlbumItems;
            callback(self.groupList);
            return;
        }
        AlbumGroupModel *groupModel = [AlbumGroupModel new];
        groupModel.name = [group valueForProperty:ALAssetsGroupPropertyName];
        groupModel.type = [group valueForProperty:ALAssetsGroupPropertyType];
        groupModel.count = (int)[group numberOfAssets];
        groupModel.poster = [UIImage imageWithCGImage:[group posterImage]];
        [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            if(!result){
                return;
            }
            AlbumItemModel *item = [AlbumItemModel new];
            item.asset = result;
            [groupModel.assets addObject:item];
            [tempAllAlbumItems addObject:item];
        }];
        [tempGroupList addObject:groupModel];
    } failureBlock:^(NSError *error) {
        NSLog(@"Enumerate the asset groups failed.");
    }];
}

@end
