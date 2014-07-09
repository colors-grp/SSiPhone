//
//  H7ShahryarDescription.m
//  TheColorsConcorenza
//
//  Created by Heba Gamal on 7/7/14.
//  Copyright (c) 2014 Heba Gamal. All rights reserved.
//

#import "H7ShahryarDescription.h"
#import "H7ConstantsModel.h"
#import "H7MosalslatScore.h"
#import "H7ShahryarFindTheBottle.h"

#import <AFNetworking/AFNetworking.h>
#import <CoreData+MagicalRecord.h>

@interface H7ShahryarDescription ()

@end

@implementation H7ShahryarDescription


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
    
    UIBarButtonItem *quizButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"ابدأ"
                                   style:UIBarButtonItemStyleBordered
                                   target:self
                                   action:@selector(startManElQatel:)];
    self.navigationItem.rightBarButtonItem = quizButton;
    
    if([self.currentCard.isShahrayarFindTheBottlePlayed isEqualToNumber:[NSNumber numberWithBool:YES]]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        H7MosalslatScore *myController = [storyboard instantiateViewControllerWithIdentifier:@"mossalslatScore"];
        myController.score = [self.currentCard.cardScore intValue];
        [self.navigationController pushViewController: myController animated:YES];
    }
    
    [self downloadDimensions];
    [self downloadFindTheBottleImage];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)startManElQatel:(id)sender {
    NSLog(@"played = %@",self.currentCard.isShahrayarFindTheBottlePlayed);
    if([self.currentCard.isShahryarFindTheBottleDownloaded isEqualToNumber:[NSNumber numberWithBool:YES]]) {
        if([self.currentCard.isShahrayarFindTheBottlePlayed isEqualToNumber:[NSNumber numberWithBool:NO]]) {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            H7ShahryarFindTheBottle *findTheBottle = [storyboard instantiateViewControllerWithIdentifier:@"shahryarFindTheBottle"];
            findTheBottle.currentCard = self.currentCard;
            [self.navigationController pushViewController:findTheBottle animated:YES];
        }else {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            H7MosalslatScore *myController = [storyboard instantiateViewControllerWithIdentifier:@"mossalslatScore"];
            myController.score = [self.currentCard.cardScore intValue];
            [self.navigationController pushViewController: myController animated:YES];
        }
    }else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"تحذير" message:@"لسه بنجيب الحلقه .." delegate:self cancelButtonTitle:@"تمام" otherButtonTitles: nil];
        [alert show];    }
}

- (void)saveImage: (UIImage*)image {
    if (image != nil)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                             NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString* path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"cards/shahryar/%@/iphone4/find/bgg.png" , self.currentCard.cardId]];
        NSLog(@"saving image path = %@" , path);
        NSData* data = UIImagePNGRepresentation(image);
        [data writeToFile:path atomically:YES];
    }
}

-(void)downloadDimensions {
    NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@find_object_positions/catId/4/cardId/%@/format/json", PLATFORM_URL ,self.currentCard.cardId]];
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:url];
    AFJSONRequestOperation *request = [AFJSONRequestOperation JSONRequestOperationWithRequest:urlRequest success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"%@" , JSON);
        NSDictionary *dect = JSON;
        self.currentCard.iphone4x = [NSString stringWithFormat:@"%@",[dect objectForKey:@"iphone4x"]];
        self.currentCard.iphone4y = [NSString stringWithFormat:@"%@",[dect objectForKey:@"iphone4y"]];
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        // Get from core data
        NSLog(@"Failed to update score in server");
    }];
    [request start];
    
}



- (void)downloadFindTheBottleImage {
    // Set URL for image
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat: @"%@cards/shahryar/%@/iphone4/find/bg.png" ,ASSETS_URL, self.currentCard.cardId]];
    // Set the request
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    // Get directory to save & retrieve image
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"cards/shahryar/%@/iphone4/find/" , self.currentCard.cardId]];
    
    // Create directory
    NSFileManager *filemgr;
    filemgr =[NSFileManager defaultManager];
    if ([filemgr createDirectoryAtPath:documentsDirectory withIntermediateDirectories:YES
                            attributes:nil error: NULL] == NO){
        NSLog(@"Failed to create local directory");
    }
    
    // Save file
    NSString *fullPath = [NSString stringWithFormat:@"%@/bgg.png", documentsDirectory ];
    [operation setOutputStream:[NSOutputStream outputStreamToFileAtPath:fullPath append:NO]];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *imgData = [[NSData alloc] initWithContentsOfURL:[NSURL fileURLWithPath:fullPath]];
        UIImage *thumbNail = [[UIImage alloc] initWithData:imgData];
        [self saveImage:thumbNail];
        self.currentCard.isShahryarFindTheBottleDownloaded = [NSNumber numberWithBool:YES];
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"ERR: %@", [error description]);
    }];
    [operation start];
}



@end
