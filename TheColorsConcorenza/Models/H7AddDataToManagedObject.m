//
//  H7AddDataToManagedObject.m
//  TheColorsConcorenza
//
//  Created by Heba Gamal on 4/10/14.
//  Copyright (c) 2014 Heba Gamal. All rights reserved.
//

#import "H7AddDataToManagedObject.h"

#import "User.h"
#import "MyCard.h"
#import "MyCategory.h"
#import "CardImage.h"
#import "SponsorPrograms.h"
#import <CoreData+MagicalRecord.h>


@implementation H7AddDataToManagedObject

-(void) saveData {
    
    NSError* err = nil;
    NSString* dataPath = [[NSBundle mainBundle] pathForResource:@"cards" ofType:@"json"];
    NSArray* cardsArray = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:dataPath]options:kNilOptions error:&err];
    
    NSArray *check = [MyCategory MR_findAll];
    if([check count] == 0) {
        //save data with magical record
        NSArray *tmp  = [NSArray arrayWithObjects:@"sallySyamak" , @"mosalslat", @"manElQatel" , @"shahryar" , nil];
        NSArray *tmp1  = [NSArray arrayWithObjects:[NSNumber numberWithInt:1] , [NSNumber numberWithInt:2], [NSNumber numberWithInt:3] , [NSNumber numberWithInt:4] , nil];
        NSMutableSet *userCategories = [[NSMutableSet alloc] init];
        User *user = [User MR_createEntity];
        NSNumber *favourite = [NSNumber numberWithBool:NO];
        for (int i=0 ; i < [tmp count]; i++) {
            MyCategory *newCat = [MyCategory MR_createEntity];
            newCat.categoryId = [tmp1 objectAtIndex:i];
            newCat.categoryName = [tmp objectAtIndex:i];
            newCat.isFavourite = favourite;
            newCat.userScore = [NSNumber numberWithInt:0];
            newCat.userCards = [NSNumber numberWithInt:0];
            
            if([newCat.categoryName isEqualToString:@"shahryar"]) {
                NSMutableSet *cardsSet = [[NSMutableSet alloc] init];
                for (int j=0 ; j<[cardsArray count]; j++) {
                    NSString *curCatId = @"4";
                    NSDictionary *dict = [cardsArray objectAtIndex:j];
                    if([[dict objectForKey:@"category"] isEqualToString:curCatId]) {
                        MyCard *newCard = [MyCard MR_createEntity];
                        newCard.cardId = [NSNumber numberWithInt:[[dict objectForKey:@"id"] intValue]];
                        newCard.cardName = [dict objectForKey:@"name"];
                        newCard.cardScore = [NSNumber numberWithInt:[[dict objectForKey:@"score"] intValue]];
                        newCard.isAvailble = [NSNumber numberWithBool:NO];
                        [cardsSet addObject:newCard];
                    }
                }
                //Testing 3dd l elements fe cardset
                //Testing if scoreboard hatla3 l images l sa7 wla la2
                newCat.hasCards = [NSSet setWithArray:[cardsSet allObjects]];
                NSLog(@"cards set size = %d" , [cardsSet count]);
            }
            
            
            if([newCat.categoryName isEqualToString:@"manElQatel"]) {
                NSMutableSet *cardsSet = [[NSMutableSet alloc] init];
                for (int j=0 ; j<[cardsArray count]; j++) {
                    NSString *curCatId = @"3";
                    NSDictionary *dict = [cardsArray objectAtIndex:j];
                    if([[dict objectForKey:@"category"] isEqualToString:curCatId]) {
                        MyCard *newCard = [MyCard MR_createEntity];
                        newCard.cardId = [NSNumber numberWithInt:[[dict objectForKey:@"id"] intValue]];
                        newCard.cardName = [dict objectForKey:@"name"];
                        newCard.cardScore = [NSNumber numberWithInt:[[dict objectForKey:@"score"] intValue]];
                        newCard.isAvailble = [NSNumber numberWithBool:NO];
                        [cardsSet addObject:newCard];
                    }
                }
                //Testing 3dd l elements fe cardset
                //Testing if scoreboard hatla3 l images l sa7 wla la2
                newCat.hasCards = [NSSet setWithArray:[cardsSet allObjects]];
                NSLog(@"cards set size = %d" , [cardsSet count]);
            }
            
            
            if([newCat.categoryName isEqualToString:@"mosalslat"]) {
                NSMutableSet *cardsSet = [[NSMutableSet alloc] init];
                for (int j=0 ; j<[cardsArray count]; j++) {
                    NSString *curCatId = @"2";
                    NSDictionary *dict = [cardsArray objectAtIndex:j];
                    if([[dict objectForKey:@"category"] isEqualToString:curCatId]) {
                        MyCard *newCard = [MyCard MR_createEntity];
                        newCard.cardId = [NSNumber numberWithInt:[[dict objectForKey:@"id"] intValue]];
                        newCard.cardName = [dict objectForKey:@"name"];
                        newCard.cardScore = [NSNumber numberWithInt:[[dict objectForKey:@"score"] intValue]];
                        newCard.isAvailble = [NSNumber numberWithBool:NO];
                        [cardsSet addObject:newCard];
                        
                    }
                }
                //Testing 3dd l elements fe cardset
                //Testing if scoreboard hatla3 l images l sa7 wla la2
                newCat.hasCards = [NSSet setWithArray:[cardsSet allObjects]];
                NSLog(@"cards set size = %d" , [cardsSet count]);
            }
            
            
            if([newCat.categoryName isEqualToString:@"sallySyamak"]) {
                NSMutableSet *cardsSet = [[NSMutableSet alloc] init];
                for (int j=0 ; j<[cardsArray count]; j++) {
                    NSString *curCatId = @"1";
                    NSDictionary *dict = [cardsArray objectAtIndex:j];
                    if([[dict objectForKey:@"category"] isEqualToString:curCatId]) {
                        MyCard *newCard = [MyCard MR_createEntity];
                        newCard.cardId = [NSNumber numberWithInt:[[dict objectForKey:@"id"] intValue]];
                        newCard.cardName = [dict objectForKey:@"name"];
                        newCard.cardScore = [NSNumber numberWithInt:[[dict objectForKey:@"score"] intValue]];
                        newCard.isAvailble = [NSNumber numberWithBool:NO];
                        [cardsSet addObject:newCard];
                    }
                }
                //Testing 3dd l elements fe cardset
                //Testing if scoreboard hatla3 l images l sa7 wla la2
                newCat.hasCards = [NSSet setWithArray:[cardsSet allObjects]];
                NSLog(@"cards set size = %d" , [cardsSet count]);
            }
            
            [userCategories addObject:newCat];
        }
        user.hasCategory =[NSSet setWithArray:[userCategories allObjects]];
        SponsorPrograms *s1 = [SponsorPrograms MR_createEntity];
        s1.title = @"فرح ليلي";
        s1.imageName = @"fara7.jpg";
        s1.staring = @"ليلى علوي، فراس سعيد، عبد الرحمن أبو زهرة، دعاء طعيمة، نادية خيري، نرمين ماهر، أحمد كمال ،شريف باهر";
        s1.describtion = @"تدور أحداث المسلسل حول 'ليلى' الفتاة المصرية المنتمية إلى الطبقة المتوسطة التي تجاوزت الأربعين من عمرها دون زواج بسبب خوفها من أن تصاب بمرض 'سرطان الثدي' الذي أصاب معظم نساء عائلتها وتسبب في وفاتهم في سن مبكرة مما كون لدى 'ليلى' عقدة من الزواج جعلتها تتفرغ تماما لعملها كمصممة أفراح إلى أن يظهر في حياتها الحب الذي يجعلها تفكر من جديد.";
        
        SponsorPrograms *s2 = [SponsorPrograms MR_createEntity];
        s2.title = @"الكبير قوي";
        s2.imageName = @"kbeer.jpeg";
        s2.staring = @"أحمد مكي، دنيا سمير غانم، هشام إسماعيل ومحمد شاهين وإخراج إسلام خيرى وأحمد الجندي";
        s2.describtion = @"وتدور أحداث المسلسل حول عمدة قرية 'المزاريطة'، الذي تزوّج من امرأة أمريكية، وأنجب منها ولدين توأمين؛ أحدهما تربى في الصعيد، والآخر في أمريكا، وتحدث مواقف كوميدية ومفارقات بين الأخوين عندما يلتقيا ويتنافسا على العمودية خلفا لوالدهما ويجسد مكى الأدوار الثلاثة الأب والتوأمين (الكبير وجوني)";
        
        SponsorPrograms *s3 = [SponsorPrograms MR_createEntity];
        s3.title = @"تامر و شوقية";
        s3.imageName = @"tamer.jpeg";
        s3.staring = @"أحمد الفيشاوي ،مى كساب ،جمال إسماعيل ،رجاء الجداوي ،انعام سالوسة ،لطفى لبيب ،نضال الشافعي ،أحمد مكي ،إنجى وجدان";
        s3.describtion = @"تامر وشوقية مسلسل مصري كوميدي ينتمي لنوعية السيت كوم، يحكى عن شوقية التي تعمل مدرسة وتسكن في حي العمرانية والتي تزوجت من تامر المحامي ابن الطبقة الأرستقراطية وساكن حى مصر الجديدة ويتناول المسلسل الفوارق الطبقية بين العائلتين والمشاكل التي قد تواجه حديثي الزواج في إطار كوميدى.";
        
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    }
}



@end
