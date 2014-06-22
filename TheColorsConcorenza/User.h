//
//  User.h
//  TheColorsConcorenza
//
//  Created by Heba Gamal on 6/19/14.
//  Copyright (c) 2014 Heba Gamal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MyCategory;

@interface User : NSManagedObject

@property (nonatomic, retain) NSString * userBirthday;
@property (nonatomic, retain) NSNumber * userCredit;
@property (nonatomic, retain) NSString * userFacebookId;
@property (nonatomic, retain) NSString * userGender;
@property (nonatomic, retain) NSString * userId;
@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) NSData * userProfilePicture;
@property (nonatomic, retain) NSNumber * userScore;
@property (nonatomic, retain) NSString * userFirstName;
@property (nonatomic, retain) NSString * userAccountId;
@property (nonatomic, retain) NSSet *hasCategory;
@end

@interface User (CoreDataGeneratedAccessors)

- (void)addHasCategoryObject:(MyCategory *)value;
- (void)removeHasCategoryObject:(MyCategory *)value;
- (void)addHasCategory:(NSSet *)values;
- (void)removeHasCategory:(NSSet *)values;

@end
