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
    [self downloadFile];
        
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
        NSError *error;
        NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:fullPath error:&error];
        NSData *imgData = [[NSData alloc] initWithContentsOfURL:[NSURL fileURLWithPath:fullPath]];
        UIImage *thumbNail = [[UIImage alloc] initWithData:imgData];
        if (error) {
            NSLog(@"ERR: %@", [error description]);
        }
        self.temp.image = thumbNail;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"ERR: %@", [error description]);
    }];
    
    [operation start];
}

@end
