//
//  H7FacebookLoginView.m
//  TheColorsConcorenza
//
//  Created by Heba Gamal on 4/13/14.
//  Copyright (c) 2014 Heba Gamal. All rights reserved.
//

#import "H7FacebookLoginView.h"
#import "H7AppDelegate.h"
#import "H7ConstantsModel.h"
#import "User.h"

#import <CoreData+MagicalRecord.h>
#import <AFNetworking/AFNetworking.h>
#import <FacebookSDK/FacebookSDK.h>

@interface H7FacebookLoginView () <FBLoginViewDelegate>

@end

@implementation H7FacebookLoginView {
    id <FBGraphUser> loggedInUser;
}

- (void)viewDidLoad
{
    /* Setting background image */
    int height =  [[UIScreen mainScreen] bounds].size.height;
    if(height > 480){
        UIImage *background = [UIImage imageNamed: @"bg_5.png"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage: background];
        [self.view insertSubview: imageView atIndex:0];
    }
    else{
        UIImage *background = [UIImage imageNamed: @"bg_4.png"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage: background];
        [self.view insertSubview: imageView atIndex:0];
    }
    
    NSArray *userArr = [User MR_findAll];
    if([userArr count]!=0) {
        User *u = [userArr firstObject];
        H7AppDelegate *appDel = (H7AppDelegate *)[[UIApplication sharedApplication] delegate];
        appDel.userFbId = u.userId;
        appDel.userName = u.userName;
        [self performSegueWithIdentifier:@"startApp" sender:self];
    }
    [super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated {

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(FBProfilePictureView*)getProfilePicture {
    FBProfilePictureView *view =[[FBProfilePictureView alloc] initWithProfileID:loggedInUser.id pictureCropping:FBProfilePictureCroppingSquare];
    return view;
}

- (BOOL) prefersStatusBarHidden
{
    return YES;
}


#pragma mark - FBLoginViewDelegate

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    
}

-(void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user {
    // Put global user info in app delegate
    H7AppDelegate *appDel = (H7AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDel.userFbId = user.id;
    appDel.userName = user.name;
    [self performSegueWithIdentifier:@"startApp" sender:self];
}




@end
