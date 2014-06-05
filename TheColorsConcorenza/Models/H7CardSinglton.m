//
//  H7CardSinglton.m
//  TheColorsConcorenza
//
//  Created by Heba Gamal on 6/5/14.
//  Copyright (c) 2014 Heba Gamal. All rights reserved.
//

#import "H7CardSinglton.h"
#import <CoreData+MagicalRecord.h>

@implementation H7CardSinglton {
    MyCard *currentCard;
}

+(H7CardSinglton*)sharedInstance {
    static H7CardSinglton *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[H7CardSinglton alloc] init];
    });
    return _sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        currentCard = nil;
    }
    return self;
}

-(void)setWithCard:(MyCard*)card {
    currentCard = card;
}

-(void)updateScore:(NSNumber*)score {
    if(score.intValue > currentCard.cardScore.intValue){
        currentCard.cardScore = score;
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    }
}

@end
