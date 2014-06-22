//
//  H7SallySyamak.m
//  TheColorsConcorenza
//
//  Created by Heba Gamal on 5/26/14.
//  Copyright (c) 2014 Heba Gamal. All rights reserved.
//

#import "H7SallySyamak.h"
#import "H7AppDelegate.h"

#import "MyCard.h"
#import "H7ConstantsModel.h"
#import "H7CardSinglton.h"

#import "ViewController.h"

#import <CoreData+MagicalRecord.h>
#import <AFNetworking/AFNetworking.h>

@interface H7SallySyamak ()

@end

@implementation H7SallySyamak{
    NSArray * cards;
    NSDictionary *cardStatus;
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
    
    // Get Cards of salySyamak category sorted according to cardId
    cards = [[self.currentCategory.hasCards allObjects] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSNumber *first = [obj1 valueForKey:@"cardId"];
        NSNumber *second = [obj2 valueForKey:@"cardId"];
        return [first compare:second];
    }];
    
    // Get cards status
    [self getOpenedCards];

    [super viewDidLoad];
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
    return [cards count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SallySyamakCell" forIndexPath:indexPath];
    UIImageView *image = (UIImageView*)[cell viewWithTag:500];
    bool inLoop =false;
    NSString *imagePath;
    MyCard *curCard = [cards objectAtIndex:indexPath.row];
    if([cardStatus objectForKey:[NSString stringWithFormat:@"%d" , indexPath.row+1]]!= nil && [[cardStatus objectForKey:[NSString stringWithFormat:@"%d" , indexPath.row+1]] isEqualToString:@"1"] && [curCard.isAvailble isEqualToNumber:[NSNumber numberWithBool:NO]]) {
        [self downloadCard:curCard SetImage:image];
        inLoop = YES;
    }else if([cardStatus objectForKey:[NSString stringWithFormat:@"%d" , indexPath.row+1]]!= nil && [[cardStatus objectForKey:[NSString stringWithFormat:@"%d" , indexPath.row+1]] isEqualToString:@"1"] &&  [curCard.isAvailble isEqualToNumber:[NSNumber numberWithBool:YES]]) {
        NSData *imgData = curCard.imageBinary;
        UIImage *thumbNail = [UIImage imageWithData:imgData scale:1.0f];
        [image setImage:thumbNail];
        inLoop = YES;
    }
    if(!inLoop) {
        imagePath = [NSString stringWithFormat:@"locked_card.png"];
        image.image = [UIImage imageNamed:imagePath];
    }
    return  cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if([[cardStatus objectForKey:[NSString stringWithFormat:@"%d" , indexPath.row+1]] isEqualToString:@"1"]) {
        MyCard *selectedCard = [cards objectAtIndex:indexPath.row];
        H7CardSinglton *singlton = [H7CardSinglton sharedInstance];
        [singlton setWithCard:[cards objectAtIndex:indexPath.row]];
        NSLog(@"Card highscore till now is %@" , [[cards objectAtIndex:indexPath.row] cardScore]);
        if(selectedCard.cardId == [NSNumber numberWithInt:1]) {
            //Fanoos crunch
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            ViewController *myController = [storyboard instantiateViewControllerWithIdentifier:@"fanoosCrunch"];
            [self.navigationController pushViewController: myController animated:YES];
        }else if(selectedCard.cardId == [NSNumber numberWithInt:2]) {
            //Flappy fanoos
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            ViewController *myController = [storyboard instantiateViewControllerWithIdentifier:@"flappyFanoos"];
            [self.navigationController pushViewController: myController animated:YES];
        }else if(selectedCard.cardId == [NSNumber numberWithInt:3]) {
            //Fanoos2048
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            ViewController *myController = [storyboard instantiateViewControllerWithIdentifier:@"fanoos2048"];
            [self.navigationController pushViewController: myController animated:YES];
        }
    }else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Card not open yet!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

-(void)getOpenedCards {
    NSURL *url = [[NSURL alloc] initWithString:[ NSString stringWithFormat:@"%@cards_status/format/json/categoryId/%@", PLATFORM_URL ,self.currentCategory.categoryId]];
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:url];
    AFJSONRequestOperation *request = [AFJSONRequestOperation JSONRequestOperationWithRequest:urlRequest success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        cardStatus = JSON;
        [self.cardsCollection reloadData];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        // Get from core data
        NSLog(@"Failed to get scores");
    }];
    [request start];
}

- (void)downloadCard:(MyCard*)card SetImage:(UIImageView*)image {
    // Set URL for image
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat: @"%@cards/sallySyamak/%@/img.png" ,ASSETS_URL,card.cardId]];
    
    // Set the request
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    // Get directory to save & retrieve image
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"cards/sallySyamak/%@" , card.cardId]];
    
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
