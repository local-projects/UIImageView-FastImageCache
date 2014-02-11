//
//  ZYImageEntity.m
//  UIImageViewFICDemo
//
//  Created by Xuanxiang Pan on 1/24/14.
//  Copyright (c) 2014 Ziyisoft. All rights reserved.
//

#import "ZYImageEntity.h"
#import <FastImageCache/FICUtilities.h>
#import "ZYImageDownloader.h"

@interface ZYImageEntity()
{
    NSString *_UUID;
}
@end

@implementation ZYImageEntity


+ (instancetype)imageEntityWithURL:(NSURL *)url
{
    ZYImageEntity *entity = [[ZYImageEntity alloc] init];
    entity.srcURL = url;
    return entity;
}

- (NSString *)localPath
{
    return [[ZYImageDownloader diskCachePath] stringByAppendingPathComponent:[self UUID]];
}


static CGMutablePathRef _FICDCreateRoundedRectPath(CGRect rect, CGFloat cornerRadius) {
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGFloat minX = CGRectGetMinX(rect);
    CGFloat midX = CGRectGetMidX(rect);
    CGFloat maxX = CGRectGetMaxX(rect);
    CGFloat minY = CGRectGetMinY(rect);
    CGFloat midY = CGRectGetMidY(rect);
    CGFloat maxY = CGRectGetMaxY(rect);
    
    CGPathMoveToPoint(path, NULL, minX, midY);
    CGPathAddArcToPoint(path, NULL, minX, maxY, midX, maxY, cornerRadius);
    CGPathAddArcToPoint(path, NULL, maxX, maxY, maxX, midY, cornerRadius);
    CGPathAddArcToPoint(path, NULL, maxX, minY, midX, minY, cornerRadius);
    CGPathAddArcToPoint(path, NULL, minX, minY, minX, midY, cornerRadius);
    
    return path;
}

static UIImage * _FICDSquareImageFromImage(UIImage *image) {
    UIImage *squareImage = nil;
    CGSize imageSize = [image size];
    
    if (imageSize.width == imageSize.height) {
        squareImage = image;
    } else {
        // Compute square crop rect
        CGFloat smallerDimension = MIN(imageSize.width, imageSize.height);
        CGRect cropRect = CGRectMake(0, 0, smallerDimension, smallerDimension);
        
        // Center the crop rect either vertically or horizontally, depending on which dimension is smaller
        if (imageSize.width <= imageSize.height) {
            cropRect.origin = CGPointMake(0, rintf((imageSize.height - smallerDimension) / 2.0));
        } else {
            cropRect.origin = CGPointMake(rintf((imageSize.width - smallerDimension) / 2.0), 0);
        }
        
        CGImageRef croppedImageRef = CGImageCreateWithImageInRect([image CGImage], cropRect);
        squareImage = [UIImage imageWithCGImage:croppedImageRef];
        CGImageRelease(croppedImageRef);
    }
    
    return squareImage;
}

#pragma mark - FICEntity

- (NSString *)UUID
{
    if (_UUID == nil) {
        // MD5 hashing is expensive enough that we only want to do it once
        CFUUIDBytes UUIDBytes = FICUUIDBytesFromMD5HashOfString([self.srcURL absoluteString]);
        _UUID = FICStringWithUUIDBytes(UUIDBytes);
    }
    
    return _UUID;
}

- (NSString *)sourceImageUUID
{
    return self.UUID;
}

- (NSURL *)sourceImageURLWithFormatName:(NSString *)formatName
{
    return self.srcURL;
}

- (FICEntityImageDrawingBlock)drawingBlockForImage:(UIImage *)image withFormatName:(NSString *)formatName
{
    FICEntityImageDrawingBlock drawingBlock = ^(CGContextRef contextRef, CGSize contextSize) {
        CGRect contextBounds = CGRectZero;
        contextBounds.size = contextSize;
        CGContextClearRect(contextRef, contextBounds);
        UIImage *squareImage = _FICDSquareImageFromImage(image);
        
        // Skip the rounding...
        // Clip to a rounded rect
        //CGPathRef path = _FICDCreateRoundedRectPath(contextBounds, 12);
        //CGContextAddPath(contextRef, path);
        //CFRelease(path);
        //CGContextEOClip(contextRef);
        
        UIGraphicsPushContext(contextRef);
        [squareImage drawInRect:contextBounds];
        UIGraphicsPopContext();
    };
    
    return drawingBlock;
}




@end
