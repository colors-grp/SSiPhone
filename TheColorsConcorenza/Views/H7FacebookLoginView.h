//
//  H7FacebookLoginView.h
//  TheColorsConcorenza
//
//  Created by Heba Gamal on 4/13/14.
//  Copyright (c) 2014 Heba Gamal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>


@interface H7FacebookLoginView : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *segueButton;

-(FBProfilePictureView*)getProfilePicture;

@end
