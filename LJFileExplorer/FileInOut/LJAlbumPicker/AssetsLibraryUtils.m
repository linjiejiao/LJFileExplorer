//
//  AssetsLibraryUtils.m
//  MoviePlayer
//
//  Created by liangjiajian_mac on 16/8/5.
//  Copyright © 2016年 cn.ljj. All rights reserved.
//

#import "AssetsLibraryUtils.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import <AssetsLibrary/AssetsLibrary.h>

#define BUFFER_SIZE 65535

@implementation AssetsLibraryUtils

+ (void)copyFileFromAlbum:(NSURL *)assetUrl toPath:(NSString *)saveFile complete:(void(^)(BOOL succss, NSError *error))complete{
    ALAssetsLibrary* lib = [ALAssetsLibrary new];
    [lib assetForURL:assetUrl resultBlock:^(ALAsset *asset) {
        BOOL ret = [AssetsLibraryUtils writeAsset:asset otFile:saveFile];
        complete(ret, nil);
    } failureBlock:^(NSError *error) {
        complete(NO, error);
    }];
}

+ (BOOL)writeAsset:(ALAsset *)asset otFile:(NSString *)saveFile{
    ALAssetRepresentation *rep = [asset defaultRepresentation];
    long long size = [rep size];
    NSError *error;
    if (size != 0) {
        NSFileManager *fm = [NSFileManager defaultManager];
        if(![fm fileExistsAtPath:saveFile]){
            [fm createFileAtPath:saveFile contents:nil attributes:nil];
        }
        NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:saveFile];
        Byte buffer[BUFFER_SIZE];
        int length = 0;
        int offset = 0;
        do {
            length = [rep getBytes:buffer
                        fromOffset:offset
                            length:BUFFER_SIZE
                             error:&error];
            if(error){
                return NO;
            }
            NSData *data = [NSData dataWithBytes:buffer length:length];
            [fileHandle writeData:data];
            offset += length;
        } while (length != 0);
        [fileHandle closeFile];
    }else{
        return NO;
    }
    return YES;
}

+ (NSDictionary *)parseParmsFromUrl:(NSString*)url {
    NSMutableDictionary *dic = [NSMutableDictionary new];
    if([url containsString:@"?"]){
        url = [[url componentsSeparatedByString:@"?"] lastObject];
    }
    NSArray *components = [url componentsSeparatedByString:@"&"];
    for(NSString *component in components){
        NSArray *keyValue = [component componentsSeparatedByString:@"="];
        if(keyValue && keyValue.count == 2){
            [dic setObject:[keyValue lastObject] forKey:[keyValue firstObject]];
        }
    }
    return dic;
}
@end
