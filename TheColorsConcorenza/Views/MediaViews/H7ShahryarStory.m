
//
//  H7ShahryarStory.m
//  TheColorsConcorenza
//
//  Created by Heba Gamal on 5/27/14.
//  Copyright (c) 2014 Heba Gamal. All rights reserved.
//

#import "H7ShahryarStory.h"
#import "H7ShahryarFindTheBottle.h"

#import "H7ConstantsModel.h"
#import <CoreData+MagicalRecord.h>
#import <AFNetworking/AFNetworking.h>

@interface H7ShahryarStory ()

@end

@implementation H7ShahryarStory {
    int curPanel , maxPanel , downloadedPanels;
}

- (void)viewDidLoad
{
    /* Setting background image */
    int height =  [[UIScreen mainScreen] bounds].size.height;
    if(height > 480) {
        UIImage *background = [UIImage imageNamed: @"bg_all_5.png"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage: background];
        [self.view insertSubview: imageView atIndex:0];
    } else {
        UIImage *background = [UIImage imageNamed: @"bg_all_4.png"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage: background];
        [self.view insertSubview: imageView atIndex:0];
    }
    
    // Set current panel and maximum number of panels
    curPanel = 1 , downloadedPanels = 0;
    maxPanel = [self.currentCard.numberOfPanelsShahryar intValue];
    
    for ( int i = 1; i < maxPanel + 1 ; i++ ) {
        [self downloadEpisode:i];
    }
    
    UISwipeGestureRecognizer * swipeleft=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeleft:)];
    swipeleft.direction=UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeleft];
    
    UISwipeGestureRecognizer * swiperight=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swiperight:)];
    swiperight.direction=UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swiperight];
    
    // Set first page
//    self.storyPanel.image = [UIImage imageNamed:[NSString stringWithFormat:@"Categories/shahryar/cards/%@/%d.png" , self.currentCard.cardId , curPanel]];
    NSLog(@"cur panel = %d" , curPanel);
    self.storyPanel.frame=CGRectMake(0,0,320,480);
    self.storyPanel.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.png" , curPanel]];
//    self.storyPanel.frame=CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height);
    NSLog(@"cur panel = %d" , curPanel);
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)swipeleft:(UISwipeGestureRecognizer*)gestureRecognizer
{
    if(curPanel < maxPanel) {
        curPanel++;
        self.storyPanel.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.png", curPanel]];
    }
    else if(curPanel == maxPanel) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        H7ShahryarFindTheBottle *findTheBottle = [storyboard instantiateViewControllerWithIdentifier:@"shahryarFindTheBottle"];
        [self.navigationController pushViewController:findTheBottle animated:YES];
    }
}

-(void)swiperight:(UISwipeGestureRecognizer*)gestureRecognizer
{
    if(curPanel > 1) {
        curPanel--;
        self.storyPanel.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.png" , curPanel]];
    }
}

- (void)downloadEpisode:(int)panelId {
    // Set URL for image
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat: @"%@cards/shahryar/%@/story/%d.png" ,ASSETS_URL,self.currentCard.cardId , (int)panelId]];
    
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
        [imgData writeToFile:fullPath atomically:YES];
        UIImage *thumbNail = [[UIImage alloc] initWithData:imgData];
//        self.storyPanel.image = thumbNail;
        downloadedPanels ++;
        if(downloadedPanels == maxPanel) {
            self.currentCard.isEpisodeDownloaded =[NSNumber numberWithBool:YES];
            [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
            //reload collection view
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"ERR: %@", [error description]);
    }];
    [operation start];
}

@end
