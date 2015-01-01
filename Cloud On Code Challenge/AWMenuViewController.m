//
//  AWMenuViewController.m
//  Cloud On Code Challenge
//
//  Created by Zo on 2/3/14.
//  Copyright (c) 2014 Alonzo Wilkins. All rights reserved.
//

#import "AWMenuViewController.h"

#import "AWCircularLayout.h"
#import "AWImageStore.h"

#import "AWCircularViewController.h"
#import "AWPagingCarouselVC.h"

#import "AWInfiniteFlowLayout.h"

@interface AWMenuViewController ()

@end

@implementation AWMenuViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    if (indexPath.row == 0) {
        cell.textLabel.text = @"5 Cell Carousel";
    } else {
        
        cell.textLabel.text = @"Circular Carousel";
    }
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    AWImageStore *imageStore = [AWImageStore sharedInstance];

    if (indexPath.row == 0) {
        
        AWInfiniteFlowLayout *flowLayout = [[AWInfiniteFlowLayout alloc] init];
        flowLayout.cellCount = 8;
        flowLayout.cellWidth = CGRectGetWidth(self.view.bounds) / 5;
        flowLayout.triggerUpdate = NO;
        
        AWPagingCarouselVC *detailViewController = [[AWPagingCarouselVC alloc] initWithCollectionViewLayout:flowLayout];
        imageStore.delegate = detailViewController;

        // Push the view controller.
        [self.navigationController pushViewController:detailViewController animated:YES];

    } else {
        
        AWCircularLayout *circularLayout = [[AWCircularLayout alloc] init];
        circularLayout.cellCount = 8;
        circularLayout.cellWidth = 100;
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
            circularLayout.radius = 200;
        else
            circularLayout.radius = 120;

        AWCircularViewController *detailViewController = [[AWCircularViewController alloc] initWithCollectionViewLayout:circularLayout];
        imageStore.delegate = detailViewController;
        
        // Push the view controller.
        [self.navigationController pushViewController:detailViewController animated:YES];

    }
}

 

@end
