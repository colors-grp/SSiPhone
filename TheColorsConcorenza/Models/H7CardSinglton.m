//
//  H7CardSinglton.m
//  TheColorsConcorenza
//
//  Created by Heba Gamal on 6/5/14.
//  Copyright (c) 2014 Heba Gamal. All rights reserved.
//

#import "H7CardSinglton.h"
#import <CoreData+MagicalRecord.h>
#import <AFNetworking/AFNetworking.h>
#import "H7ConstantsModel.h"
#import "User.h"

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
        NSArray *a = [User MR_findAll];
        User *u = [a firstObject];
        NSString *userId = u.userAccountId;
        NSString *catId = @"1";
        NSString *cardId = [NSString stringWithFormat:@"%@" , currentCard.cardId];
        NSString *Score = [NSString stringWithFormat:@"%@" , score];
        [self updateScoreInDBWithUserId:userId catId:cardId cardId:catId score:Score];

    }
}

- (void) updateScoreInDBWithUserId:(NSString*)userId catId:(NSString*)catId cardId:(NSString*)cardId score:(NSString*)score {
    NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@update_score_for_card/format/json/userId/%@/catId/%@/cardId/%@/score/%@", PLATFORM_URL , userId,catId,cardId,score]];
    NSLog(@"%@" , url);
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:url];
    AFJSONRequestOperation *request = [AFJSONRequestOperation JSONRequestOperationWithRequest:urlRequest success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"%@" , JSON);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        // Get from core data
        NSLog(@"Failed to update score in server");
    }];
    [request start];
}

@end
