//
//  MediaPickUtil.h
//  bigolive
//
//  Created by liangjiajian_mac on 16/8/3.
//  Copyright © 2016年 YY Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PickImgeFromCamerHandler)(BOOL cancel, UIImage* image);
typedef void(^PickMediaFromAlbumHandler)(BOOL cancel, NSURL* assertUrl);

@interface BaseMediaPickerViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
- (void)pickImageFromCameraHandler:(PickImgeFromCamerHandler)handler;
- (void)pickImageFromAlbumHandler:(PickMediaFromAlbumHandler)handler;
@end
