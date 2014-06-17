//
//  H7MosalslatQuizStart.h
//  TheColorsConcorenza
//
//  Created by Heba Gamal on 6/16/14.
//  Copyright (c) 2014 Heba Gamal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCard.h"

@interface H7MosalslatQuizStart : UIViewController <UITableViewDataSource , UITableViewDelegate>

@property (strong , nonatomic) MyCard *currentCard;

@property (weak, nonatomic) IBOutlet UIImageView *mosalsalImage;
@property (weak, nonatomic) IBOutlet UITextView *question;
@property (weak, nonatomic) IBOutlet UITableView *choices;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;


@end
