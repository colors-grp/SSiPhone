//
//  MyCategory.h
//  TheColorsConcorenza
//
//  Created by Heba Gamal on 6/18/14.
//  Copyright (c) 2014 Heba Gamal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MyCard, User;

@interface MyCategory : NSManagedObject

@property (nonatomic, retain) NSData * binaryData;
@property (nonatomic, retain) NSNumber * categoryId;
@property (nonatomic, retain) NSString * categoryName;
@property (nonatomic, retain) NSNumber * isFavourite;
@property (nonatomic, retain) NSNumber * userCards;
@property (nonatomic, retain) NSString * userScore;
@property (nonatomic, retain) User *belongsToUser;
@property (nonatomic, retain) NSSet *hasCards;
@end

@interface MyCategory (CoreDataGeneratedAccessors)

- (void)addHasCardsObject:(MyCard *)value;
- (void)removeHasCardsObject:(MyCard *)value;
- (void)addHasCards:(NSSet *)values;
- (void)removeHasCards:(NSSet *)values;

@end
