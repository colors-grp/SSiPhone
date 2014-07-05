
//
//  H7ShahryarStory.m
//  TheColorsConcorenza
//
//  Created by Heba Gamal on 5/27/14.
//  Copyright (c) 2014 Heba Gamal. All rights reserved.
//

#import "H7ShahryarStory.h"
#import "H7ShahryarFindTheBottle.h"
#import "H7MosalslatScore.h"
#import "H7ConstantsModel.h"
#import <CoreData+MagicalRecord.h>
#import <AFNetworking/AFNetworking.h>

@interface H7ShahryarStory ()

@end

@implementation H7ShahryarStory {
    int curPanel , maxPanel , downloadedPanels;
    UITapGestureRecognizer *singleTap;
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
    
    // Hide Activity Indicator
    [self.activityIndicator setHidden:YES];
    NSLog(@"%d" , self.activityIndicator.hidden);
    
    // Set current panel and maximum number of panels
    curPanel = 1 , downloadedPanels = 0;
    maxPanel = [self.currentCard.numberOfPanelsShahryar intValue];
    maxPanel--;
    
    singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(screenTapped)];
    [singleTap setNumberOfTapsRequired:1];
    [singleTap setDelegate:self];
    [self.view addGestureRecognizer:singleTap];
    
    UISwipeGestureRecognizer * swipeleft=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeleft:)];
    swipeleft.direction=UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipeleft];
    
    UISwipeGestureRecognizer * swiperight=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swiperight:)];
    swiperight.direction=UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:swiperight];
    

    if([self.currentCard.isEpisodeDownloaded isEqualToNumber:[NSNumber numberWithBool:YES]])
        [self loadImage:curPanel];
    else {
        [self.view setUserInteractionEnabled:NO];
        [self.activityIndicator setHidden:NO];
        [self.activityIndicator startAnimating];
        
        [self downloadEpisode:0];
    }

    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)screenTapped
{
    CGFloat alpha = 0.0;
    
    if (self.navigationController.navigationBar.alpha < 1.0)
        alpha = 1.0;
    
    //Toggle visible/hidden status bar.
    //This will only work if the Info.plist file is updated with two additional entries
    //"View controller-based status bar appearance" set to NO and "Status bar is initially hidden" set to YES or NO
    //Hiding the status bar turns the gesture shortcuts for Notification Center and Control Center into 2 step gestures
    [[UIApplication sharedApplication]setStatusBarHidden:![[UIApplication sharedApplication]isStatusBarHidden] withAnimation:UIStatusBarAnimationFade];
    
    //Toggle visible/hidden tabbar.
    UITabBar *tabBar = self.tabBarController.tabBar;
    [tabBar setHidden:![tabBar isHidden]];
    
    [UIView animateWithDuration:0.25 animations:^
     {
         [self.navigationController.navigationBar setAlpha:alpha];
         [self.navigationController.toolbar setAlpha:alpha];
     } completion:^(BOOL finished)
     {
         
     }];
    
}


-(void)swipeleft:(UISwipeGestureRecognizer*)gestureRecognizer
{
    NSLog(@"%d , max = %d" , curPanel , maxPanel);
    if(curPanel < maxPanel) {
        curPanel++;
        [self loadImage:curPanel];
    }
    else if(curPanel >= maxPanel) {
        if([[UIApplication sharedApplication]isStatusBarHidden])
            [[UIApplication sharedApplication]setStatusBarHidden:![[UIApplication sharedApplication]isStatusBarHidden] withAnimation:UIStatusBarAnimationFade];
        UITabBar *tabBar = self.tabBarController.tabBar;
        if([tabBar isHidden])
            [tabBar setHidden:![tabBar isHidden]];

        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        if([self.currentCard.isShahryarFindTheBottleDownloaded isEqualToNumber:[NSNumber numberWithBool:NO]])
        {
            H7ShahryarFindTheBottle *findTheBottle = [storyboard instantiateViewControllerWithIdentifier:@"shahryarFindTheBottle"];
            findTheBottle.currentCard = self.currentCard;
            [self.navigationController pushViewController:findTheBottle animated:YES];
        }else {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            H7MosalslatScore *myController = [storyboard instantiateViewControllerWithIdentifier:@"mossalslatScore"];
            myController.score = [self.currentCard.cardScore intValue];
            [self.navigationController pushViewController: myController animated:YES];
        }
    }
}

-(void)swiperight:(UISwipeGestureRecognizer*)gestureRecognizer
{
    NSLog(@"%d" , curPanel);
    if(curPanel > 1) {
        curPanel--;
        [self loadImage:curPanel];
    }
    NSLog(@"%d" , curPanel);
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

- (void)loadImage:(int)imageNumber
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* path = [documentsDirectory stringByAppendingPathComponent:
                      [NSString stringWithFormat:@"cards/shahryar/%@/story/%d.png" , self.currentCard.cardId , imageNumber+100]];
    NSLog(@"path = %@" , path);
    UIImage* image = [UIImage imageWithContentsOfFile:path];
    self.storyPanel.image = image;
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
            [self.view setUserInteractionEnabled:YES];
            [self.activityIndicator stopAnimating];
            [self.activityIndicator setHidden:YES];
            self.currentCard.isEpisodeDownloaded =[NSNumber numberWithBool:YES];
            [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
        }else {
            [self downloadEpisode:panelId+1];
        }
        if (panelId == 1) {
            [self loadImage:1];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"ERR: %@", [error description]);
        [self downloadEpisode:panelId];
    }];
    [operation start];
}

@end
