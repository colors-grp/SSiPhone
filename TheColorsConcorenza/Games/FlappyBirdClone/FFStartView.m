//
//  FFStartView.m
//  TheColorsConcorenza
//
//  Created by Heba Gamal on 6/27/14.
//  Copyright (c) 2014 Heba Gamal. All rights reserved.
//

#import "ViewController.h"
#import "FFStartView.h"

@interface FFStartView ()

@end

@implementation FFStartView


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
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonClicked:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ViewController *myController = [storyboard instantiateViewControllerWithIdentifier:@"flappyFanoos"];
    [self.navigationController pushViewController: myController animated:YES];

}


@end
