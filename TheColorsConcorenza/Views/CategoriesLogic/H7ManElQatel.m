//
//  H7ManElQatel.m
//  TheColorsConcorenza
//
//  Created by Heba Gamal on 5/26/14.
//  Copyright (c) 2014 Heba Gamal. All rights reserved.
//

#import "H7ManElQatel.h"
#import "H7ManElQatelAudio.h"

@interface H7ManElQatel ()

@end

@implementation H7ManElQatel

- (void)viewDidLoad
{
    /* Setting background image */
    UIImage *background = [UIImage imageNamed: @"bg_all_4.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage: background];
    [self.view insertSubview: imageView atIndex:0];
    
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/* Collection Data source */

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 35;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ManElQatelCell" forIndexPath:indexPath];
    UIImageView *image = (UIImageView*)[cell viewWithTag:300];
    NSString *imagePath = [NSString stringWithFormat:@"Categories/manElQatel/cards/%d/img.png" , indexPath.row + 1];
    NSLog(@"%@" , imagePath);
    image.image = [UIImage imageNamed:imagePath];
    return  cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    H7ManElQatelAudio *audio = [segue destinationViewController];
    NSArray *indexPaths = [self.cardsCollection indexPathsForSelectedItems];
    NSIndexPath *index = [indexPaths objectAtIndex:0];
    audio.cardId = index.row+1;
}

@end
