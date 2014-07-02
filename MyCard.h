//
//  MyCard.h
//  TheColorsConcorenza
//
//  Created by Heba Gamal on 7/2/14.
//  Copyright (c) 2014 Heba Gamal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CardAudio, CardImage, MyCategory;

@interface MyCard : NSManagedObject

@property (nonatomic, retain) NSNumber * cardId;
@property (nonatomic, retain) NSString * cardName;
@property (nonatomic, retain) NSNumber * cardPrice;
@property (nonatomic, retain) NSNumber * cardScore;
@property (nonatomic, retain) NSString * gameId;
@property (nonatomic, retain) NSData * imageBinary;
@property (nonatomic, retain) NSNumber * isAvailble;
@property (nonatomic, retain) NSNumber * isBought;
@property (nonatomic, retain) NSNumber * isEpisodeDownloaded;
@property (nonatomic, retain) NSString * mosalsalDescription;
@property (nonatomic, retain) NSData * mosalslatQuestions;
@property (nonatomic, retain) NSString * numberOfPanelsShahryar;
@property (nonatomic, retain) NSString * numberOfQuestionsMosalslat;
@property (nonatomic, retain) NSNumber * areMosalslatQuestionsDownloaded;
@property (nonatomic, retain) MyCategory *belongsTo;
@property (nonatomic, retain) NSSet *hasAudio;
@property (nonatomic, retain) NSSet *hasImages;
@end

@interface MyCard (CoreDataGeneratedAccessors)

- (void)addHasAudioObject:(CardAudio *)value;
- (void)removeHasAudioObject:(CardAudio *)value;
- (void)addHasAudio:(NSSet *)values;
- (void)removeHasAudio:(NSSet *)values;

- (void)addHasImagesObject:(CardImage *)value;
- (void)removeHasImagesObject:(CardImage *)value;
- (void)addHasImages:(NSSet *)values;
- (void)removeHasImages:(NSSet *)values;

@end
