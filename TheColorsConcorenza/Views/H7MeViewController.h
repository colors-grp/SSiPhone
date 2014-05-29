//
//  H7MeViewController.h
//  TheColorsConcorenza
//
//  Created by Heba Gamal on 3/26/14.
//  Copyright (c) 2014 Heba Gamal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "H7UIViewController.h"
#import <FacebookSDK/FacebookSDK.h>

@interface H7MeViewController : H7UIViewController

@property (weak, nonatomic) IBOutlet FBProfilePictureView *fbProfilePicture;

@end
