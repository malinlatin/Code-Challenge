//
//  AWProcessOperation.m
//  Cloud On Code Challenge
//
//  Created by Zo on 2/4/14.
//  Copyright (c) 2014 Alonzo Wilkins. All rights reserved.
//

#import "AWProcessOperation.h"
#import "UIImage+Resize.h"
@interface AWProcessOperation ()

@property (nonatomic, strong, readwrite) UIImage *cellImage;

@property (nonatomic, strong, readwrite) NSURL *url;
@property (nonatomic, readwrite) CGSize cellSize;
@property (nonatomic, strong, readwrite) NSIndexPath *indexPath;


@end

@implementation AWProcessOperation


- (id)initWithURL:(NSURL *)url
         cellSize:(CGSize)cellSize
        indexPath:(NSIndexPath *)indexPath
         delegate:(id <AWImageProcessorDelegate>)delegate {
    
    self = [super init];
    if (self) {
        
        
        _indexPath = indexPath;
        _url = url;
        _cellSize = cellSize;
        _delegate = delegate;
    }
    return self;
}

- (void)main {
    
    @autoreleasepool {
        
        if (self.isCancelled)
            return;
        
        UIImage *downloadedImage = [self downloadImage];

        if (self.isCancelled)
            return;

        self.cellImage = [self cellImageFromImage:downloadedImage ofSize:self.cellSize];
        
        
        if (self.isCancelled)
            return;
        
        [(NSObject *)self.delegate performSelectorOnMainThread:@selector(imageProcessorDidFinish:) withObject:self waitUntilDone:NO];
        
    }
}


- (UIImage *)downloadImage {
    
    if (self.isCancelled)
        return nil;
    
    
    NSData *imageData = [[NSData alloc] initWithContentsOfURL:self.url];
    
    if (self.isCancelled) {
        imageData = nil;
        return nil;
    }
    
    UIImage *downloadedImage = nil;
    
    if (imageData) {
         downloadedImage = [UIImage imageWithData:imageData];
    }
    
    imageData = nil;
    
    if (self.isCancelled)
        return Nil;
    else
        return downloadedImage;
    
}


- (UIImage *)cellImageFromImage:(UIImage *)image ofSize:(CGSize)size {
    
    // Variables
    CGRect rect = { CGPointZero, size };
    
    // create image context
    UIGraphicsBeginImageContextWithOptions(rect.size, YES, [UIScreen mainScreen].scale);
    
    
    // draw Image
    if (image.size.width < image.size.width  && image.size.height < image.size.height) {
        
        CGPoint thumbnailOrigion = CGPointMake((image.size.width - image.size.width) / 2,
                                               (image.size.height - image.size.height) / 2);
        [image drawAtPoint:thumbnailOrigion];
        
    } else {
        
        rect = CGRectIntegral(rect);
        
        UIImage *resizedImage = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:rect.size interpolationQuality:kCGInterpolationHigh];
        
        
        CGPoint resizedImageOrigion = CGPointMake((rect.size.width - resizedImage.size.width) / 2,
                                                  (rect.size.height - resizedImage.size.height) / 2);
        
        [resizedImage drawAtPoint:resizedImageOrigion];
    }
    
    
    
    // create the image
    UIImage *cellContentImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return cellContentImage;
    
}

@end
