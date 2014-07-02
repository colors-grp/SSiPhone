//
//  H7MosalslatScore.m
//  TheColorsConcorenza
//
//  Created by Heba Gamal on 7/2/14.
//  Copyright (c) 2014 Heba Gamal. All rights reserved.
//

#import "H7MosalslatScore.h"

@interface H7MosalslatScore ()

@end

@implementation H7MosalslatScore

- (void)viewDidLoad
{
    [super viewDidLoad];
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
    self.scoreLabel.text = [NSString stringWithFormat:@"%d",self.score];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
