//
//  LKImagePicker.m
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/7/14.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKImagePicker.h"

#import <Photos/Photos.h>

@interface LKImagePicker ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) imageBlock block;

// 是否允许编辑
@property (nonatomic, assign) BOOL allowEdit;
@end

@implementation LKImagePicker

+ (instancetype)sharedPicker {
    static LKImagePicker *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [LKImagePicker new];
    });
    return instance;
}

#pragma mark - 相册选择照片
+ (void)getPictureWithBlock:(imageBlock)block {
    [LKImagePicker getPictureWithController:nil block:block];
}

+ (void)getPictureWithController:(UIViewController *)controller block:(imageBlock)block {
    [LKImagePicker sharedPicker].allowEdit = NO;
    [LKImagePicker requestPictureSuccess:^{
        [LKImagePicker sharedPicker].block = block;
        [[LKImagePicker sharedPicker] choicePicureWithController:controller];
    }];
}

+ (void)getPictureAllowEdit:(BOOL)allowEdit block:(imageBlock)block {
    [LKImagePicker sharedPicker].allowEdit = allowEdit;
    [LKImagePicker requestPictureSuccess:^{
        [LKImagePicker sharedPicker].block = block;
        [[LKImagePicker sharedPicker] choicePicureWithController:nil];
    }];
}

- (void)choicePicureWithController:(UIViewController *)controller {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }]];
        [[LKImagePicker keyController] presentViewController:alert animated:YES completion:nil];
        return;
    }
    UIImagePickerController *pictureController = [[UIImagePickerController alloc] init];
    pictureController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    pictureController.delegate = self;
    pictureController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    pictureController.allowsEditing = self.allowEdit;
    [(controller ? controller : [LKImagePicker keyController]) presentViewController:pictureController animated:YES completion:nil];
}

#pragma mark - 资源回调
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
 
    UIImage *image;
    if (self.allowEdit) {
        image = info[UIImagePickerControllerEditedImage];
    } else {
        image = info[UIImagePickerControllerOriginalImage];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        self.block(image);
    });
}

#pragma mark - 拍照
+ (void)getCameraWithBlock:(imageBlock)block {
    [LKImagePicker getCameraWithController:nil block:block];
}

+ (void)getCameraWithController:(UIViewController *)controller block:(imageBlock)block {
    [LKImagePicker sharedPicker].allowEdit = NO;
    [LKImagePicker requestCameraSuccess:^{
        [LKImagePicker sharedPicker].block = block;
        [[LKImagePicker sharedPicker] cameraPicureWithController:controller];
    }];
}

+ (void)getCameraAllowEdit:(BOOL)allowEdit block:(imageBlock)block {
    [LKImagePicker sharedPicker].allowEdit = allowEdit;
    [LKImagePicker requestCameraSuccess:^{
        [LKImagePicker sharedPicker].block = block;
        [[LKImagePicker sharedPicker] cameraPicureWithController:nil];
    }];
}

- (void)cameraPicureWithController:(UIViewController *)controller {
    if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }]];
        [(controller ? controller : [LKImagePicker keyController]) presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    UIImagePickerController *pictureController = [[UIImagePickerController alloc] init];
    pictureController.sourceType = UIImagePickerControllerSourceTypeCamera;
    pictureController.delegate = self;
    pictureController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    pictureController.allowsEditing = self.allowEdit;
    [[LKImagePicker keyController] presentViewController:pictureController animated:YES completion:nil];
}

#pragma mark - 请求权限
+ (void)requestPictureSuccess:(void(^)(void))success {
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied) { // 拒绝
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }]];
        [[LKImagePicker keyController] presentViewController:alert animated:YES completion:nil];
    } else if (status == PHAuthorizationStatusNotDetermined) { // 未申请
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    success();
                });
            }
        }];
    } else { // 已通过
        dispatch_async(dispatch_get_main_queue(), ^{
            success();
        });
    }
}

+ (void)requestCameraSuccess:(void(^)(void))success {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) { // 拒绝
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }]];
        [[LKImagePicker keyController] presentViewController:alert animated:YES completion:nil];
    } else if (authStatus == AVAuthorizationStatusNotDetermined) { // 未申请
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    success();
                });
            }
        }];
    } else { // 已通过
        dispatch_async(dispatch_get_main_queue(), ^{
            success();
        });
    }
}

#pragma mark - 弹窗跟窗口
+ (__kindof UIViewController *)keyController {
    if ([[UIApplication sharedApplication].keyWindow.rootViewController presentedViewController]) {
        return [UIApplication sharedApplication].keyWindow.rootViewController.presentedViewController;
    } else {
        return [UIApplication sharedApplication].keyWindow.rootViewController;
    }
}

@end
