//
//  H7ManElQatelAudio.m
//  TheColorsConcorenza
//
//  Created by Heba Gamal on 5/27/14.
//  Copyright (c) 2014 Heba Gamal. All rights reserved.
//

#import "H7ManElQatelAudio.h"
#import "User.h"
#import "H7ConstantsModel.h"
#import "H7MosalslatScore.h"
#import "H7MosalslatScore.h"

#import <AFNetworking/AFNetworking.h>
#import <CoreData+MagicalRecord.h>

@interface H7ManElQatelAudio ()

@end

@implementation H7ManElQatelAudio {
    UITapGestureRecognizer *singleTap;
    UITapGestureRecognizer *doubleTap;

    NSTimer *aTimer;
    int currentScore;
    NSDate *currentDate;
    float x , y ;
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
    UITabBar *tabBar = self.tabBarController.tabBar;
    if(![tabBar isHidden]) {
        [self.navigationController.navigationBar setAlpha:0.0];
        [tabBar setHidden:YES];
    }
    
    singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(screenTapped:)];
    [singleTap setNumberOfTapsRequired:1];
    [singleTap setDelegate:self];
    [self.view addGestureRecognizer:singleTap];
    
    doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(screenDoubleTapped:)];
    [doubleTap setNumberOfTapsRequired:2];
    [doubleTap setDelegate:self];
    [self.view addGestureRecognizer:doubleTap];
    
    aTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(elapsedTime) userInfo:nil repeats:YES];
    
    x = [self.currentCard.iphone4x floatValue];
    y = [self.currentCard.iphone4y floatValue];
    
    if([self.currentCard.isFeenElSela7Played isEqualToNumber:[NSNumber numberWithBool:NO]]) {
        [self downloadfindTheObjectImage];
    }
    else
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        H7MosalslatScore *myController = [storyboard instantiateViewControllerWithIdentifier:@"mossalslatScore"];
        myController.score = [self.currentCard.cardScore intValue];
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
        
        [self.navigationController pushViewController: myController animated:YES];
    }
    currentDate = [[NSDate alloc] init];

    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL) prefersStatusBarHidden
{
    return YES;
}

- (IBAction)screenTapped:(id)sender {
    CGPoint tapPoint = [sender locationInView:self.view];
    NSLog(@"%f, %f",tapPoint.x,tapPoint.y);
    NSDate *timeNow = [[NSDate alloc] init];
    int timeTaken = [timeNow timeIntervalSinceDate:currentDate];
    currentScore =( (100 - (3*timeTaken)) > 10 ?(100 - (3*timeTaken))  : 10);
    NSLog(@"%d" , currentScore);
    if(tapPoint.x <= x + 25 && tapPoint.x >= x- 25 && tapPoint.y <= y + 25 && tapPoint.y >= y- 25) {
        NSArray *a = [User MR_findAll];
        User *u = [a firstObject];
        NSString *userId = u.userAccountId;
        NSString *catId = @"2";
        NSString *cardId = [NSString stringWithFormat:@"%@" , self.currentCard.cardId];
        NSString *Score = [NSString stringWithFormat:@"%d" , currentScore];
        [self updateScoreInDBWithUserId:userId catId:catId cardId:cardId score:Score];
        self.currentCard.cardScore = [NSNumber numberWithInt:currentScore];
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
        
        NSLog(@"%f, %f",tapPoint.x,tapPoint.y);
        UIImage *image = [self loadObject];
        NSArray *animationArray = [NSArray arrayWithObjects:image, nil];
        [NSTimer scheduledTimerWithTimeInterval:.50 target:self selector:@selector(myAnimate:) userInfo:nil repeats:NO];
        self.bottleImage.animationImages = animationArray;
        self.bottleImage.animationDuration = 0.3;
        self.bottleImage.animationRepeatCount = 1;
        [self.bottleImage startAnimating];
        CABasicAnimation *crossFade = [CABasicAnimation animationWithKeyPath:@"contents"];
        crossFade.autoreverses = YES;
        crossFade.repeatCount = 0;
        crossFade.duration = .5;
        
        double delayInSeconds = 1.7;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            H7MosalslatScore *myController = [storyboard instantiateViewControllerWithIdentifier:@"mossalslatScore"];
            myController.score = currentScore;
            self.currentCard.cardScore = [NSNumber numberWithInt:currentScore];
            [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
            
            if (self.navigationController.navigationBar.alpha < 1.0) {
                [self.navigationController.navigationBar setAlpha:1.0];
                UITabBar *tabBar = self.tabBarController.tabBar;
                [tabBar setHidden:![tabBar isHidden]];
            }
            [self.navigationController pushViewController: myController animated:YES];
        });
    }
}

- (UIImage*)loadObject
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* path = [documentsDirectory stringByAppendingPathComponent:
                      [NSString stringWithFormat:@"cards/manElQatel/%@/iphone4/find/obj.png" , self.currentCard.cardId]];
    NSLog(@"path = %@" , path);
    UIImage* image = [UIImage imageWithContentsOfFile:path];
    return image;
}



- (IBAction)screenDoubleTapped:(id)sender {
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
    
    [UIView animateWithDuration:0.0 animations:^
     {
         [self.navigationController.navigationBar setAlpha:alpha];
         [self.navigationController.toolbar setAlpha:alpha];
     } completion:^(BOOL finished)
     {
         
     }];
}



- (void) updateScoreInDBWithUserId:(NSString*)userId catId:(NSString*)catId cardId:(NSString*)cardId score:(NSString*)score {
    NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@update_score_for_card/format/json/userId/%@/catId/%@/cardId/%@/score/%@", PLATFORM_URL , userId,catId,cardId,score]];
    NSLog(@"%@" , url);
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:url];
    AFJSONRequestOperation *request = [AFJSONRequestOperation JSONRequestOperationWithRequest:urlRequest success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"%@" , JSON);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        // Get from core data
        NSLog(@"Failed to update score in server");
    }];
    [request start];
}

- (void) myAnimate :(NSTimer *)timer{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut]; // user dependent transition acn be set here
    self.bottleImage.alpha = !self.bottleImage.alpha;
    [UIView commitAnimations];
}

-(void)elapsedTime{
    static int i = 10;
    static int score = 100;
    currentScore = score;
    i--;
    score -= 10;
    if(i<0)
    {
        [aTimer invalidate];
        aTimer = nil;
    }
}


- (void)downloadfindTheObjectImage {
    // Set URL for image
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat: @"%@cards/manElQatel/%@/iphone4/find/bg.png" ,ASSETS_URL, self.currentCard.cardId]];
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
    NSString *fullPath = [NSString stringWithFormat:@"%@/bgg.png", documentsDirectory ];
    [operation setOutputStream:[NSOutputStream outputStreamToFileAtPath:fullPath append:NO]];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *imgData = [[NSData alloc] initWithContentsOfURL:[NSURL fileURLWithPath:fullPath]];
        UIImage *thumbNail = [[UIImage alloc] initWithData:imgData];
        self.findTheObjectImage.image = thumbNail;
        self.currentCard.isFeenElSela7Played = [NSNumber numberWithBool:YES];
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
        currentDate = [[NSDate alloc] init];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"ERR: %@", [error description]);
    }];
    [operation start];
}



@end
