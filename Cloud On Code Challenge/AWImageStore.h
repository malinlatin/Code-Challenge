//
//  AWImageStore.h
//  Cloud On Code Challenge
//
//  Created by Zo on 2/4/14.
//  Copyright (c) 2014 Alonzo Wilkins. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AWProcessOperation.h"


@protocol AWImageStoreDelegate <NSObject>

- (void)updateImage:(UIImage *)image atIndexPath:(NSIndexPath *)indexPath;
- (void)enableShuffle;
- (void)reloadAllCells;

@end


@interface AWImageStore : NSObject <AWImageProcessorDelegate>

@property (nonatomic, assign) id <AWImageStoreDelegate> delegate;

@property (nonatomic) BOOL finishedProcessingPhotos;

@property (nonatomic, strong) NSMutableDictionary *photoDownloadsInProgress;
@property (nonatomic, strong) NSOperationQueue *photoDownloadQueue;

+ (id)sharedInstance;

- (void)shufflePhotos;

- (UIImage *)imageForCellAtIndexPath:(NSIndexPath *)indexPath;

@end
