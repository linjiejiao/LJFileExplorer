//
//  FileModel.h
//  MoviePlayer
//
//  Created by liangjiajian_mac on 16/7/30.
//  Copyright © 2016年 cn.ljj. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, FileModelType) {
    TypeFile,
    TypeDirectory,
};

@interface FileModel : NSObject
@property (nonatomic, assign) int type;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *path;
@property (nonatomic, assign) uint64_t size;
@property (nonatomic, assign) double date;

- (void)fillWithDictionary:(NSDictionary*)dic;

@end
