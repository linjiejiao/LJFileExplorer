//
//  MediaPickUtil.m
//  bigolive
//
//  Created by liangjiajian_mac on 16/8/3.
//  Copyright © 2016年 YY Inc. All rights reserved.
//

#import "BaseMediaPickerViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/UTCoreTypes.h>

@interface BaseMediaPickerViewController ()
@property (strong, nonatomic) PickImgeFromCamerHandler cameraHandler;
@property (strong, nonatomic) PickMediaFromAlbumHandler albumHandler;

@end

@implementation BaseMediaPickerViewController

- (void)pickImageFromCameraHandler:(PickImgeFromCamerHandler)handler {
    self.cameraHandler = handler;
    self.albumHandler = nil;
    NSArray *mediaTypes = [[NSArray alloc] initWithObjects:(NSString*)kUTTypeImage, nil];
    [self getMediaFromSource:UIImagePickerControllerSourceTypeCamera andMediaTypes:mediaTypes];
}

- (void)pickImageFromAlbumHandler:(PickMediaFromAlbumHandler)handler {
    self.albumHandler = handler;
    self.cameraHandler = nil;
    NSArray *mediaTypes = [[NSArray alloc] initWithObjects:(NSString*)kUTTypeImage, nil];
    [self getMediaFromSource:UIImagePickerControllerSourceTypePhotoLibrary andMediaTypes:mediaTypes];
}

- (void)getMediaFromSource:(UIImagePickerControllerSourceType)sourceType andMediaTypes:(NSArray *)mediaTypes {
    if([UIImagePickerController isSourceTypeAvailable:sourceType] && [mediaTypes count] > 0) {
        if (sourceType == UIImagePickerControllerSourceTypeCamera) {
            NSString *mediaType = AVMediaTypeVideo; // Or AVMediaTypeAudio
            AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
            switch (authStatus) {
                case AVAuthorizationStatusAuthorized: {
                    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                    picker.mediaTypes = mediaTypes;
                    picker.delegate = self;
                    picker.allowsEditing = YES;
                    picker.sourceType = sourceType;
                    [self presentViewController:picker animated:YES completion:nil];
                    break;
                }
                case AVAuthorizationStatusNotDetermined: {
                    [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if(granted) {
                                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                                picker.mediaTypes = mediaTypes;
                                picker.delegate = self;
                                picker.allowsEditing = YES;
                                picker.sourceType = sourceType;
                                [self presentViewController:picker animated:YES completion:nil];
                            }else{
                                [self showCameraPermissionAlert];
                            }
                        });
                        
                    }];
                    break;
                }
                default: {
                    [self showCameraPermissionAlert];
                    break;
                }
            }
        }else{
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.mediaTypes = mediaTypes;
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.sourceType = sourceType;
            picker.navigationBar.translucent = NO;
//            picker.navigationBar.barTintColor = kTopBarBgColor;
//            picker.navigationBar.tintColor = kThemeColor;
            [self presentViewController:picker animated:YES completion:nil];
        }
    }else{
//        [DWInfoAlert showInfo:NSLocalizedString(@"Can not take photos", nil) inView:self.view];
    }
}

- (void)showCameraPermissionAlert {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Camera Permission Required" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info {
    UIImage* image = [info objectForKey:UIImagePickerControllerEditedImage];
    NSURL* assetUrl = [info objectForKey:UIImagePickerControllerReferenceURL];
    if(self.cameraHandler){
        self.cameraHandler(NO, image);
        self.cameraHandler = nil;
    }
    if(self.albumHandler){
        self.albumHandler(NO, assetUrl);
        self.albumHandler = nil;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController*)picker {
    if(self.cameraHandler){
        self.cameraHandler(YES, nil);
        self.cameraHandler = nil;
    }
    if(self.albumHandler){
        self.albumHandler(YES, nil);
        self.albumHandler = nil;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
