//
//  ZYImageCacheManager.m
//  UIImageViewFICDemo
//
//  Created by Xuanxiang Pan on 1/24/14.
//  Copyright (c) 2014 Ziyisoft. All rights reserved.
//

#import "ZYImageCacheManager.h"
#import <FastImageCache/FICImageCache.h>

#import "ZYImageDownloader.h"
#import "ZYImageEntity.h"

#define kDEFAULT_IMAGE_WIDTH 72
#define kDEFAULT_IMAGE_HEIGHT 72
#define kDEFAULT_CACHE_FORMAT_NAME @"ZYImageCacheFormatDefault"
#define kDEFAULT_MAX_CACHE_COUNT 1000

@interface ZYImageCacheManager()<FICImageCacheDelegate>
{
    NSMutableArray *downloadingEntity;
}
@end

@implementation ZYImageCacheManager

+ (instancetype)sharedManager
{
    static ZYImageCacheManager *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[ZYImageCacheManager alloc] init];
        [_instance initFICImageCache];
    });
    return _instance;
}



- (BOOL)retrieveImageForURL:(NSURL *)imageUrl completeBlock:(void (^)(UIImage *))completeBlock
{
    return [[FICImageCache sharedImageCache] retrieveImageForEntity:[ZYImageEntity imageEntityWithURL:imageUrl]
                                                     withFormatName:kDEFAULT_CACHE_FORMAT_NAME
                                                    completionBlock:^(id<FICEntity> entity, NSString *formatName, UIImage *image) {
                                                        completeBlock(image);
                                                    }];
}

- (void)initFICImageCache
{
    FICImageFormat *format = [FICImageFormat formatWithName:kDEFAULT_CACHE_FORMAT_NAME
                                                     family:nil
                                                  imageSize:CGSizeMake(kDEFAULT_IMAGE_WIDTH, kDEFAULT_IMAGE_HEIGHT)
                                                      style:FICImageFormatStyle32BitBGRA
                                               maximumCount:kDEFAULT_MAX_CACHE_COUNT
                                                    devices:FICImageFormatDevicePhone];
    [[FICImageCache sharedImageCache] setFormats:@[format]];
    [[FICImageCache sharedImageCache] setDelegate:self];
    
}


#pragma mark - FICImageCacheDelegate
- (void)imageCache:(FICImageCache *)imageCache wantsSourceImageForEntity:(id <FICEntity>)entity withFormatName:(NSString *)formatName completionBlock:(FICImageRequestCompletionBlock)completionBlock
{
    ZYImageDownloader *downloader = [ZYImageDownloader shareDownloader];
    ZYImageEntity *theEntity = (ZYImageEntity *)entity;
    if ([downloader isDownloadedImageEntity:theEntity]){
        // load from disk
        UIImage *srcImage  = [UIImage imageWithContentsOfFile:[theEntity localPath]];
        completionBlock(srcImage);
        //NSLog(@"[Cache Hit] ===> Disk: %@",[theEntity localPath]);
        
    }else{
        // download from network
        //NSLog(@"VVVV NO Cache: download now ... %@",[[theEntity srcURL] absoluteString]);
        [downloader downloadImageEntity:theEntity completeBlocks:^(UIImage *dlImage) {
            completionBlock(dlImage);
            [downloadingEntity removeObject:theEntity];
        }];
        
        if (!downloadingEntity){
            downloadingEntity = [NSMutableArray array];
        }
        [downloadingEntity addObject:theEntity];
    }
}

- (void)imageCache:(FICImageCache *)imageCache cancelImageLoadingForEntity:(id <FICEntity>)entity withFormatName:(NSString *)formatName
{
    
}

- (BOOL)imageCache:(FICImageCache *)imageCache shouldProcessAllFormatsInFamily:(NSString *)formatFamily forEntity:(id <FICEntity>)entity
{
    return NO;
}

- (void)imageCache:(FICImageCache *)imageCache errorDidOccurWithMessage:(NSString *)errorMessage
{
    
}


@end
