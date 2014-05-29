//
//  H7FavouriteCategoryCell.h
//  TheColorsConcorenza
//
//  Created by Heba Gamal on 3/30/14.
//  Copyright (c) 2014 Heba Gamal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface H7FavouriteCategoryCell : UITableViewCell

//Market view properties
@property (weak, nonatomic) IBOutlet UIImageView *marketCategoryImage;
@property (weak, nonatomic) IBOutlet UILabel *marketScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *marketCardsLabel;

//Me view properties
@property (weak, nonatomic) IBOutlet UIImageView *meCategoryImage;
@property (weak, nonatomic) IBOutlet UILabel *meScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *meCardsLabel;

//Collection view properties
@property (weak, nonatomic) IBOutlet UIImageView *collectionCategoryImage;
@property (weak, nonatomic) IBOutlet UILabel *collectionScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *collectionCardsLabel;

@end
