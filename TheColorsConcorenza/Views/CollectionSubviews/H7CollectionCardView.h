//
//  H7CollectionCardView.h
//  TheColorsConcorenza
//
//  Created by Heba Gamal on 4/6/14.
//  Copyright (c) 2014 Heba Gamal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCategory.h"

@interface H7CollectionCardView : UIViewController <UICollectionViewDataSource>

@property (strong) MyCategory *currentCategory;
@property (weak, nonatomic) IBOutlet UICollectionView *cardsCollection;

@end
