//
//  UIImageView+FastImageCache.m
//  UIImageViewFICDemo
//
//  Created by Xuanxiang Pan on 1/24/14.
//  Copyright (c) 2014 Ziyisoft. All rights reserved.
//

#import "UIImageView+FastImageCache.h"
#import "ZYImageCacheManager.h"
#import "ZYImageEntity.h"

@implementation UIImageView (FastImageCache)

- (void)setImageWithURL:(NSURL *)url
{
    [self setImageWithURL:url placeholderImage:nil];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder
{
    __weak UIImageView *theImageView = self;
    [self setImageWithURL:url placeholderImage:placeholder completed:^(UIImage *image) {
        theImageView.image = image;
    }];
}


-(void)setImageWithURL:(NSURL *)url completed:(void (^)(UIImage *))completedBlock
{
    [self setImageWithURL:url placeholderImage:nil completed:completedBlock];
}


-(void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(void (^)(UIImage *))completedBlock
{
    BOOL isReady = [[ZYImageCacheManager sharedManager] retrieveImageForURL:url completeBlock:completedBlock];
    if (!isReady){
        self.image = placeholder;
    }else{
        NSLog(@"[Cache Hit] ---> FIC : %@", [[ZYImageEntity imageEntityWithURL:url] UUID]);
    }
}

@end
