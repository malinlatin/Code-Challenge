//
//  AWInfiniteFlowLayout.m
//  Cloud On Code Challenge
//
//  Created by Zo on 2/4/14.
//  Copyright (c) 2014 Alonzo Wilkins. All rights reserved.
//

#import "AWInfiniteFlowLayout.h"


@interface AWInfiniteFlowLayout ()

@property (nonatomic, strong) NSMutableArray *indexPaths;

@property (nonatomic) CGFloat leftBoundary;
@property (nonatomic) CGFloat rightBoundary;


@end

@implementation AWInfiniteFlowLayout

- (id)init {
    
    self = [super init];
    if (self) {
        
    }
    return self;
}


- (void)resetOffsets {
    
    if (!_triggerUpdate)
        return;
    
    if (self.collectionView.contentOffset.x < self.minimumOffsetX ) {
        
        NSIndexPath *lastIndexPath = [self.indexPaths lastObject];
        
        [self.indexPaths removeObjectAtIndex:self.indexPaths.count - 1];
        [self.indexPaths insertObject:lastIndexPath atIndex:0];

        CGPoint contentOffset = self.collectionView.contentOffset;
        contentOffset.x = self.minimumOffsetX;
        self.collectionView.contentOffset = contentOffset;
        
    } else if (self.collectionView.contentOffset.x > self.minimumOffsetX) {
        
        NSIndexPath *firstIndexPath = [self.indexPaths objectAtIndex:0];
        
        [self.indexPaths removeObjectAtIndex:0];
        [self.indexPaths addObject:firstIndexPath];

        
        CGPoint contentOffset = self.collectionView.contentOffset;
        contentOffset.x = self.minimumOffsetX;
        self.collectionView.contentOffset = contentOffset;
        
    }
    self.triggerUpdate = NO;
}

#pragma mark - Prepare Layout


- (void)prepareLayout { 
    
    [super prepareLayout];
    
    if (!self.initialValuesSet) {
        
        _indexPaths = [NSMutableArray array];
        
        for (int i = 0; i < _cellCount; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [_indexPaths addObject:indexPath];
        }
        
        self.minimumOffsetX = self.cellWidth;
        
        CGPoint contentOffset = self.collectionView.contentOffset;
        contentOffset.x = self.minimumOffsetX;
        self.collectionView.contentOffset = contentOffset;
        

        self.initialValuesSet = YES;
    }
    
    
    [self resetOffsets];

    self.leftBoundary = CGRectGetMidX(self.collectionView.bounds) - (self.cellWidth / 2) + self.collectionView.contentOffset.x;
    self.rightBoundary = CGRectGetMidX(self.collectionView.bounds) + (self.cellWidth / 2) + self.collectionView.contentOffset.x;

    
//    NSLog(@"self.bounds is %f", self.collectionView.bounds.size.width);
//    NSLog(@"content size is %f", self.collectionViewContentSize.width);
//    NSLog(@"content offset is %f", self.collectionView.contentOffset.x);
//    NSLog(@"left boundary is %f", self.leftBoundary);
}


- (CGSize)collectionViewContentSize {
    
    CGSize contentSize = CGSizeMake(self.cellWidth * 7, self.collectionView.bounds.size.height / 2);
    
    
    return contentSize;
}

#pragma mark - Layout Attributes




- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    
    
    
    attributes.size = CGSizeMake(_cellWidth, _cellWidth);
    
    return attributes;
}

#pragma mark Set Boundaries for visible cells


- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    NSMutableArray *attributes = [NSMutableArray array];
    
    for (NSInteger i = 0; i < _indexPaths.count; i++) {
        
        NSIndexPath *indexPath = [_indexPaths objectAtIndex:i];
        
        UICollectionViewLayoutAttributes *attribute = [self layoutAttributesForItemAtIndexPath:indexPath];
        
        CGFloat origionX = i * self.cellWidth;
        attribute.frame  = CGRectMake(origionX, 0, self.cellWidth, self.collectionViewContentSize.height);
        
        
        
        // increase the size
        CGFloat adjustedOrigionX = origionX + self.collectionView.contentOffset.x;
        CGFloat viewCenterX = adjustedOrigionX + (self.cellWidth / 2);
        
        if (viewCenterX >= self.leftBoundary && viewCenterX <= self.rightBoundary) {
            
            CGFloat range = (self.rightBoundary - self.leftBoundary);
            CGFloat position = viewCenterX - self.leftBoundary;
            CGFloat ratio = position / range;
            
            CGFloat insetAmount = sinf(ratio * M_PI) * 0.2;

            
            attribute.transform3D = CATransform3DMakeScale(1 + insetAmount, 1 + insetAmount, 0);
            
            attribute.zIndex = _indexPaths.count - 1;
        } else {
            attribute.transform3D = CATransform3DIdentity;
            attribute.zIndex = 0;
        }
        
        [attributes addObject: attribute];
        
    }
    
    return attributes;
}

@end
