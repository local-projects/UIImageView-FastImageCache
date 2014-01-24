//
//  ZYImageEntity.h
//  UIImageViewFICDemo
//
//  Created by Xuanxiang Pan on 1/24/14.
//  Copyright (c) 2014 Ziyisoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FastImageCache/FICEntity.h>

@interface ZYImageEntity : NSObject <FICEntity>

/**
 *  图片下载链接
 */
@property (strong,nonatomic) NSURL *srcURL;

/**
 *  下载完成得到的图片
 */
@property (strong,nonatomic) UIImage *downloadedImage;

/**
 *  获得实例
 *
 *  @param url 图片链接
 *
 *  @return 实例
 */
+ (instancetype)imageEntityWithURL:(NSURL *)url;

/**
 *  本地缓存路径
 *
 *  @return 本地缓存路径
 */
- (NSString *)localPath;



@end
