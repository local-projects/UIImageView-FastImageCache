# UIImageView+FastImageCache

[![Version](http://cocoapod-badges.herokuapp.com/v/UIImageView-FastImageCache/badge.png)](http://cocoadocs.org/docsets/UIImageView+FastImageCache)
[![Platform](http://cocoapod-badges.herokuapp.com/p/UIImageView-FastImageCache/badge.png)](http://cocoadocs.org/docsets/UIImageView+FastImageCache)

## Usage

更简单的API来设置一个UIImageView的图片，自动下载和管理缓存。

- (void)setImageWithURL:(NSURL *)url;

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;

- (void)setImageWithURL:(NSURL *)url completed:(void(^)(UIImage *image))completedBlock;

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(void(^)(UIImage *image))completedBlock;



## Requirements

## Installation

UIImageView-FastImageCache is available through [CocoaPods](http://cocoapods.org), to install
it simply add the following line to your Podfile:

    pod "UIImageView-FastImageCache", :git => "https://github.com/pan286/UIImageView-FastImageCache.git"

## Author

pan286#gmail.com

## License

UIImageView+FastImageCache is available under the MIT license. See the LICENSE file for more info.

