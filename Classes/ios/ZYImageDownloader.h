//
//  ZYImageDownloader.h
//  UIImageViewFICDemo
//
//  Created by Xuanxiang Pan on 1/24/14.
//  Copyright (c) 2014 Ziyisoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZYImageEntity.h"

@interface ZYImageDownloader : NSObject

@property (assign,nonatomic) NSInteger simultaneousDownloadCount;

/**
 *  获得实例
 *
 *  @return 实例
 */
+ (instancetype)shareDownloader;

/**
 *  获取本地缓存路径
 *
 *  @return 本地缓存路径
 */
+ (NSString *)diskCachePath;

/**
 *  查询图片是否已经下载到本地
 *
 *  @param entity 图片URL封装后的实体
 *
 *  @return 是否已下载
 */
- (BOOL)isDownloadedImageEntity:(ZYImageEntity *)entity;

/**
 *  下载图片
 *
 *  @param entity        图片URL封装后的实体
 *  @param completeBlock 回调处理
 */
- (void)downloadImageEntity:(ZYImageEntity *)entity completeBlocks:(void(^)(UIImage *image))completeBlock;

///**
// *  取消下载 (暂未实现)
// *
// *  @param entity 图片URL封装后的实体
// */
//- (void)cancelDownloadImageEntity:(ZYImageEntity *)entity;


@end
