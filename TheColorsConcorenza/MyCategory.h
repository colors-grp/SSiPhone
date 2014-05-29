//
//  MyCategory.h
//  TheColorsConcorenza
//
//  Created by Heba Gamal on 5/13/14.
//  Copyright (c) 2014 Heba Gamal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MyCard, User;

@interface MyCategory : NSManagedObject

@property (nonatomic, retain) NSString * allScoreboard;
@property (nonatomic, retain) NSNumber * categoryId;
@property (nonatomic, retain) NSString * categoryName;
@property (nonatomic, retain) NSString * friendScoreboard;
@property (nonatomic, retain) NSNumber * isFavourite;
@property (nonatomic, retain) NSNumber * userCards;
@property (nonatomic, retain) NSNumber * userScore;
@property (nonatomic, retain) NSString * allScoreboardName;
@property (nonatomic, retain) NSString * allScoreboardFbId;
@property (nonatomic, retain) NSString * allScoreboardRank;
@property (nonatomic, retain) NSString * allScoreboardScore;
@property (nonatomic, retain) NSString * friendScoreboardName;
@property (nonatomic, retain) NSString * friendScoreboardFbId;
@property (nonatomic, retain) NSString * friendScoreboardRank;
@property (nonatomic, retain) NSString * friendScoreboardScore;
@property (nonatomic, retain) NSData * binaryData;
@property (nonatomic, retain) User *belongsToUser;
@property (nonatomic, retain) NSSet *hasCards;
@end

@interface MyCategory (CoreDataGeneratedAccessors)

- (void)addHasCardsObject:(MyCard *)value;
- (void)removeHasCardsObject:(MyCard *)value;
- (void)addHasCards:(NSSet *)values;
- (void)removeHasCards:(NSSet *)values;

@end
