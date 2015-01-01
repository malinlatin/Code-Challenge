//
//  AWProcessOperation.h
//  Cloud On Code Challenge
//
//  Created by Zo on 2/4/14.
//  Copyright (c) 2014 Alonzo Wilkins. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AWProcessOperation;

@protocol AWImageProcessorDelegate <NSObject>

- (void)imageProcessorDidFinish:(AWProcessOperation *)cellImageCreation;

@end


@interface AWProcessOperation : NSOperation

@property (nonatomic, assign) id <AWImageProcessorDelegate> delegate;

@property (nonatomic, strong, readonly) UIImage *cellImage;

@property (nonatomic, strong, readonly) NSURL *url;
@property (nonatomic, readonly) CGSize cellSize;
@property (nonatomic, strong, readonly) NSIndexPath *indexPath;

- (id)initWithURL:(NSURL *)url
         cellSize:(CGSize)cellSize
        indexPath:(NSIndexPath *)indexPath
         delegate:(id <AWImageProcessorDelegate>)delegate;

@end
