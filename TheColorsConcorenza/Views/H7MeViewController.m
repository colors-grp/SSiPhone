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
    User *user;
}

@end

@implementation H7MeViewController {
    BOOL _accumulatingParsedCharacterData;
}

- (void)viewDidLoad
{
    /* Setting background image */
    UIImage *background = [UIImage imageNamed: @"me_bg_4_logo_2.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage: background];
    [self.view insertSubview: imageView atIndex:1];
    
    /* Getting User */
    user = [[User MR_findAll] firstObject];
    
    /* getting profile picture */
    H7AppDelegate *appDel = [[UIApplication sharedApplication] delegate];
    self.fbProfilePicture.profileID = appDel.userFbId;
    
    /* getting user name */
    self.userNameLabel.text = appDel.userName;
    
    //Setting score labels color
    self.sallySyamakScore.textColor = [UIColor whiteColor];
    self.mosalslatScore.textColor = [UIColor whiteColor];
    self.manElQatelScore.textColor = [UIColor whiteColor];
    self.shahryarScore.textColor = [UIColor whiteColor];
    
    // Putting score labels fel zeina
    self.sallySyamakScore.transform =  CGAffineTransformMakeRotation(28 * M_PI / 180.0);
    self.mosalslatScore.transform =CGAffineTransformMakeRotation(8 * M_PI / 180.0);
    self.manElQatelScore.transform = CGAffineTransformMakeRotation(-12 * M_PI / 180.0);
    self.shahryarScore.transform = CGAffineTransformMakeRotation(-15 * M_PI / 180.0);
    
    // get categories scores
    [self getCategoryScores];
    
    [self getFbInfo];
        
    [super viewDidLoad];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getCategoryScores {
    H7AppDelegate *appDel = [[UIApplication sharedApplication] delegate];
    NSURL *url = [[NSURL alloc] initWithString:[ NSString stringWithFormat:@"%@score/format/json/facebookId/%@", PLATFORM_URL ,appDel.userFbId]];
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:url];
    AFJSONRequestOperation *request = [AFJSONRequestOperation JSONRequestOperationWithRequest:urlRequest success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSDictionary *dict = JSON;
        self.sallySyamakScore.text = [dict objectForKey:@"sallySyamak"];
        self.mosalslatScore.text = [dict objectForKey:@"mosalslat"];
        self.manElQatelScore.text = [dict objectForKey:@"manElQatel"];
        self.shahryarScore.text = [dict objectForKey:@"shahryar"];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        // Get score from core data
        NSLog(@"Failed to get scores");
    }];
    [request start];
}

- (void)downloadFile {
    
    NSURL *url = [NSURL URLWithString:@"http://gloryette.org/mobile/assets/fara7.jpg"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"Cards/lol"];
    
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"MyCard"];
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"xx"];
    
    NSFileManager *filemgr;
    filemgr =[NSFileManager defaultManager];
    
    if ([filemgr createDirectoryAtPath:documentsDirectory withIntermediateDirectories:YES
                            attributes:nil error: NULL] == NO)
    {
        // Failed to create directory
    }
    
    
    NSString *fullPath = [NSString stringWithFormat:@"%@/a.jpeg",
                          documentsDirectory];
    NSLog(@"full path = %@" , fullPath);
    
    [operation setOutputStream:[NSOutputStream outputStreamToFileAtPath:fullPath append:NO]];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *imgData = [[NSData alloc] initWithContentsOfURL:[NSURL fileURLWithPath:fullPath]];
        UIImage *thumbNail = [[UIImage alloc] initWithData:imgData];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"ERR: %@", [error description]);
    }];
    
    [operation start];
}

-(void)getFbInfo{
    [FBSession openActiveSessionWithReadPermissions:@[@"basic_info"]
                                       allowLoginUI:YES
                                  completionHandler:
     ^(FBSession *session, FBSessionState state, NSError *error) {
         if(!error && state == FBSessionStateOpen) {
             { [FBRequestConnection startWithGraphPath:@"me" parameters:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"id,name,first_name,last_name,username,email,birthday",@"fields",nil] HTTPMethod:@"GET" completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                     NSDictionary *userData = (NSDictionary *)result;
                     NSString *userId = [userData objectForKey:@"id"];
                     NSString *username = [userData objectForKey:@"username"];
                     NSString *firstName= [userData objectForKey:@"first_name"];
                     NSString *lastName= [userData objectForKey:@"last_name"];
                     NSString *birthday  = [userData objectForKey:@"birthday"];
                     NSString *email= [userData objectForKey:@"email"];
                     NSLog(@"%@" , userData);
            
                     birthday = [birthday stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
                 email = [email stringByReplacingOccurrencesOfString:@"@" withString:@"%"];
                     //begining
                     NSURL *url = [[NSURL alloc] initWithString:[ NSString stringWithFormat:@"%@add_new_user/format/json/facebookId/%@/username/%@/firstname/%@/lastname/%@/birthday/%@/email/%@",PLATFORM_URL , userId , username , firstName , lastName , birthday, email]];
                     NSLog(@"%@add_new_user/format/json/facebookId/%@/username/%@/firstname/%@/lastname/%@/birthday/%@/email/%@",PLATFORM_URL , userId , username , firstName , lastName , birthday, email );
                     NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:url];
                     AFJSONRequestOperation *request = [AFJSONRequestOperation JSONRequestOperationWithRequest:urlRequest success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                         NSDictionary *dict = JSON;
                         NSLog(@"%@" , dict);
                         [self performSegueWithIdentifier:@"startApp" sender:self];
                     } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                         // Get score from core data
                         NSLog(@"Failed");
                     }];
                     [request start];
                 //end
             }];
             }
         }
     }];
}

//-(void)getFbProfilrPicture {
//    [FBSession openActiveSessionWithReadPermissions:@[@"basic_info"]
//                                       allowLoginUI:YES
//                                  completionHandler:
//     ^(FBSession *session, FBSessionState state, NSError *error) {
//         if(!error && state == FBSessionStateOpen) {
//             { [FBRequestConnection startWithGraphPath:@"me" parameters:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"id,name,first_name,last_name,username,email,picture",@"fields",nil] HTTPMethod:@"GET" completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
//                 NSDictionary *userData = (NSDictionary *)result;
//                 NSString *imageUrl = [[[userData objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"];
//                 
//             }];
//             }
//         }
//     }];
//}
//
//- (void)downloadProfilePicture:(NSString*)fbUrl {
//    NSURL *url = [NSURL URLWithString:fbUrl];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//    // Get directory to save & retrieve image
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"user"];
//    
//    // Create directory
//    NSFileManager *filemgr;
//    filemgr =[NSFileManager defaultManager];
//    if ([filemgr createDirectoryAtPath:documentsDirectory withIntermediateDirectories:YES
//                            attributes:nil error: NULL] == NO){
//        NSLog(@"Failed to create local directory");
//    }
//    
//    // Save file
//    NSString *fullPath = [NSString stringWithFormat:@"%@/pp.jpg", documentsDirectory];
//    [operation setOutputStream:[NSOutputStream outputStreamToFileAtPath:fullPath append:NO]];
//    
//    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSData *imgData = [[NSData alloc] initWithContentsOfURL:[NSURL fileURLWithPath:fullPath]];
//        [imgData writeToFile:fullPath atomically:YES];
//        UIImage *thumbNail = [[UIImage alloc] initWithData:imgData];
//        //Set image with thumbnail here
//        self.profilePicture.image = thumbNail;
//        //Set user image in core data
//        user.userProfilePicture = imgData;
//        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSData *imgData = user.userProfilePicture;
//        UIImage *thumbNail = [UIImage imageWithData:imgData scale:1.0f];
//        [self.profilePicture setImage:thumbNail];
//
//    }];
//    [operation start];
//
//}

- (IBAction)playVideo:(id)sender {
    NSString *videoPath = [[NSBundle mainBundle] pathForResource:@"samir2"
                                                          ofType:@"mp4" inDirectory:@"vid"];
    self.player = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL
                                                                           fileURLWithPath:videoPath]];
    [self presentMoviePlayerViewControllerAnimated:self.player];
}

@end
