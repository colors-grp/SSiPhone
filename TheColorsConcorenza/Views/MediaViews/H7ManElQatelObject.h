//
//  H7ManElQatelObject.h
//  TheColorsConcorenza
//
//  Created by Heba Gamal on 7/6/14.
//  Copyright (c) 2014 Heba Gamal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCard.h"

@interface H7ManElQatelObject : UIViewController

@property (strong , nonatomic) MyCard *currentCard;
@property (weak, nonatomic) IBOutlet UIImageView *objectImage;
@property (weak, nonatomic) IBOutlet UITextView *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end
