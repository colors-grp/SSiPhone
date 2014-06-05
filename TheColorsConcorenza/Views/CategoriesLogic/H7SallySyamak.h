//
//  H7SallySyamak.h
//  TheColorsConcorenza
//
//  Created by Heba Gamal on 5/26/14.
//  Copyright (c) 2014 Heba Gamal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCategory.h"

@interface H7SallySyamak : UIViewController <UICollectionViewDataSource , UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *cardsCollection;
@property (strong) MyCategory *currentCategory;

@end
