
//
//  H7ShahryarStory.m
//  TheColorsConcorenza
//
//  Created by Heba Gamal on 5/27/14.
//  Copyright (c) 2014 Heba Gamal. All rights reserved.
//

#import "H7ShahryarStory.h"

@interface H7ShahryarStory ()

@end

@implementation H7ShahryarStory {
    int curPanel , maxPanel;
}

- (void)viewDidLoad
{
    /* Setting background image */
    UIImage *background = [UIImage imageNamed: @"bg_all_4.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage: background];
    [self.view insertSubview: imageView atIndex:0];
    
    // Set current panel and maximum number of panels
    curPanel = 1;
    maxPanel = 5;
    
    UISwipeGestureRecognizer * swipeleft=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeleft:)];
    swipeleft.direction=UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeleft];
    
    UISwipeGestureRecognizer * swiperight=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swiperight:)];
    swiperight.direction=UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swiperight];
    
    // Set first page
    self.storyPanel.image = [UIImage imageNamed:[NSString stringWithFormat:@"Categories/shahryar/cards/%d/%d.png" , self.cardId , curPanel]];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)swipeleft:(UISwipeGestureRecognizer*)gestureRecognizer
{
    if(curPanel < maxPanel) {
        curPanel++;
        self.storyPanel.image = [UIImage imageNamed:[NSString stringWithFormat:@"Categories/shahryar/cards/%d/%d.png" , self.cardId , curPanel]];
    }
}

-(void)swiperight:(UISwipeGestureRecognizer*)gestureRecognizer
{
    if(curPanel > 1) {
        curPanel--;
        self.storyPanel.image = [UIImage imageNamed:[NSString stringWithFormat:@"Categories/shahryar/cards/%d/%d.png" , self.cardId , curPanel]];
    }
}

@end
