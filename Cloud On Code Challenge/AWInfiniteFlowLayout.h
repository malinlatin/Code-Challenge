//
//  AWInfiniteFlowLayout.h
//  Cloud On Code Challenge
//
//  Created by Zo on 2/4/14.
//  Copyright (c) 2014 Alonzo Wilkins. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AWInfiniteFlowLayout : UICollectionViewFlowLayout

@property (nonatomic) CGFloat cellWidth;
@property (nonatomic) NSUInteger cellCount;

@property (nonatomic) NSUInteger initialValuesSet;
@property (nonatomic) CGFloat minimumOffsetX;

@property (nonatomic) BOOL triggerUpdate;

@end
