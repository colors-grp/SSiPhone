//
//  Notification.h
//  TheColorsConcorenza
//
//  Created by Heba Gamal on 5/12/14.
//  Copyright (c) 2014 Heba Gamal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Notification : NSManagedObject

@property (nonatomic, retain) NSString * notificationDescription;
@property (nonatomic, retain) NSNumber * notificationId;

@end
