//
//  SponsorPrograms.h
//  TheColorsConcorenza
//
//  Created by Heba Gamal on 5/19/14.
//  Copyright (c) 2014 Heba Gamal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SponsorPrograms : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * from;
@property (nonatomic, retain) NSString * to;
@property (nonatomic, retain) NSString * imageName;
@property (nonatomic, retain) NSString * staring;
@property (nonatomic, retain) NSString * describtion;

@end
