//
//  ZYAvatarCell.m
//  UIImageViewFICDemo
//
//  Created by Xuanxiang Pan on 1/24/14.
//  Copyright (c) 2014 Ziyisoft. All rights reserved.
//

#import "ZYAvatarCell.h"
#import "UIImageView+FastImageCache.h"

@interface ZYAvatarCell()
{
    NSMutableArray *_avatarImageViews;
}
@end

@implementation ZYAvatarCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setAvatarUrls:(NSArray *)avatarUrls
{
    if (_avatarUrls != avatarUrls){
        _avatarUrls = [avatarUrls copy];
        
        // Either create the image views for this cell or clear them out if they already exist
        if (_avatarImageViews == nil) {
            _avatarImageViews = [[NSMutableArray alloc] initWithCapacity:kAVATARS_PER_ROW];
    
            for (NSInteger i = 0; i < kAVATARS_PER_ROW; i++) {
                CGRect rect = CGRectMake(4 + 80*i , 4, 72, 72);
                UIImageView *avatarView = [[UIImageView alloc] initWithFrame:rect];
                avatarView.contentMode =  UIViewContentModeScaleAspectFill;
                [_avatarImageViews addObject:avatarView];
            }
        } else {
            for (UIImageView *imageView in _avatarImageViews) {
                [imageView setImage:nil];
                [imageView removeFromSuperview];
            }
        }
        
        NSInteger photosCount = [_avatarUrls count];
        for (int i=0; i<photosCount; i++){
            __weak UIImageView *avatarView = [_avatarImageViews objectAtIndex:i];
            NSString *url = [avatarUrls objectAtIndex:i];
            [avatarView setImageWithURL:[NSURL URLWithString:url] completed:^(UIImage *image) {
                if (avatarUrls == [self avatarUrls]){
                    [self.contentView addSubview:avatarView];
                    avatarView.image = image;
                }
            }];
        }
        [self setNeedsLayout];
    }

}


@end
