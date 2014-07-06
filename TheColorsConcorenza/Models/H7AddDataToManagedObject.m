//
//  H7AddDataToManagedObject.m
//  TheColorsConcorenza
//
//  Created by Heba Gamal on 4/10/14.
//  Copyright (c) 2014 Heba Gamal. All rights reserved.
//

#import "H7AddDataToManagedObject.h"

#import "User.h"
#import "MyCard.h"
#import "MyCategory.h"
#import "CardImage.h"
#import "SponsorPrograms.h"
#import <CoreData+MagicalRecord.h>


@implementation H7AddDataToManagedObject

-(void) saveData {
    NSError* err = nil;
    NSString* dataPath = [[NSBundle mainBundle] pathForResource:@"cards" ofType:@"json"];
    NSArray* cardsArray = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:dataPath]options:kNilOptions error:&err];
    
    NSArray *check = [MyCategory MR_findAll];
    if([check count] == 0) {
        //save data with magical record
        NSArray *tmp  = [NSArray arrayWithObjects:@"sallySyamak" , @"mosalslat", @"manElQatel" , @"shahryar" , nil];
        NSArray *tmp1  = [NSArray arrayWithObjects:[NSNumber numberWithInt:1] , [NSNumber numberWithInt:2], [NSNumber numberWithInt:3] , [NSNumber numberWithInt:4] , nil];
        NSMutableSet *userCategories = [[NSMutableSet alloc] init];
        NSNumber *favourite = [NSNumber numberWithBool:NO];
        for (int i=0 ; i < [tmp count]; i++) {
            MyCategory *newCat = [MyCategory MR_createEntity];
            newCat.categoryId = [tmp1 objectAtIndex:i];
            newCat.categoryName = [tmp objectAtIndex:i];
            newCat.isFavourite = favourite;
            newCat.userScore = @"0";
            newCat.userCards = [NSNumber numberWithInt:0];
            
            if([newCat.categoryName isEqualToString:@"shahryar"]) {
                NSMutableSet *cardsSet = [[NSMutableSet alloc] init];
                for (int j=0 ; j<[cardsArray count]; j++) {
                    NSString *curCatId = @"4";
                    NSDictionary *dict = [cardsArray objectAtIndex:j];
                    if([[dict objectForKey:@"category"] isEqualToString:curCatId]) {
                        MyCard *newCard = [MyCard MR_createEntity];
                        newCard.cardId = [NSNumber numberWithInt:[[dict objectForKey:@"id"] intValue]];
                        newCard.cardName = [dict objectForKey:@"name"];
                        newCard.cardScore = [NSNumber numberWithInt:[[dict objectForKey:@"score"] intValue]];
                        newCard.isAvailble = [NSNumber numberWithBool:NO];
                        newCard.isEpisodeDownloaded = [NSNumber numberWithBool:NO];
                        newCard.isShahryarFindTheBottleDownloaded = [NSNumber numberWithBool:NO];
                        [cardsSet addObject:newCard];
                    }
                }
                //Testing 3dd l elements fe cardset
                //Testing if scoreboard hatla3 l images l sa7 wla la2
                newCat.hasCards = [NSSet setWithArray:[cardsSet allObjects]];
                NSLog(@"cards set size = %d" , [cardsSet count]);
            }
            
            
            if([newCat.categoryName isEqualToString:@"manElQatel"]) {
                NSMutableSet *cardsSet = [[NSMutableSet alloc] init];
                for (int j=0 ; j<[cardsArray count]; j++) {
                    NSString *curCatId = @"3";
                    NSDictionary *dict = [cardsArray objectAtIndex:j];
                    if([[dict objectForKey:@"category"] isEqualToString:curCatId]) {
                        MyCard *newCard = [MyCard MR_createEntity];
                        newCard.cardId = [NSNumber numberWithInt:[[dict objectForKey:@"id"] intValue]];
                        newCard.cardName = [dict objectForKey:@"name"];
                        newCard.cardScore = [NSNumber numberWithInt:[[dict objectForKey:@"score"] intValue]];
                        newCard.isAvailble = [NSNumber numberWithBool:NO];
                        newCard.isFeenElSela7Played = [NSNumber numberWithBool:NO];
                        newCard.isManElQatelObjectDownloaded =[NSNumber numberWithBool:NO];
                        [cardsSet addObject:newCard];
                    }
                }
                //Testing 3dd l elements fe cardset
                //Testing if scoreboard hatla3 l images l sa7 wla la2
                newCat.hasCards = [NSSet setWithArray:[cardsSet allObjects]];
                NSLog(@"cards set size = %d" , [cardsSet count]);
            }
            
            
            if([newCat.categoryName isEqualToString:@"mosalslat"]) {
                NSMutableSet *cardsSet = [[NSMutableSet alloc] init];
                for (int j=0 ; j<[cardsArray count]; j++) {
                    NSString *curCatId = @"2";
                    NSDictionary *dict = [cardsArray objectAtIndex:j];
                    if([[dict objectForKey:@"category"] isEqualToString:curCatId]) {
                        MyCard *newCard = [MyCard MR_createEntity];
                        newCard.cardId = [NSNumber numberWithInt:[[dict objectForKey:@"id"] intValue]];
                        newCard.cardName = [dict objectForKey:@"name"];
                        newCard.cardScore = [NSNumber numberWithInt:[[dict objectForKey:@"score"] intValue]];
                        newCard.isAvailble = [NSNumber numberWithBool:NO];
                        newCard.areMosalslatQuestionsDownloaded = [NSNumber numberWithBool:NO];
                        [cardsSet addObject:newCard];
                        
                    }
                }
                //Testing 3dd l elements fe cardset
                //Testing if scoreboard hatla3 l images l sa7 wla la2
                newCat.hasCards = [NSSet setWithArray:[cardsSet allObjects]];
                NSLog(@"cards set size = %d" , [cardsSet count]);
            }
            
            
            if([newCat.categoryName isEqualToString:@"sallySyamak"]) {
                NSMutableSet *cardsSet = [[NSMutableSet alloc] init];
                for (int j=0 ; j<[cardsArray count]; j++) {
                    NSString *curCatId = @"1";
                    NSDictionary *dict = [cardsArray objectAtIndex:j];
                    if([[dict objectForKey:@"category"] isEqualToString:curCatId]) {
                        MyCard *newCard = [MyCard MR_createEntity];
                        newCard.cardId = [NSNumber numberWithInt:[[dict objectForKey:@"id"] intValue]];
                        newCard.cardName = [dict objectForKey:@"name"];
                        newCard.cardScore = [NSNumber numberWithInt:[[dict objectForKey:@"score"] intValue]];
                        newCard.isAvailble = [NSNumber numberWithBool:NO];
                        [cardsSet addObject:newCard];
                    }
                }
                //Testing 3dd l elements fe cardset
                //Testing if scoreboard hatla3 l images l sa7 wla la2
                newCat.hasCards = [NSSet setWithArray:[cardsSet allObjects]];
                NSLog(@"cards set size = %d" , [cardsSet count]);
            }
            
            [userCategories addObject:newCat];
        }
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    }
}



@end
