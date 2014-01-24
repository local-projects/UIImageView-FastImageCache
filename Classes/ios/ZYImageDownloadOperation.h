//
//  ZYImageDownloadOperation.h
//  UIImageViewFICDemo
//
//  Created by Xuanxiang Pan on 1/24/14.
//  Copyright (c) 2014 Ziyisoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZYImageEntity.h"

@interface ZYImageDownloadOperation : NSOperation
/**
 *  获得实例的快捷方法
 *
 *  @param entity 图片URL封装后的实体
 *
 *  @return 实例
 */
+ (instancetype)operationWithImageEntity:(ZYImageEntity *)entity;

/**
 *  图片URL封装后的实体
 */
@property (weak,nonatomic) ZYImageEntity *imageEntity;

@end
