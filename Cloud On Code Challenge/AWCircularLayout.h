//
//  AWCircularLayout.h
//  Cloud On Code Challenge
//
//  Created by Zo on 2/3/14.
//  Copyright (c) 2014 Alonzo Wilkins. All rights reserved.
//

#import <UIKit/UIKit.h>

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)
#define RADIANS_TO_DEGREES(radians) ((radians) * (180.0 / M_PI))

@interface AWCircularLayout : UICollectionViewFlowLayout


// initial Variables for layout
@property (nonatomic, assign) BOOL initialValuesSet;

@property (nonatomic, assign) CGPoint center;
@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, assign) CGFloat rootAngle;


@property (nonatomic, assign) CGFloat offsetAngle; 
@property (nonatomic, assign) NSInteger cellCount;

@property (nonatomic, assign) CGFloat cellWidth;

@end
