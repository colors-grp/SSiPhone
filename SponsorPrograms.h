//
//  SponsorPrograms.h
//  TheColorsConcorenza
//
//  Created by Heba Gamal on 6/19/14.
//  Copyright (c) 2014 Heba Gamal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SponsorPrograms : NSManagedObject

@property (nonatomic, retain) NSData * binaryImage;
@property (nonatomic, retain) NSString * programId;
@property (nonatomic, retain) NSString * programName;

@end
