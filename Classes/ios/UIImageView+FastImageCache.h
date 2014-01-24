//
//  UIImageView+FastImageCache.h
//  UIImageViewFICDemo
//
//  Created by Xuanxiang Pan on 1/24/14.
//  Copyright (c) 2014 Ziyisoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (FastImageCache)

/**
 *  设置图片
 *
 *  @param url 图片链接
 */
- (void)setImageWithURL:(NSURL *)url;

/**
 *  设置图片
 *
 *  @param url         图片链接
 *  @param placeholder 占位图
 */
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;

/**
 *  设置图片
 *
 *  @param url            图片链接
 *  @param completedBlock 回调处理
 */
- (void)setImageWithURL:(NSURL *)url completed:(void(^)(UIImage *image))completedBlock;

/**
 *  设置图片
 *
 *  @param url            图片链接
 *  @param placeholder    占位图
 *  @param completedBlock 回调处理
 */
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(void(^)(UIImage *image))completedBlock;

@end
