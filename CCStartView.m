//
//  CCStartView.m
//  TheColorsConcorenza
//
//  Created by Heba Gamal on 6/27/14.
//  Copyright (c) 2014 Heba Gamal. All rights reserved.
//

#import "CCStartView.h"
#import "ViewController.h"

@interface CCStartView ()

@end

@implementation CCStartView


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
    UIBarButtonItem *startButton = [[UIBarButtonItem alloc]
                                    initWithTitle:@"العب"
                                    style:UIBarButtonItemStyleBordered
                                    target:self
                                    action:@selector(playGameButtonTapped:)];
    self.navigationItem.rightBarButtonItem = startButton;

    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)playGameButtonTapped:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ViewController *myController = [storyboard instantiateViewControllerWithIdentifier:@"fanoosCrunch"];
    [self.navigationController pushViewController: myController animated:YES];
}


@end
