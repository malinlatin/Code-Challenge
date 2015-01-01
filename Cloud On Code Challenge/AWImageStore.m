//
//  AWImageStore.m
//  Cloud On Code Challenge
//
//  Created by Zo on 2/4/14.
//  Copyright (c) 2014 Alonzo Wilkins. All rights reserved.
//

#import "AWImageStore.h"

@interface AWImageStore ()

@property (nonatomic, strong) NSArray *URLArray;

@property (nonatomic, strong) NSMutableDictionary *photosDictionary;
@property (nonatomic, strong) NSArray *photosArray;
@property (nonatomic, strong) NSMutableArray *blankPhotos;

@property (nonatomic) CGSize imageSize;

@end

@implementation AWImageStore

+ (id)sharedInstance {
    
    static id sharedInstance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        
    });
    return sharedInstance;
}


- (id)init {
    
    self = [super init];
    if (self) {
        
        _URLArray = @[ @"http://www.8planets.co.uk/wp-content/themes/8planets/images/mercury_true_large.jpg",
                       @"http://www.8planets.co.uk/wp-content/themes/8planets/images/venus_1_lg.jpg",
                       @"http://www.8planets.co.uk/wp-content/themes/8planets/images/earth_lg.jpg",
                       @"http://www.8planets.co.uk/wp-content/themes/8planets/images/mars_lg.jpg",
                       @"http://www.8planets.co.uk/wp-content/themes/8planets/images/jupiter_lg.jpg",
                       @"http://www.8planets.co.uk/wp-content/themes/8planets/images/saturn_1_lg.jpg",
                       @"http://www.8planets.co.uk/wp-content/themes/8planets/images/uranus_hubble_lg.jpg",
                       @"http://www.8planets.co.uk/wp-content/themes/8planets/images/neptune_lg.jpg" ];
        
        _imageSize = CGSizeMake(100, 100);
        
        _photoDownloadsInProgress = [NSMutableDictionary dictionary];
        
        _photoDownloadQueue = [[NSOperationQueue alloc] init];
        _photoDownloadQueue.name = @"Image Download Queue";
        
        _finishedProcessingPhotos = NO;
        
        
        _photosDictionary = [NSMutableDictionary dictionary];
        _blankPhotos = [NSMutableArray array];
        
        for (int i = 0; i < 8; i++) {
            // Variables
            CGRect rect = { CGPointZero, self.imageSize };
            
            // create image context
            UIGraphicsBeginImageContextWithOptions(rect.size, YES, [UIScreen mainScreen].scale);
            CGContextRef context = UIGraphicsGetCurrentContext();
            
            
            // draw Image
            UIColor *photoColor = [UIColor colorWithRed:(1.0 - (i * 0.1))
                                                  green:(1.0 - (i * 0.1))
                                                   blue:1.0 alpha:1.0];
            
            CGContextSetFillColorWithColor(context, photoColor.CGColor);
            CGContextFillRect(context, rect);
            
            // create the image
            UIImage *cellContentImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            [_blankPhotos addObject:cellContentImage];
            
        }

    }
    
    return self;
}


- (UIImage *)blankImageForIndexPath:(NSIndexPath *)indexPath {
    
    
    
    return [self.blankPhotos objectAtIndex:indexPath.row];

}

- (UIImage *)imageForCellAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.finishedProcessingPhotos)
        return [self.photosArray objectAtIndex:indexPath.row];
    
    
    NSString *photoKey = [NSString stringWithFormat:@"%i", indexPath.row];
    UIImage *photo = [self.photosDictionary objectForKey:photoKey];
    if (!photo) {
        
        AWProcessOperation *processOperation = [self.photoDownloadsInProgress objectForKey:photoKey];
        if (!processOperation) {
            NSURL *imageURL = [NSURL URLWithString:[self.URLArray objectAtIndex:indexPath.row]];
            AWProcessOperation *imageProcess = [[AWProcessOperation alloc] initWithURL:imageURL
                                                                              cellSize:self.imageSize
                                                                             indexPath:indexPath
                                                                              delegate:self];
            [_photoDownloadQueue addOperation:imageProcess];
            [_photoDownloadsInProgress setObject:imageProcess forKey:photoKey];
        }
        
        
        return [self blankImageForIndexPath:indexPath];
    } else {
        
        return photo;
    }
}

- (void)shufflePhotos {
    
    if (!self.finishedProcessingPhotos) {
        return;
    }
    
    NSArray *shuffledPhotosArray = [self shuffleArray:self.photosArray];
    self.photosArray = Nil;
    self.photosArray = [NSArray arrayWithArray:shuffledPhotosArray];
    
    if (self.delegate) {
        [self.delegate reloadAllCells];
    }
}

- (NSArray *)shuffleArray:(NSArray *)array {
    
    NSMutableArray *sourceArray = [NSMutableArray arrayWithArray:array];
    
    NSMutableArray *shuffledArray = [NSMutableArray array];
    while (sourceArray.count) {
        
        NSInteger randomIndex = arc4random() % sourceArray.count;
        
        id randomObject = [sourceArray objectAtIndex:randomIndex];
        [shuffledArray addObject:randomObject];
        [sourceArray removeObjectAtIndex:randomIndex];
    }
    
    return shuffledArray;
}

#pragma mark Photo Operation Delegate

- (void)imageProcessorDidFinish:(AWProcessOperation *)cellImageCreation {
    
    NSString *photoKey = [NSString stringWithFormat:@"%i", cellImageCreation.indexPath.row];
    [self.photoDownloadsInProgress removeObjectForKey:photoKey];
    
    [self.photosDictionary setObject:cellImageCreation.cellImage forKey:photoKey];
    
    if (self.delegate)
        [self.delegate updateImage:cellImageCreation.cellImage atIndexPath:cellImageCreation.indexPath];
    
    if (self.photosDictionary.count == 8 && !self.finishedProcessingPhotos) {
        self.finishedProcessingPhotos = YES;

        NSArray *keys = [[self.photosDictionary allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
        
        NSMutableArray *photos = [NSMutableArray array];
        for (int i = 0; i < keys.count; i++) {
            
            NSString *key = [keys objectAtIndex:i];
            UIImage *photo = [self.photosDictionary objectForKey:key];
            [photos addObject:photo];
        }
        
        self.photosArray = [NSArray arrayWithArray:photos];
        [self.delegate enableShuffle];
    }
}


@end
