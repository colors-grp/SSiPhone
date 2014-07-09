//
//  H7NotificationViewController.m
//  TheColorsConcorenza
//
//  Created by Heba Gamal on 3/26/14.
//  Copyright (c) 2014 Heba Gamal. All rights reserved.
//

#import "H7NotificationViewController.h"
#import "MyCategory.h"

#import <CoreData+MagicalRecord.h>
@interface H7NotificationViewController ()

@end

@implementation H7NotificationViewController {
    NSMutableArray *myCats;
    MyCategory *curCat;
}

- (void)viewDidLoad
{
    /* Setting background image */
    int height =  [[UIScreen mainScreen] bounds].size.height;
    if(height > 480){
        UIImage *background = [UIImage imageNamed: @"bg_all_5.png"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage: background];
        [self.view insertSubview: imageView atIndex:0];
    }
    else{
        UIImage *background = [UIImage imageNamed: @"bg_all_4.png"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage: background];
        [self.view insertSubview: imageView atIndex:0];
    }
    
    myCats =  [[MyCategory MR_findAllSortedBy:@"categoryId" ascending:YES] mutableCopy];
    curCat = [myCats objectAtIndex:0];
    self.helpImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_help.png" , curCat.categoryId]];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [myCats count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"helpCell" forIndexPath:indexPath];
    UIImageView *image = (UIImageView*)[cell viewWithTag:1000];
    MyCategory* myCat = [myCats objectAtIndex:indexPath.row];
    image.image = [UIImage imageNamed:[NSString stringWithFormat:@"CategoriesIcons/%@.png" , [myCat valueForKey:@"categoryId"]]];
    if([[NSString stringWithFormat:@"%@" ,  curCat.categoryId ] isEqualToString:[NSString stringWithFormat:@"%@" , myCat.categoryId]]){
        image.image = [UIImage imageNamed:[NSString stringWithFormat:@"CategoriesIcons/%@_selected.png" , [myCat valueForKey:@"categoryId"]]];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    curCat = [myCats objectAtIndex:indexPath.row];
    self.helpImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_help.png" , curCat.categoryId]];
    [self.categoriesCollection reloadData];
}



@end
