//
//  ZYImageCacheManager.h
//  UIImageViewFICDemo
//
//  Created by Xuanxiang Pan on 1/24/14.
//  Copyright (c) 2014 Ziyisoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZYImageCacheManager : NSObject

/**
 *  获得实例
 *
 *  @return 实例
 */
+ (instancetype)sharedManager;

/**
 *  获取图片缓存
 *
 *  @param imageUrl      图片链接
 *  @param completeBlock 回调处理
 *
 *  @return <#return value description#>
 */
- (BOOL)retrieveImageForURL:(NSURL *)imageUrl completeBlock:(void (^)(UIImage *image))completeBlock;

@end
