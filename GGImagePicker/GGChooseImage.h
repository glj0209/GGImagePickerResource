//
//  GGChooseImage.h
//  GGImagePicker
//
//  Created by gaolijun on 2018/9/29.
//  Copyright © 2018年 glj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GGChooseImage : NSObject

/** nav bar titleTextAttributes */
@property(nullable,nonatomic,copy) NSDictionary<NSAttributedStringKey, id> *navBarTitleTextAttributes;
/** navApperanceTintColor */
@property (nonatomic, strong) UIColor *navApperanceTintColor;
/** navApperanceBarTintColor */
@property (nonatomic, strong) UIColor *navApperanceBarTintColor;

/** 获取单例 */
+ (GGChooseImage *)sharedInstance;
/** 打开图片library */
- (void)openPhotoLibrary:(UIViewController *)preController;
/** 保存图片 */
- (void)savePicture:(UIImage *)image;

/** 选择的图片 */
@property (nonatomic,copy) void (^chooseImage)(UIImage * image, NSError *error);
/** 保存图片成功 */
@property (nonatomic,copy) void (^savePictureSuccess)(void);
/** 保存图片失败 */
@property (nonatomic,copy) void (^savePictureFaile)(void);

@end
