//
//  ZYImageDownloadOperation.m
//  UIImageViewFICDemo
//
//  Created by Xuanxiang Pan on 1/24/14.
//  Copyright (c) 2014 Ziyisoft. All rights reserved.
//

#import "ZYImageDownloadOperation.h"
#import "ZYImageEntity.h"

@interface ZYImageDownloadOperation()<NSURLConnectionDataDelegate>
{
    NSMutableURLRequest *_urlRequest;
    NSURLConnection *_connection;
    NSMutableData *_data;
    BOOL isFinished;
}
@end

@implementation ZYImageDownloadOperation

+ (instancetype)operationWithImageEntity:(ZYImageEntity *)entity
{
    ZYImageDownloadOperation *op = [[ZYImageDownloadOperation alloc] init];
    op.imageEntity = entity;
    return op;
}

- (BOOL)isConcurrent
{
    return YES;
}

- (BOOL)isExecuting
{
    return !isFinished;
}

-(BOOL)isFinished
{
    return isFinished;
}

- (void)start
{
    isFinished = NO;
    if (![self isCancelled]){
        [NSThread sleepForTimeInterval:1];
        
        _urlRequest = [NSMutableURLRequest requestWithURL:self.imageEntity.srcURL];
        _data = [NSMutableData data];
        _connection = [NSURLConnection connectionWithRequest:_urlRequest delegate:self];
    }
    while (_connection && !isFinished) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    
}

#pragma mark - NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_data appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    isFinished = YES;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (_data) {
        self.imageEntity.downloadedImage = [UIImage imageWithData:_data];
        [_data writeToFile:[self.imageEntity localPath] atomically:YES];
    }
    _data = nil;
    isFinished = YES;
}

- (void)cancel
{
    isFinished = YES;
}


@end
