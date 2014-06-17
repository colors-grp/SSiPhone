//
//  H7ScoreboardViewController.h
//  TheColorsConcorenza
//
//  Created by Heba Gamal on 3/26/14.
//  Copyright (c) 2014 Heba Gamal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface H7ScoreboardViewController : UIViewController <UICollectionViewDataSource , UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (weak, nonatomic) IBOutlet UITableView *scoreBoardTable;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UICollectionView *categoriesCollection;

-(IBAction)segmentControllValueChanged:(id)sender;

@end
