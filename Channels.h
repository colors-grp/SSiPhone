//
//  Channels.h
//  TheColorsConcorenza
//
//  Created by Heba Gamal on 6/20/14.
//  Copyright (c) 2014 Heba Gamal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Channels : NSManagedObject

@property (nonatomic, retain) NSString * channelName;
@property (nonatomic, retain) NSString * time;
@property (nonatomic, retain) NSString * programId;

@end
