//
//  H7CardSinglton.h
//  TheColorsConcorenza
//
//  Created by Heba Gamal on 6/5/14.
//  Copyright (c) 2014 Heba Gamal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyCard.h"

@interface H7CardSinglton : NSObject

+(H7CardSinglton*)sharedInstance;
-(void)setWithCard:(MyCard*)card;
-(void)updateScore:(NSNumber*)score;

@end
