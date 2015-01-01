//
//  AWCircularViewController.m
//  Cloud On Code Challenge
//
//  Created by Zo on 2/3/14.
//  Copyright (c) 2014 Alonzo Wilkins. All rights reserved.
//

#import "AWCircularViewController.h"

#import "AWCircularLayout.h"

#import "AWPhotoCell.h"



@interface AWCircularViewController ()

@property (nonatomic, strong) UIBarButtonItem *shuffleButton;

@property (nonatomic) CGFloat photoViewWidth;

@end

@implementation AWCircularViewController

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
	// Do any additional setup after loading the view.
    
    
    self.photoViewWidth = 50;
    
    self.shuffleButton = [[UIBarButtonItem alloc] initWithTitle:@"Shuffle" style:UIBarButtonItemStylePlain target:self action:@selector(shuffleItems)];
    self.navigationItem.rightBarButtonItem = self.shuffleButton;
    
    if (![[AWImageStore sharedInstance] finishedProcessingPhotos])
        self.shuffleButton.enabled = NO;
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[AWPhotoCell class] forCellWithReuseIdentifier:@"Cell"];
    
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.collectionView.autoresizesSubviews = NO;
    
    [self.view addSubview:self.collectionView];

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
    
    return 8;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    AWPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // configure Cell
    UIImage *photoImage = [[AWImageStore sharedInstance] imageForCellAtIndexPath:indexPath];
    cell.imageView.image = photoImage;
    
    return cell;
}

#pragma mark - Shuffle Button

- (void)shuffleItems {
    
    [[AWImageStore sharedInstance] shufflePhotos];
}

#pragma  mark - Image Processor Delegate

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




@end
