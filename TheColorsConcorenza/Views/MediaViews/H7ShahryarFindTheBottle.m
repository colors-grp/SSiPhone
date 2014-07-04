//
//  H7ShahryarFindTheBottle.m
//  TheColorsConcorenza
//
//  Created by Heba Gamal on 6/15/14.
//  Copyright (c) 2014 Heba Gamal. All rights reserved.
//

#import "H7ShahryarFindTheBottle.h"
#import "H7ConstantsModel.h"
#import "User.h"
#import <AFNetworking/AFNetworking.h>
#import <CoreData+MagicalRecord.h>

@interface H7ShahryarFindTheBottle ()

@end

@implementation H7ShahryarFindTheBottle{
    UITapGestureRecognizer *singleTap;
    NSTimer *aTimer;
    int currentScore;
    NSDate *currentDate;
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

    singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(screenTapped:)];
    [singleTap setNumberOfTapsRequired:1];
    [singleTap setDelegate:self];
    [self.view addGestureRecognizer:singleTap];
    
    aTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(elapsedTime) userInfo:nil repeats:YES];
    if([self.currentCard.isShahryarFindTheBottleDownloaded isEqualToNumber:[NSNumber numberWithBool:NO]])
        [self downloadFindTheBottleImage];
    else
        NSLog(@"already played");
//    self.findTheBottleImage.image = [UIImage imageNamed:@"game1.png"];
//    [self loadImage];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)screenTapped:(id)sender {
    CGPoint tapPoint = [sender locationInView:self.view];
    NSLog(@"%f, %f",tapPoint.x,tapPoint.y);
    NSDate *timeNow = [[NSDate alloc] init];
    int timeTaken = [timeNow timeIntervalSinceDate:currentDate];
    currentScore =( (100 - (3*timeTaken)) > 10 ?(100 - (3*timeTaken))  : 10);
    NSLog(@"%d" , currentScore);
    if(true) { // badalo put if in correct zone
        NSArray *a = [User MR_findAll];
        User *u = [a firstObject];
        NSString *userId = u.userAccountId;
        NSString *catId = @"4";
        NSString *cardId = [NSString stringWithFormat:@"%@" , self.currentCard.cardId];
        NSString *Score = [NSString stringWithFormat:@"%d" , currentScore];
        [self updateScoreInDBWithUserId:userId catId:catId cardId:cardId score:Score];
        self.currentCard.cardScore = [NSNumber numberWithInt:currentScore];
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
        

        NSArray *animationArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"bottle.png"],[UIImage imageNamed:@"bottle_glow.png"], nil];
        [NSTimer scheduledTimerWithTimeInterval:.50 target:self selector:@selector(myAnimate:) userInfo:nil repeats:NO];
        self.bottleImage.animationImages = animationArray;
        self.bottleImage.animationDuration = 0.3;
        self.bottleImage.animationRepeatCount = 1;
        [self.bottleImage startAnimating];
        CABasicAnimation *crossFade = [CABasicAnimation animationWithKeyPath:@"contents"];
        crossFade.autoreverses = YES;
        crossFade.repeatCount = 0;
        crossFade.duration = .5;
    }
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

- (void)downloadFindTheBottleImage {
    // Set URL for image
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat: @"%@cards/shahryar/%@/iphone4/find/bg.png" ,ASSETS_URL, self.currentCard.cardId]];
    NSLog(@"%@" , url);
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
        NSLog(@"downloaded");
        NSData *imgData = [[NSData alloc] initWithContentsOfURL:[NSURL fileURLWithPath:fullPath]];
        UIImage *thumbNail = [[UIImage alloc] initWithData:imgData];
        NSLog(@"%@" , imgData);
        self.findTheBottleImage.image = thumbNail;
        self.currentCard.isShahryarFindTheBottleDownloaded = [NSNumber numberWithBool:YES];
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
        currentDate = [[NSDate alloc] init];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"ERR: %@", [error description]);
    }];
    [operation start];
}


@end
