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
    NSArray *check = [MyCategory MR_findAll];
    if([check count] == 0) {
        //save data with magical record
        NSArray *tmp  = [NSArray arrayWithObjects:@"blue" , @"green", @"indigo" , @"orange" , @"red" , @"violet" , @"yellow" , nil];
        NSArray *tmp1  = [NSArray arrayWithObjects:[NSNumber numberWithInt:1] , [NSNumber numberWithInt:2], [NSNumber numberWithInt:3] , [NSNumber numberWithInt:4] , [NSNumber numberWithInt:5] ,[NSNumber numberWithInt:6], [NSNumber numberWithInt:7] , nil];
        NSMutableSet *userCategories = [[NSMutableSet alloc] init];
        User *user = [User MR_createEntity];
        user.userName = @"Heba";
        user.userCredit = [NSNumber numberWithInt:0];
        NSNumber *favourite = [NSNumber numberWithBool:NO];
        for (int i=0 ; i < [tmp count]; i++) {
            MyCategory *newCat = [MyCategory MR_createEntity];
            newCat.categoryId = [tmp1 objectAtIndex:i];
            newCat.categoryName = [tmp objectAtIndex:i];
            newCat.isFavourite = favourite;
            newCat.userScore = [NSNumber numberWithInt:0];
            newCat.userCards = [NSNumber numberWithInt:0];
            
            if([newCat.categoryName isEqualToString:@"blue"]) {
                //images for cards
                CardImage *image1 = [CardImage MR_createEntity];
                CardImage *image2 = [CardImage MR_createEntity];
                CardImage *image3 = [CardImage MR_createEntity];
                CardImage *image4 = [CardImage MR_createEntity];
                image1.imageName = @"grid_view.png";
                image2.imageName = @"list_view.png";
                image3.imageName = @"grid_view.png";
                image4.imageName = @"list_view.png";
                NSSet *imageSet = [NSSet setWithObjects:image1,image2, nil];
                NSSet *imageSet1 = [NSSet setWithObjects:image3,image4, nil];
                
                //cards for category
                MyCard *card1 = [MyCard MR_createEntity];
                MyCard *card2 = [MyCard MR_createEntity];
                MyCard *card3 = [MyCard MR_createEntity];
                
                card1.cardId =[NSNumber numberWithInt:1];
                card2.cardId =[NSNumber numberWithInt:2];
                card3.cardId =[NSNumber numberWithInt:3];
                
                card1.cardName = @"rowing card";
                card2.cardName = @"cloud card";
                card3.cardName = @"iceman card";
                
                card1.isBought = favourite;
                card2.isBought = favourite;
                card3.isBought = favourite;
                
                card1.hasImages = imageSet;
                card2.hasImages = imageSet1;
                
                newCat.hasCards = [NSSet setWithObjects:card1, card2,card3, nil];
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
