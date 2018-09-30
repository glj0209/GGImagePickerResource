//
//  GGChooseImage.m
//  GGImagePicker
//
//  Created by gaolijun on 2018/9/29.
//  Copyright © 2018年 glj. All rights reserved.
//

#import "GGChooseImage.h"
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/PHPhotoLibrary.h>
#import <CoreLocation/CoreLocation.h>

@interface GGChooseImage ()< UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property(nonatomic,weak) UIImagePickerController *pickerController;
@end

@implementation GGChooseImage

+ (GGChooseImage *)sharedInstance {
    static dispatch_once_t onceToken;
    static GGChooseImage *photoManager = nil;
    dispatch_once(&onceToken, ^{
        photoManager = [[self alloc] init];
    });
    return photoManager;
}

- (void)openPhotoLibrary:(UIViewController *)preController {
    ALAuthorizationStatus author =[ALAssetsLibrary authorizationStatus];
    if (author == kCLAuthorizationStatusRestricted || author == kCLAuthorizationStatusDenied) {
        //无权限 做一个友好的提示
        UIAlertView * alart = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请您设置允许APP访问您的相册\n设置>隐私>照片" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alart show];
        return ;
    }else {
        //打开相册
        UIImagePickerController *con = [[UIImagePickerController alloc] init];
        con.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        con.delegate = self;
        con.allowsEditing = YES;
        if (self.navBarTitleTextAttributes != nil) {
            con.navigationBar.titleTextAttributes = self.navBarTitleTextAttributes;
        }
        
        if (self.navApperanceTintColor != nil) {
            [[UINavigationBar appearance] setTintColor:self.navApperanceTintColor];
        }
        
        if (self.navApperanceBarTintColor != nil) {
            [[UINavigationBar appearance] setBarTintColor:self.navApperanceBarTintColor];
        }
        
        self.pickerController = con;
        [preController presentViewController:con animated:YES completion:^{
            
        }];
        
        ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
        
        [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            
            if (*stop) {
                
                return;
            }
            *stop = TRUE;//不能省略
        } failureBlock:^(NSError *error) {
            [con dismissViewControllerAnimated:YES completion:nil];
        }];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage];
        if (self.chooseImage) {
            self.chooseImage(image, nil);
        }
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)savePicture:(UIImage *)image {
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status == PHAuthorizationStatusRestricted || status ==PHAuthorizationStatusDenied) {
            //无权限 做一个友好的提示
            dispatch_sync(dispatch_get_main_queue(), ^{
                UIAlertView * alart = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请您设置允许APP访问您的相册\n设置>隐私>照片" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alart show];
            });
        }else {
            UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
        }
    }];
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if(!error){
        if (self.savePictureSuccess) {
            self.savePictureSuccess();
        }
    }else{
        if (self.savePictureFaile) {
            self.savePictureFaile();
        }
    }
}

@end
