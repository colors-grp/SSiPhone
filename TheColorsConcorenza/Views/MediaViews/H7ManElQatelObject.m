//
//  H7ManElQatelObject.m
//  TheColorsConcorenza
//
//  Created by Heba Gamal on 7/6/14.
//  Copyright (c) 2014 Heba Gamal. All rights reserved.
//

#import "H7ManElQatelObject.h"
#import "H7ConstantsModel.h"
#import "H7ManElQatelAudio.h"
#import <CoreData+MagicalRecord.h>
#import <AFNetworking/AFNetworking.h>

@interface H7ManElQatelObject ()

@end

@implementation H7ManElQatelObject


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
    
    [self downloadDimensions];
    [self downloadfindTheObjectImage];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)startManElQatel:(id)sender {
    if([self.currentCard.isManElQatelObjectDownloaded isEqualToNumber:[NSNumber numberWithBool:YES]]) {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            H7ManElQatelAudio *audio  = [storyboard instantiateViewControllerWithIdentifier:@"manElQatelAudio"];
            audio.currentCard = self.currentCard;
            [self.navigationController pushViewController: audio animated:YES];
    }else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"OPSSS!!" message:[NSString stringWithFormat:@"Downloading content"] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
    }
}

- (void)saveImage: (UIImage*)image
{
    if (image != nil)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                             NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString* path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"cards/manElQatel/%@/iphone4/find/obj.png" , self.currentCard.cardId]];
        NSLog(@"saving image path = %@" , path);
        NSData* data = UIImagePNGRepresentation(image);
        [data writeToFile:path atomically:YES];
        double delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self loadObject];
        });
    }
}

- (void)loadObject
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* path = [documentsDirectory stringByAppendingPathComponent:
                      [NSString stringWithFormat:@"cards/manElQatel/%@/iphone4/find/obj.png" , self.currentCard.cardId]];
    NSLog(@"path = %@" , path);
    UIImage* image = [UIImage imageWithContentsOfFile:path];
    self.objectImage.image = image;
}

-(void)downloadDimensions {
    NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@find_object_positions/catId/3/cardId/%@/format/json", PLATFORM_URL ,self.currentCard.cardId]];
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:url];
    AFJSONRequestOperation *request = [AFJSONRequestOperation JSONRequestOperationWithRequest:urlRequest success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"%@" , JSON);
        NSDictionary *dect = JSON;
        self.currentCard.iphone4x = [NSString stringWithFormat:@"%@",[dect objectForKey:@"iphone4x"]];
        self.currentCard.iphone4y = [NSString stringWithFormat:@"%@",[dect objectForKey:@"iphone4y"]];
        self.currentCard.feenElSla7Story = [dect objectForKey:@"story"];
        NSString *tmp =[dect objectForKey:@"story"];
        tmp = [tmp stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
        self.descriptionLabel.text =tmp;
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];

    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        // Get from core data
        NSLog(@"Failed to update score in server");
    }];
    [request start];
    
}


- (void)downloadfindTheObjectImage {
    // Set URL for image
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat: @"%@cards/manElQatel/%@/iphone4/find/obj_found.png" ,ASSETS_URL, self.currentCard.cardId]];
    NSLog(@"%@" , url);
    // Set the request
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    // Get directory to save & retrieve image
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"cards/manElQatel/%@/iphone4/find/" , self.currentCard.cardId]];
    
    // Create directory
    NSFileManager *filemgr;
    filemgr =[NSFileManager defaultManager];
    if ([filemgr createDirectoryAtPath:documentsDirectory withIntermediateDirectories:YES
                            attributes:nil error: NULL] == NO){
        NSLog(@"Failed to create local directory");
    }
    
    // Save file
    NSString *fullPath = [NSString stringWithFormat:@"%@/obj.png", documentsDirectory ];
    [operation setOutputStream:[NSOutputStream outputStreamToFileAtPath:fullPath append:NO]];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *imgData = [[NSData alloc] initWithContentsOfURL:[NSURL fileURLWithPath:fullPath]];
        UIImage *thumbNail = [[UIImage alloc] initWithData:imgData];
        self.currentCard.isManElQatelObjectDownloaded = [NSNumber numberWithBool:YES];
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
        [self saveImage:thumbNail];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"ERR: %@", [error description]);
    }];
    [operation start];
}
@end
