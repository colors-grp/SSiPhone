//
//  H7Mosalslat.m
//  TheColorsConcorenza
//
//  Created by Heba Gamal on 5/26/14.
//  Copyright (c) 2014 Heba Gamal. All rights reserved.
//

#import "H7Mosalslat.h"
#import "H7ConstantsModel.h"
#import "H7MosalslatQuiz.h"

#import <AFNetworking/AFNetworking.h>
#import <CoreData+MagicalRecord.h>
@interface H7Mosalslat ()

@end

@implementation H7Mosalslat{
    NSArray * cards;
    NSMutableDictionary *cardStatus;
}


- (void)viewDidLoad
{
    /* Setting background image */
    int height =  [[UIScreen mainScreen] bounds].size.height;
    if(height > 480){
        UIImage *background = [UIImage imageNamed: @"bg_all_5.png"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage: background];
        [self.view insertSubview: imageView atIndex:0];
    }
    else{
        UIImage *background = [UIImage imageNamed: @"bg_all_4.png"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage: background];
        [self.view insertSubview: imageView atIndex:0];
    }
    
    // Get Cards of mosalslat category sorted according to cardId
    cards = [[self.currentCategory.hasCards allObjects] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSNumber *first = [obj1 valueForKey:@"cardId"];
        NSNumber *second = [obj2 valueForKey:@"cardId"];
        return [first compare:second];
    }];
//    for (int i = 0; i < [cards count]; i++) {
//        MyCard *curCard = [cards objectAtIndex:i];
//        if([curCard.isAvailble isEqualToNumber:[NSNumber numberWithBool:YES]])
//            [cardStatus setObject:@"1" forKey:[NSString stringWithFormat:@"%d" , i + 1]];
//        else
//            [cardStatus setObject:@"0" forKey:[NSString stringWithFormat:@"%d" , i + 1]];
//    }
//    [self.cardsCollection reloadData];
    [super viewDidLoad];
}



-(void)viewDidAppear:(BOOL)animated{
    
    // Get Cards of shahryar category sorted according to cardId
    cards = [[self.currentCategory.hasCards allObjects] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSNumber *first = [obj1 valueForKey:@"cardId"];
        NSNumber *second = [obj2 valueForKey:@"cardId"];
        return [first compare:second];
    }];
    cardStatus = [[NSMutableDictionary alloc] init];
    for (int i = 0; i < [cards count]; i++) {
        MyCard *curCard = [cards objectAtIndex:i];
        if([curCard.isAvailble isEqualToNumber:[NSNumber numberWithBool:YES]])
            [cardStatus setObject:@"1" forKey:[NSString stringWithFormat:@"%d" , i + 1]];
        else
            [cardStatus setObject:@"0" forKey:[NSString stringWithFormat:@"%d" , i + 1]];
    }
    [self.cardsCollection reloadData];
    [self getOpenedCards];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/* Collection Data source */

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.currentCategory.hasCards count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MosalslatCell" forIndexPath:indexPath];
    UIImageView *image = (UIImageView*)[cell viewWithTag:400];
    UILabel *nameLabel = (UILabel*)[cell viewWithTag:401];
    bool inLoop =false;
    NSString *imagePath;
    MyCard *curCard = [cards objectAtIndex:indexPath.row];
    if([cardStatus objectForKey:[NSString stringWithFormat:@"%d" , indexPath.row+1]]!= nil && [[cardStatus objectForKey:[NSString stringWithFormat:@"%d" , indexPath.row+1]] isEqualToString:@"1"] && [curCard.isAvailble isEqualToNumber:[NSNumber numberWithBool:NO]]) {
        [self downloadCard:curCard SetImage:image];
        nameLabel.text = curCard.cardName;
        inLoop = YES;
    }else if([curCard.isAvailble isEqualToNumber:[NSNumber numberWithBool:YES]]) {
        NSData *imgData = curCard.imageBinary;
        UIImage *thumbNail = [UIImage imageWithData:imgData scale:1.0f];
        [image setImage:thumbNail];
        nameLabel.text = curCard.cardName;
        inLoop = YES;
    }
    if(!inLoop){
        imagePath = [NSString stringWithFormat:@"locked_card.png"];
        image.image = [UIImage imageNamed:imagePath];
        nameLabel.text = @"قريباً";

    }
    return  cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if([[cardStatus objectForKey:[NSString stringWithFormat:@"%d" , indexPath.row+1]] isEqualToString:@"1"]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        H7MosalslatQuiz *quiz  = [storyboard instantiateViewControllerWithIdentifier:@"mosalslatQuiz"];
        quiz.currentCard = [cards objectAtIndex:indexPath.row];
        [self.navigationController pushViewController: quiz animated:YES];
    }else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"تحذير" message:@"الحلقه لسه ما نزلتش" delegate:nil cancelButtonTitle:@"تمام" otherButtonTitles:nil];
        [alert show];
    }
}
-(void)getOpenedCards {
    NSURL *url = [[NSURL alloc] initWithString:[ NSString stringWithFormat:@"%@cards_status/format/json/categoryId/%@/size/iphone4", PLATFORM_URL ,self.currentCategory.categoryId]];
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:url];
    AFJSONRequestOperation *request = [AFJSONRequestOperation JSONRequestOperationWithRequest:urlRequest success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        cardStatus = JSON;
        for (int i = 0; i < 30; i++) {
            if([cardStatus objectForKey:[NSString stringWithFormat:@"%d", i+1]]!= nil &&[[cardStatus objectForKey:[NSString stringWithFormat:@"%d", i+1]] isEqualToString:@"1"]) {
                MyCard *card = [cards objectAtIndex:i];
                
                card.cardName = [NSString stringWithCString:[[cardStatus objectForKey:[NSString stringWithFormat:@"cardname_%@" ,card.cardId]]cStringUsingEncoding:NSUTF8StringEncoding] encoding:NSUTF8StringEncoding];
            }
        }
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
        [self.cardsCollection reloadData];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        // Get from core data
        cardStatus = [[NSMutableDictionary alloc] init];
        for (int i = 0; i < 30; i++) {
            MyCard *card = [cards objectAtIndex:i];
            if([card.isAvailble isEqualToNumber:[NSNumber numberWithBool:YES]]) {
                [cardStatus setObject:@"1" forKey:[NSString stringWithFormat:@"%d" , i + 1]];
            }
            else
                [cardStatus setObject:@"0" forKey:[NSString stringWithFormat:@"%d" , i + 1]];
   
        }
        [self.cardsCollection reloadData];
        NSLog(@"Got opened cards from core data");
    }];
    [request start];
}

- (void)downloadCard:(MyCard*)card SetImage:(UIImageView*)image {
    // Set URL for image
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat: @"%@cards/mosalslat/%@/iphone4/img.png" ,ASSETS_URL,card.cardId]];
    
    // Set the request
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    // Get directory to save & retrieve image
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"cards/mosalslat/%@" , card.cardId]];
    
    // Create directory
    NSFileManager *filemgr;
    filemgr =[NSFileManager defaultManager];
    if ([filemgr createDirectoryAtPath:documentsDirectory withIntermediateDirectories:YES
                            attributes:nil error: NULL] == NO){
        NSLog(@"Failed to create local directory");
    }
    
    // Save file
    NSString *fullPath = [NSString stringWithFormat:@"%@/img.png", documentsDirectory];
    [operation setOutputStream:[NSOutputStream outputStreamToFileAtPath:fullPath append:NO]];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *imgData = [[NSData alloc] initWithContentsOfURL:[NSURL fileURLWithPath:fullPath]];
        [imgData writeToFile:fullPath atomically:YES];
        UIImage *thumbNail = [[UIImage alloc] initWithData:imgData];
        //Set image with thumbnail here
        image.image = thumbNail;
        //Set card.isAvailble to be true & save to coredata & binary image
        card.imageBinary = imgData;
        card.isAvailble = [NSNumber numberWithBool:YES];
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"ERR: %@", [error description]);
    }];
    [operation start];
}


@end
