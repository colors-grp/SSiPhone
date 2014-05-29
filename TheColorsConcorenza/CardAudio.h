//
//  CardAudio.h
//  TheColorsConcorenza
//
//  Created by Heba Gamal on 5/12/14.
//  Copyright (c) 2014 Heba Gamal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MyCard;

@interface CardAudio : NSManagedObject

@property (nonatomic, retain) NSString * audioName;
@property (nonatomic, retain) MyCard *belongsTo;

@end
