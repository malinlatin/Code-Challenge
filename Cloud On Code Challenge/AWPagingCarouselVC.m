//
//  AWPagingCarouselVC.m
//  Cloud On Code Challenge
//
//  Created by Zo on 2/3/14.
//  Copyright (c) 2014 Alonzo Wilkins. All rights reserved.
//

#define D_NUMBER_OF_CELLS 8
#define D_CELL_SPACING 10.0

#import "AWPagingCarouselVC.h"

#import "AWInfiniteFlowLayout.h"
#import "AWPhotoCell.h"

@interface AWPagingCarouselVC ()


@property (nonatomic) CGFloat leftBoundary;
@property (nonatomic) CGFloat rightBoundary;

@property (nonatomic, strong) UIBarButtonItem *shuffleButton;

@property (nonatomic, strong) UIScrollView *pagingScrollView;

@property (nonatomic) BOOL isResetting;

@end

@implementation AWPagingCarouselVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.shuffleButton = [[UIBarButtonItem alloc] initWithTitle:@"Shuffle" style:UIBarButtonItemStylePlain target:self action:@selector(shuffleItems)];
    self.navigationItem.rightBarButtonItem = self.shuffleButton;
    
    if (![[AWImageStore sharedInstance] finishedProcessingPhotos])
        self.shuffleButton.enabled = NO;

    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[AWPhotoCell class] forCellWithReuseIdentifier:@"Cell"];
    
    self.collectionView.pagingEnabled = YES;
    
    
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.collectionView.autoresizesSubviews = NO;
    
    AWInfiniteFlowLayout *layout = (AWInfiniteFlowLayout *)self.collectionViewLayout;
    CGFloat cellWidth = layout.cellWidth;
    
    self.leftBoundary = CGRectGetMidX(self.view.bounds) - (cellWidth / 2);
    self.rightBoundary = CGRectGetMidX(self.view.bounds) + (cellWidth / 2);

    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return D_NUMBER_OF_CELLS;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    AWPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // configure Cell
    UIImage *photoImage = [[AWImageStore sharedInstance] imageForCellAtIndexPath:indexPath];
    cell.imageView.image = photoImage;
    
    return cell;
}

#pragma  mark - Image Processor Delegate

- (void)shuffleItems {
    
    [[AWImageStore sharedInstance] shufflePhotos];
}


- (void)updateImage:(UIImage *)image atIndexPath:(NSIndexPath *)indexPath {
    
    AWPhotoCell *cell = (AWPhotoCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    if (cell) {
        cell.imageView.image = image;
    }
}

- (void)enableShuffle {
    
    self.shuffleButton.enabled = YES;
}

- (void)reloadAllCells {
    
    [self.collectionView reloadData];
}

#pragma mark - Infinite ScrollView Data Source


- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
//    [self resetOffsets];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    if (!decelerate)
        [self resetOffsets];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    [self resetOffsets];
    
}

- (void)resetOffsets {
    
    AWInfiniteFlowLayout *layout = (AWInfiniteFlowLayout *)self.collectionViewLayout;
    layout.triggerUpdate = YES;
}





@end
