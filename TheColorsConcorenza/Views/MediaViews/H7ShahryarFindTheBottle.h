//
//  H7ShahryarFindTheBottle.h
//  TheColorsConcorenza
//
//  Created by Heba Gamal on 6/15/14.
//  Copyright (c) 2014 Heba Gamal. All rights reserved.
//

#import "ViewController.h"
#import "MyCard.h"

@interface H7ShahryarFindTheBottle : UIViewController <UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *findTheBottleImage;
@property (weak, nonatomic) IBOutlet UIImageView *bottleImage;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong , nonatomic) MyCard *currentCard;

@end
