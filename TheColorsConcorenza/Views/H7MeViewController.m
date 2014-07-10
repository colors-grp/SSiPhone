//
//  H7MeViewController.m
//  TheColorsConcorenza
//
//  Created by Heba Gamal on 3/26/14.
//  Copyright (c) 2014 Heba Gamal. All rights reserved.
//

#import "H7AppDelegate.h"
#import "H7FacebookLoginView.h"

#import "H7MeViewController.h"
#import "H7FavouriteCategoryCell.h"
#import "MyCategory.h"

#import "H7ConstantsModel.h"
#import "User.h"
#import "H7FacebookLoginView.h"

#import <AFNetworking.h>
#import <CoreData+MagicalRecord.h>

@interface H7MeViewController () {
    NSMutableArray *favouriteArray;
    MyCategory *selectedCategory;
    NSArray *users;
}

@end

@implementation H7MeViewController {
    NSData *binaryImage;
}

- (void)viewDidLoad
{
    /* Setting background image */
    int height =  [[UIScreen mainScreen] bounds].size.height;
    if(height > 480){
        UIImage *background = [UIImage imageNamed: @"me_bg_5.png"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage: background];
        [self.view insertSubview: imageView atIndex:1];
        
        // Setting labels positions
        [self.sallySyamakScore removeFromSuperview];
        [self.sallySyamakScore setTranslatesAutoresizingMaskIntoConstraints:YES];
        [self.sallySyamakScore setFrame:CGRectMake(10, 166, 59, 42)];
        [self.view addSubview:self.sallySyamakScore];
        
        [self.mosalslatScore removeFromSuperview];
        [self.mosalslatScore setTranslatesAutoresizingMaskIntoConstraints:YES];
        [self.mosalslatScore setFrame:CGRectMake(72, 183, 45, 21)];
        [self.view addSubview:self.mosalslatScore];
        
        [self.manElQatelScore removeFromSuperview];
        [self.manElQatelScore setTranslatesAutoresizingMaskIntoConstraints:YES];
        [self.manElQatelScore setFrame:CGRectMake(195, 168, 54 , 38)];
        [self.view addSubview:self.manElQatelScore];
        
        [self.shahryarScore removeFromSuperview];
        [self.shahryarScore setTranslatesAutoresizingMaskIntoConstraints:YES];
        [self.shahryarScore setFrame:CGRectMake(245, 146, 68, 61)];
        [self.view addSubview:self.shahryarScore];
        
        [self.fbProfilePictureImageView removeFromSuperview];
        [self.fbProfilePictureImageView setTranslatesAutoresizingMaskIntoConstraints:YES];
        [self.fbProfilePictureImageView setFrame:CGRectMake(68, 186, 180 ,180)];
        [self.view insertSubview:self.fbProfilePictureImageView atIndex:0];
    }
    else{
        UIImage *background = [UIImage imageNamed: @"me_bg_4.png"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage: background];
        [self.view insertSubview: imageView atIndex:1];
    }
    // Getting user PP
    NSArray *a = [User MR_findAll];
    H7AppDelegate *appDel = [[UIApplication sharedApplication] delegate];
    if([a count] == 0) {
        self.fbProfilePicture.profileID = appDel.userFbId;
    }else {
        User *u = [a firstObject];
        NSData *imgData = u.userProfilePicture;
        UIImage *thumbNail = [UIImage imageWithData:imgData scale:1.0f];
//        NSLog(@"img data = %@" , imgData);
        self.fbProfilePictureImageView.image = thumbNail;
        [self getCategoryScoresWithAccountId:u.userAccountId];
    }
    
    // Insert user in DB
    [self getFbInfo];
    
    /* getting user name */
    self.userNameLabel.text = appDel.userName;
    self.userNameLabel.textColor = [UIColor colorWithRed:(212/255.0) green:(39/255.0) blue:(51/255.0) alpha:1];
    
    //Setting score labels color
    self.sallySyamakScore.textColor = [UIColor whiteColor];
    self.mosalslatScore.textColor = [UIColor whiteColor];
    self.manElQatelScore.textColor = [UIColor whiteColor];
    self.shahryarScore.textColor = [UIColor whiteColor];
    
    // Putting score labels fel zeina
    self.sallySyamakScore.transform =  CGAffineTransformMakeRotation(22 * M_PI / 180.0);
    self.mosalslatScore.transform =CGAffineTransformMakeRotation(8 * M_PI / 180.0);
    self.manElQatelScore.transform = CGAffineTransformMakeRotation(-12 * M_PI / 180.0);
    self.shahryarScore.transform = CGAffineTransformMakeRotation(-15 * M_PI / 180.0);
    
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated {
    NSArray *a = [User MR_findAll];
    if([a count]) {
        User *u = [a firstObject];
        [self getCategoryScoresWithAccountId:u.userAccountId];
    }
}


- (void) getUserImageFromFBView:(User*)loggedUser{
    UIImageView *objImg;
    for (NSObject *obj in [self.fbProfilePicture subviews]) {
        if ([obj isMemberOfClass:[UIImageView class]]) {
            objImg = (UIImageView *)obj;
            break;
        }
    }
    self.fbProfilePictureImageView.image = objImg.image;
    loggedUser.userProfilePicture = UIImagePNGRepresentation(objImg.image);
//    NSLog(@"pic = %@" , loggedUser.userProfilePicture);
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getCategoryScoresWithAccountId:(NSString*)accountId {
        NSURL *url = [[NSURL alloc] initWithString:[ NSString stringWithFormat:@"%@score/format/json/userId/%@", PLATFORM_URL ,accountId]];
        NSLog(@"url = %@" , url);
        NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:url];
        AFJSONRequestOperation *request = [AFJSONRequestOperation JSONRequestOperationWithRequest:urlRequest success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            NSDictionary *dict = JSON;
            NSLog(@"scores = %@" , dict );
            self.sallySyamakScore.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"sallySyamak"]];
            self.mosalslatScore.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"mosalslat"]];
            self.manElQatelScore.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"manElQatel"]];
            self.shahryarScore.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"shahryar"]];
            NSArray *categories = [MyCategory MR_findAll];
            for (int i=0 ; i < [categories count]; i++) {
                MyCategory *curCat = [categories objectAtIndex:i];
                if([curCat.categoryName isEqualToString:@"shahryar"])
                    curCat.userScore =[NSString stringWithFormat:@"%@",[dict objectForKey:@"shahryar"]];
                if([curCat.categoryName isEqualToString:@"manElQatel"])
                    curCat.userScore =[NSString stringWithFormat:@"%@",[dict objectForKey:@"manElQatel"]];
                if([curCat.categoryName isEqualToString:@"mosalslat"])
                    curCat.userScore =[NSString stringWithFormat:@"%@",[dict objectForKey:@"mosalslat"]];
                if([curCat.categoryName isEqualToString:@"sallySyamak"])
                    curCat.userScore =[NSString stringWithFormat:@"%@",[dict objectForKey:@"sallySyamak"]];
            }
            [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            // Get score from core data
            NSArray *categories = [MyCategory MR_findAll];
            for (int i=0 ; i<[categories count] ; i++) {
                MyCategory *curCat = [categories objectAtIndex:i];
                if([curCat.categoryName isEqualToString:@"shahryar"])
                    self.shahryarScore.text = curCat.userScore;
                if([curCat.categoryName isEqualToString:@"manElQatel"])
                    self.manElQatelScore.text= curCat.userScore;
                if([curCat.categoryName isEqualToString:@"mosalslat"])
                    self.mosalslatScore.text= curCat.userScore;
                if([curCat.categoryName isEqualToString:@"sallySyamak"])
                    self.sallySyamakScore.text= curCat.userScore;
            }
        }];
        [request start];
}

-(void)insertUserScoresWithAccountId:(NSString*)accountId fullName:(NSString*)fullname {
    NSString *str = [NSString stringWithFormat:@"%@add_new_usercategories/format/json/user_id/%@/fullname/%@" , PLATFORM_URL , accountId , fullname];
    NSLog(@"insert user in scoreboard %@",str);
    NSURL *url = [[NSURL alloc] initWithString:[str stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:url];
    AFJSONRequestOperation *request = [AFJSONRequestOperation JSONRequestOperationWithRequest:urlRequest success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSDictionary *dict = JSON;
        NSLog(@"return = %@" , dict);
        [self getCategoryScoresWithAccountId:accountId];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        // Get score from core data
        NSLog(@"Failed to insert user to scoreboard");
    }];
    [request start];
}

-(void)getFbInfo{
    users = [User MR_findAll];
    if([users count] == 0 ) { //REMEBER to set back to ZERO
        [FBSession openActiveSessionWithReadPermissions:@[@"basic_info"] allowLoginUI:YES completionHandler: ^(FBSession *session, FBSessionState state, NSError *error) {
             if(!error && state == FBSessionStateOpen) {
                 {
                     [FBSession openActiveSessionWithPublishPermissions:@[@"publish_actions"] defaultAudience:FBSessionDefaultAudienceEveryone allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                         [FBRequestConnection startWithGraphPath:@"me" parameters:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"id,name,first_name,last_name,username,email,birthday",@"fields",nil] HTTPMethod:@"GET" completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                             NSDictionary *userData = (NSDictionary *)result;
                             NSString *userId = [userData objectForKey:@"id"];
                             NSString *username = [userData objectForKey:@"username"];
                             NSString *firstName= [userData objectForKey:@"first_name"];
                             NSString *lastName= [userData objectForKey:@"last_name"];
                             NSString *birthday  = [userData objectForKey:@"birthday"];
                             NSString *email= [userData objectForKey:@"email"];
                             NSString *fbAccessToken = [[[FBSession activeSession] accessTokenData] accessToken];
                             birthday = [birthday stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
                             email = [email stringByReplacingOccurrencesOfString:@"@" withString:@"%"];
                             NSLog(@"%@ \n %@" , userData , fbAccessToken);
                             
                             if(username == NULL || username == nil )
                                 username = userId;
                             
                             // Saving User information in core data
                             User * loggedUser = [User MR_createEntity];
                             loggedUser.userName = username;
                             loggedUser.userId = userId;
                             loggedUser.userBirthday = birthday;
                             loggedUser.userFirstName = firstName;
                             [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
                             
                             NSLog(@"core data %@ %@" , loggedUser.userName , loggedUser.userBirthday);
                             NSString *str = [NSString stringWithFormat:@"%@mobileAddMe/username/%@/firstname/%@/lastname/%@/email/%@/credit/0/birthday/%@/fb_id/%@/token/%@/format/json" , CORE_URL , username , firstName , lastName , email ,birthday , userId , fbAccessToken];
                             NSURL *url = [[NSURL alloc] initWithString:[str stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
                             NSLog(@"%@" , url);
                             NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:url];
                             AFJSONRequestOperation *request = [AFJSONRequestOperation JSONRequestOperationWithRequest:urlRequest success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                 NSDictionary *dict = JSON;
                                 NSLog(@"return = %@" , dict);
                                 loggedUser.userAccountId = [NSString stringWithFormat:@"%@" , [dict objectForKey:@"accountId"]];
                                 [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
                                 [self performSelector:@selector(getUserImageFromFBView:) withObject:loggedUser afterDelay:4.0];
                                 
                                 // Insert user to scoreboards
                                 [self insertUserScoresWithAccountId:loggedUser.userAccountId fullName:[NSString stringWithFormat:@"%@ %@" , firstName , lastName]];
                                 NSLog(@"here1");
                             } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                 // Get score from core data
                                 NSLog(@"Failed");
                             }];
                             [request start];
                         }]; 
                     }];
                 }
             }
         }];
    }else {
        User *u = [users firstObject];
        NSLog(@"%@" , u);
        [self getCategoryScoresWithAccountId:u.userAccountId];
    }
}


- (IBAction)playVideo:(id)sender {
    NSString *videoPath = [[NSBundle mainBundle] pathForResource:@"samir2"
                                                          ofType:@"mp4" inDirectory:@"vid"];
    self.player = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL
                                                                           fileURLWithPath:videoPath]];
    [self presentMoviePlayerViewControllerAnimated:self.player];
}

@end
