//
//  AWPhotoCell.m
//  Cloud On Code Challenge
//
//  Created by Zo on 2/4/14.
//  Copyright (c) 2014 Alonzo Wilkins. All rights reserved.
//

#import "AWPhotoCell.h"
@implementation AWPhotoCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // Initialization code
        _imageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_imageView];
    }
    return self;
}


@end
