//
//  ZYImageDownloader.m
//  UIImageViewFICDemo
//
//  Created by Xuanxiang Pan on 1/24/14.
//  Copyright (c) 2014 Ziyisoft. All rights reserved.
//

#import "ZYImageDownloader.h"
#import "ZYImageDownloadOperation.h"

#define kDEFUALT_SIMULTANEOUS_DOWNLOAD_COUNT 8
#define kDEFAULT_DISK_CACHE_PATH @"ZYImageDownloader"

@interface ZYImageDownloader()

@property (strong,nonatomic) NSOperationQueue *downloadQueue;

@end

@implementation ZYImageDownloader

+ (instancetype)shareDownloader
{
    static ZYImageDownloader *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[ZYImageDownloader alloc] init];
        _instance.downloadQueue = [[NSOperationQueue alloc] init];
        _instance.downloadQueue.name = @"ZYImageDownloader.DowloadQueue";
        _instance.downloadQueue.maxConcurrentOperationCount = kDEFUALT_SIMULTANEOUS_DOWNLOAD_COUNT;
    });
    return _instance;
}

+ (NSString *)diskCachePath
{
    static NSString *_diskCachePath = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSArray *cachesPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        _diskCachePath = [[cachesPaths objectAtIndex:0] stringByAppendingPathComponent:kDEFAULT_DISK_CACHE_PATH];
    });
    return _diskCachePath;
}

-(void)setSimultaneousDownloadCount:(NSInteger)simultaneousDownloadCount
{
    _simultaneousDownloadCount = simultaneousDownloadCount;
    self.downloadQueue.maxConcurrentOperationCount = simultaneousDownloadCount;
}

- (BOOL)isDownloadedImageEntity:(ZYImageEntity *)entity
{
    BOOL isDir = YES;
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:[entity localPath]
                                                        isDirectory:&isDir];
    return isExist && !isDir;
}

- (void)downloadImageEntity:(ZYImageEntity *)entity completeBlocks:(void(^)(UIImage *image))completeBlock;
{
    [self createCacheDirectoryIfNeeded];
    
    ZYImageDownloadOperation *downloadOperation = [ZYImageDownloadOperation operationWithImageEntity:entity];
    downloadOperation.completionBlock = ^(){
        completeBlock(entity.downloadedImage);
    };
    
    [self.downloadQueue addOperation:downloadOperation];
    NSLog(@"%@ %d",self.downloadQueue.name, self.downloadQueue.operationCount);
}

- (void)cancelDownloadImageEntity:(ZYImageEntity *)entity
{
    
}

-(void)createCacheDirectoryIfNeeded
{
    NSFileManager *fileMan = [NSFileManager defaultManager];
    if (![fileMan fileExistsAtPath:[ZYImageDownloader diskCachePath]]){
        NSError *error = nil;
        [fileMan createDirectoryAtPath:[ZYImageDownloader diskCachePath]
           withIntermediateDirectories:YES
                            attributes:nil
                                 error:&error];
    }
}
@end
