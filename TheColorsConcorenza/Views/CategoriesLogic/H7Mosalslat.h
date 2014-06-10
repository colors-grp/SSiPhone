//
//  H7Mosalslat.h
//  TheColorsConcorenza
//
//  Created by Heba Gamal on 5/26/14.
//  Copyright (c) 2014 Heba Gamal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCategory.h"

@interface H7Mosalslat : UIViewController<UICollectionViewDataSource , UICollectionViewDelegate>

@property (strong) MyCategory *currentCategory;
@property (weak, nonatomic) IBOutlet UICollectionView *cardsCollection;

@end
