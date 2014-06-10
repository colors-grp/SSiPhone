//
//  H7CollectionViewController.m
//  TheColorsConcorenza
//
//  Created by Heba Gamal on 3/26/14.
//  Copyright (c) 2014 Heba Gamal. All rights reserved.
//

#import "H7CollectionViewController.h"
#import "H7FavouriteCategoryCell.h"
#import "MyCategory.h"

#import "H7Shahryar.h"
#import "H7ManElQatel.h"
#import "H7Mosalslat.h"
#import "H7SallySyamak.h"

#import <CoreData+MagicalRecord.h>

@interface H7CollectionViewController () {
    NSMutableArray *favouriteArray;
}
@end

@implementation H7CollectionViewController

- (void)viewDidLoad
{
    /* Setting background image */
    UIImage *background = [UIImage imageNamed: @"bg_all_4.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage: background];
    [self.view insertSubview: imageView atIndex:0];
    
    // Get Category Array
    favouriteArray = [[MyCategory MR_findAll] mutableCopy];
    
    // Setting Categories Images
    [self.shahryar_button setBackgroundImage:[UIImage imageNamed: @"CategoriesIcons/4.png"] forState:UIControlStateNormal];
    [self.manElQatel_button setBackgroundImage:[UIImage imageNamed: @"CategoriesIcons/3.png"] forState:UIControlStateNormal];
    [self.mosalslat_button setBackgroundImage:[UIImage imageNamed: @"CategoriesIcons/2.png"] forState:UIControlStateNormal];
    [self.sallySyamak_button setBackgroundImage:[UIImage imageNamed: @"CategoriesIcons/1.png"] forState:UIControlStateNormal];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"goToShahryar"]) {
        for (int i = 0; i < [favouriteArray count]; i++) {
            MyCategory *curCat = [favouriteArray objectAtIndex:i];
            if([[curCat categoryName] isEqualToString:@"shahryar"]) {
                H7Shahryar *view = [segue destinationViewController];
                view.currentCategory = curCat;
                break;
            }
        }
    }
    if([[segue identifier] isEqualToString:@"goToManElQatel"]) {
        for (int i = 0; i < [favouriteArray count]; i++) {
            MyCategory *curCat = [favouriteArray objectAtIndex:i];
            if([[curCat categoryName] isEqualToString:@"manElQatel"]) {
                H7Shahryar *view = [segue destinationViewController];
                view.currentCategory = curCat;
                break;
            }
        }

    }
    if([[segue identifier] isEqualToString:@"goToMosalslat"]) {
        for (int i = 0; i < [favouriteArray count]; i++) {
            MyCategory *curCat = [favouriteArray objectAtIndex:i];
            if([[curCat categoryName] isEqualToString:@"mosalslat"]) {
                H7Shahryar *view = [segue destinationViewController];
                view.currentCategory = curCat;
                break;
            }
        }

    }
    if([[segue identifier] isEqualToString:@"goToSallySyamak"]) {
        for (int i = 0; i < [favouriteArray count]; i++) {
            MyCategory *curCat = [favouriteArray objectAtIndex:i];
            if([[curCat categoryName] isEqualToString:@"sallySyamak"]) {
                H7Shahryar *view = [segue destinationViewController];
                view.currentCategory = curCat;
                break;
            }
        }
    }
}



@end
