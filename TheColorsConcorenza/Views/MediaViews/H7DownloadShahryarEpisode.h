//
//  H7DownloadShahryarEpisode.h
//  TheColorsConcorenza
//
//  Created by Heba Gamal on 7/5/14.
//  Copyright (c) 2014 Heba Gamal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCard.h"

@interface H7DownloadShahryarEpisode : UIViewController

@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;
@property (strong , nonatomic) MyCard *currentCard;
@property (weak, nonatomic) IBOutlet UIImageView *episodeImage;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@end
