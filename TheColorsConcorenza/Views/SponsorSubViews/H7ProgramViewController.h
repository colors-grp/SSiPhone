//
//  H7ProgramViewController.h
//  TheColorsConcorenza
//
//  Created by Heba Gamal on 5/19/14.
//  Copyright (c) 2014 Heba Gamal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SponsorPrograms.h"

@interface H7ProgramViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *programImage;
@property (strong) SponsorPrograms *currentProgram;
@property (weak, nonatomic) IBOutlet UITextView *programInfoTextView;


@end
