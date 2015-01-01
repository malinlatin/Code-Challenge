//
//  AWCircularLayout.m
//  Cloud On Code Challenge
//
//  Created by Zo on 2/3/14.
//  Copyright (c) 2014 Alonzo Wilkins. All rights reserved.
//

#import "AWCircularLayout.h"


#define D_ROTATION_SPEED_ADJUSTMENT 4

@implementation AWCircularLayout

- (id)init {
    
    self = [super init];
    if (self) {
    }
    return self;
}



- (CGFloat)rotationAngle {
    
    // we're hard-coding in the width to not interfere with current behavior
    CGFloat offsetXRatio = self.collectionView.contentOffset.x / (self.collectionViewContentSize.width - self.collectionView.bounds.size.width);
    return (DEGREES_TO_RADIANS(360) * offsetXRatio) * D_ROTATION_SPEED_ADJUSTMENT;
}


// a convinience method for converting angles into a content offset
- (CGFloat)contentOffsetForAngle:(CGFloat)rotationAngle {
    
    
    CGFloat maximumPossibleOffset = (self.collectionViewContentSize.width - self.collectionView.bounds.size.width);
    
    // get the current angle ratio
    CGFloat angleRatio = rotationAngle / DEGREES_TO_RADIANS(360);
    
    // we'll need to adjust for the speed adjustment above
    CGFloat adjustedAngleRatio = angleRatio / D_ROTATION_SPEED_ADJUSTMENT;
    
    // finally, we'll return the correct content offest
    return adjustedAngleRatio * maximumPossibleOffset;
}

- (void)resetContentOffsetIfNeeded {
    
    CGPoint contentOffset = self.collectionView.contentOffset;
    
    CGFloat leftBoundary = [self contentOffsetForAngle:DEGREES_TO_RADIANS(360)];
    CGFloat rightBoundary = [self contentOffsetForAngle:DEGREES_TO_RADIANS(360) * 3];
    
    if (contentOffset.x <= leftBoundary) {
        contentOffset.x += rightBoundary;
    } else if (contentOffset.x >= rightBoundary) {
        contentOffset.x -= leftBoundary;
    }
    self.collectionView.contentOffset = contentOffset;
    
}




- (void)prepareLayout {
    
    [super prepareLayout];
    
    NSLog(@"hit");

    if (!self.initialValuesSet) {
        
        CGSize size = [self collectionViewContentSize];
        _cellCount = [[self collectionView] numberOfItemsInSection:0];
        
        _center = CGPointMake(size.width * 0.5, size.height / 2.0);
        _rootAngle = M_PI_2;
        
        CATransform3D rotationTransform = CATransform3DMakeRotation(DEGREES_TO_RADIANS(-30), 1.0, 0.0, 0.0);
        rotationTransform.m34 = -1.0 / 500;
        
        self.collectionView.layer.sublayerTransform = rotationTransform;

        
        self.collectionView.contentOffset = CGPointMake((self.collectionViewContentSize.width / 2) - (self.collectionView.bounds.size.width / 2), 0);

        
        
        
        self.initialValuesSet = YES;
    }
    
    
    NSLog(@"hit");
    
    [self resetContentOffsetIfNeeded];
    
    CGPoint contentOffset = self.collectionView.contentOffset;
    CGFloat currentWidth = self.collectionView.bounds.size.width;
    CGFloat currentHeight = self.collectionView.bounds.size.height;
    
    self.center = CGPointMake((currentWidth * 0.5) + contentOffset.x,
                                             (currentHeight * 0.5) + contentOffset.y);
    self.offsetAngle = [self rotationAngle];
}


- (CGSize)collectionViewContentSize {
    
    CGFloat contentSizeWidth = self.collectionView.bounds.size.width * 10;
    CGSize contentSize = CGSizeMake(contentSizeWidth, self.collectionView.bounds.size.height);
    
    return contentSize;
}

#pragma mark - Layout Attributes




- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    // we'll multiply the angle based on the section and row
    CGFloat initialCellAngle =  (DEGREES_TO_RADIANS(360) / _cellCount) * indexPath.row;
    
    
    CGFloat angle = initialCellAngle + _offsetAngle;
    CGFloat ringRadius = _radius;
    
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    attributes.size = CGSizeMake(_cellWidth, _cellWidth);
    attributes.center = _center;
    
    CGFloat translationX = ringRadius * cosf(angle);
    CGFloat translationY = 0;
    CGFloat translationZ = ringRadius * sinf(angle);    // z position is adjusted here
    
    
    CATransform3D translation = CATransform3DMakeTranslation(translationX, translationY, translationZ);
    CATransform3D rotation = CATransform3DMakeRotation(DEGREES_TO_RADIANS(90) - angle, 0.0, 1.0, 0.0);
    
    CATransform3D transform = CATransform3DConcat(rotation, translation);

    attributes.transform3D = transform;
    
    
    return attributes;
}

#pragma mark Set Boundaries for visible cells


- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    NSMutableArray *attributes = [NSMutableArray array];
    
        for (NSInteger i = 0; i < _cellCount; i++) {
            
            NSUInteger rowForCellNumber = i ;
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:rowForCellNumber inSection:0];
            [attributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
        }
    
    return attributes;
}

@end
