//
//  H7CollectionCardInfoView.h
//  TheColorsConcorenza
//
//  Created by Heba Gamal on 4/7/14.
//  Copyright (c) 2014 Heba Gamal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCard.h"

@interface H7CollectionCardInfoView : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *cardImage;
@property (weak, nonatomic) IBOutlet UILabel *cardNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *purchasedOnLabel;
@property (weak, nonatomic) IBOutlet UILabel *imagesCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *VideosCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *musicCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *gamesCountLabel;

@property (weak, nonatomic) IBOutlet UIImageView *mediaTypeImage;
@property (weak, nonatomic) IBOutlet UILabel *mediaTypeLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControll;

@property (strong) MyCard *currentCard;

-(IBAction)segmentControllValueChanged:(id)sender;

@end
