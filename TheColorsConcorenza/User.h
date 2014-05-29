//
//  User.h
//  TheColorsConcorenza
//
//  Created by Heba Gamal on 5/12/14.
//  Copyright (c) 2014 Heba Gamal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MyCategory;

@interface User : NSManagedObject

@property (nonatomic, retain) NSDate * userBirthday;
@property (nonatomic, retain) NSNumber * userCredit;
@property (nonatomic, retain) NSString * userFacebookId;
@property (nonatomic, retain) NSString * userGender;
@property (nonatomic, retain) NSNumber * userId;
@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) NSNumber * userScore;
@property (nonatomic, retain) NSSet *hasCategory;
@end

@interface User (CoreDataGeneratedAccessors)

- (void)addHasCategoryObject:(MyCategory *)value;
- (void)removeHasCategoryObject:(MyCategory *)value;
- (void)addHasCategory:(NSSet *)values;
- (void)removeHasCategory:(NSSet *)values;

@end
