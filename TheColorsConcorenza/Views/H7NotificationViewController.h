//
//  H7NotificationViewController.h
//  TheColorsConcorenza
//
//  Created by Heba Gamal on 3/26/14.
//  Copyright (c) 2014 Heba Gamal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface H7NotificationViewController : UIViewController <UICollectionViewDataSource >

@property (weak, nonatomic) IBOutlet UITableView *notificationTable;
@property (weak, nonatomic) IBOutlet UICollectionView *categoriesCollection;
@property (weak, nonatomic) IBOutlet UIImageView *helpImage;

@end
