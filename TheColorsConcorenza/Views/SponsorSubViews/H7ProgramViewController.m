//
//  H7ProgramViewController.m
//  TheColorsConcorenza
//
//  Created by Heba Gamal on 5/19/14.
//  Copyright (c) 2014 Heba Gamal. All rights reserved.
//

#import "H7ProgramViewController.h"

@interface H7ProgramViewController ()

@end

@implementation H7ProgramViewController

- (void)viewDidLoad
{
    /* Setting background image */
    UIImage *background = [UIImage imageNamed: @"bg_all_4.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage: background];
    [self.view insertSubview: imageView atIndex:0];
    
    self.programImage.image = [UIImage imageNamed:[self.currentProgram imageName]];
    NSString *str = [NSString stringWithFormat:@"%@\n\n%@" , [self.currentProgram staring] , [self.currentProgram describtion]];
    self.programInfoTextView.text = str;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
