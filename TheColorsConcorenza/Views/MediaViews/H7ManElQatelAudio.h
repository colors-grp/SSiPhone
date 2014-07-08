//
//  H7ManElQatelAudio.h
//  TheColorsConcorenza
//
//  Created by Heba Gamal on 5/27/14.
//  Copyright (c) 2014 Heba Gamal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCard.h"

@interface H7ManElQatelAudio : UIViewController <UIGestureRecognizerDelegate>

@property (strong , nonatomic) MyCard *currentCard;
@property (weak, nonatomic) IBOutlet UIImageView *findTheObjectImage;
@property (weak, nonatomic) IBOutlet UIImageView *bottleImage;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end
