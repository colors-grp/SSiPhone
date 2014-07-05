//
//  H7DownloadShahryarEpisode.m
//  TheColorsConcorenza
//
//  Created by Heba Gamal on 7/5/14.
//  Copyright (c) 2014 Heba Gamal. All rights reserved.
//

#import "H7DownloadShahryarEpisode.h"
#import "H7ConstantsModel.h"
#import "H7ShahryarStory.h"

#import <CoreData+MagicalRecord.h>
#import <AFNetworking/AFNetworking.h>
@interface H7DownloadShahryarEpisode ()

@end

@implementation H7DownloadShahryarEpisode{
    int curPanel , maxPanel , downloadedPanels;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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
    
    curPanel = 1 , downloadedPanels = 0;
    maxPanel = [self.currentCard.numberOfPanelsShahryar intValue];
    maxPanel--;
    
    NSData *imgData = self.currentCard.imageBinary;
    UIImage *thumbNail = [UIImage imageWithData:imgData scale:1.0f];
    [self.episodeImage setImage:thumbNail];
    
    // Setting shoof l 7al2a button
    UIBarButtonItem *quizButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"شوف الحلقه"
                                   style:UIBarButtonItemStyleBordered
                                   target:self
                                   action:@selector(startEpisode:)];
    self.navigationItem.rightBarButtonItem = quizButton;


    if([self.currentCard.isEpisodeDownloaded isEqualToNumber:[NSNumber numberWithBool:NO]]){
        self.progressBar.progress = 0;
        [self downloadEpisode:0];
        self.statusLabel.text = @"جاري تنزيل الحلقه";
    }else{
        self.progressBar.progress = 1;
        self.statusLabel.text = @"تم التنزيل";
    }
    
    
    // Do any additional setup after loading the view.
}


-(IBAction)startEpisode:(id)sender {
    if([self.currentCard.isEpisodeDownloaded isEqualToNumber:[NSNumber numberWithBool:YES]]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        H7ShahryarStory *story = [storyboard instantiateViewControllerWithIdentifier:@"shahryarStory"];
        story.currentCard = self.currentCard;
        [self.navigationController pushViewController:story animated:YES];
    }else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Downloading ..." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)saveImage: (UIImage*)image imageNum:(int)imageNum
{
    if (image != nil)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                             NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString* path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"cards/shahryar/%@/story/%d.png" , self.currentCard.cardId , imageNum+100]];
        NSLog(@"saving image path = %@" , path);
        NSData* data = UIImagePNGRepresentation(image);
        [data writeToFile:path atomically:YES];
    }else {
        NSLog(@"2ool ya 7aqeer");
    }
}


- (void)downloadEpisode:(int)panelId {
    // Set URL for image
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat: @"%@cards/shahryar/%@/iphone4/story/%d.png" ,ASSETS_URL,self.currentCard.cardId , (int)panelId]];
    NSLog(@"%@" , url);
    // Set the request
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    // Get directory to save & retrieve image
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"cards/shahryar/%@/story" , self.currentCard.cardId]];
    
    // Create directory
    NSFileManager *filemgr;
    filemgr =[NSFileManager defaultManager];
    if ([filemgr createDirectoryAtPath:documentsDirectory withIntermediateDirectories:YES
                            attributes:nil error: NULL] == NO){
        NSLog(@"Failed to create local directory");
    }
    
    // Save file
    NSString *fullPath = [NSString stringWithFormat:@"%@/%d.png", documentsDirectory , curPanel];
    [operation setOutputStream:[NSOutputStream outputStreamToFileAtPath:fullPath append:NO]];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *imgData = [[NSData alloc] initWithContentsOfURL:[NSURL fileURLWithPath:fullPath]];
        NSLog(@"img# %d downloaded" , panelId);
        UIImage *thumbNail = [[UIImage alloc] initWithData:imgData];
        [self saveImage:thumbNail imageNum:panelId];
        downloadedPanels ++;
        if(downloadedPanels == maxPanel + 1) {
            self.currentCard.isEpisodeDownloaded =[NSNumber numberWithBool:YES];
            [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
            //go to other view
            
        }else {
            [self downloadEpisode:panelId+1];
        }
        self.progressBar.progress = ((100.0/[self.currentCard.numberOfPanelsShahryar floatValue])*downloadedPanels)/100;

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"ERR: %@", [error description]);
        [self downloadEpisode:panelId];
    }];
    [operation start];
}


@end
