//
//  H7ShahryarFindTheBottle.m
//  TheColorsConcorenza
//
//  Created by Heba Gamal on 6/15/14.
//  Copyright (c) 2014 Heba Gamal. All rights reserved.
//

#import "H7ShahryarFindTheBottle.h"

@interface H7ShahryarFindTheBottle ()

@end

@implementation H7ShahryarFindTheBottle{
    UITapGestureRecognizer *singleTap;
    NSTimer *aTimer;
    int currentScore;
}

- (void)viewDidLoad
{
    singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(screenTapped:)];
    [singleTap setNumberOfTapsRequired:1];
    [singleTap setDelegate:self];
    [self.view addGestureRecognizer:singleTap];
    
    aTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(elapsedTime) userInfo:nil repeats:YES];
    self.timeLabel.transform =  CGAffineTransformMakeRotation(-90 * M_PI / 180.0);
    self.scoreLabel.transform =  CGAffineTransformMakeRotation(-90 * M_PI / 180.0);


    
    self.findTheBottleImage.image = [UIImage imageNamed:@"game1.png"];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)screenTapped:(id)sender {
    CGPoint tapPoint = [sender locationInView:self.view];
    NSLog(@"%f, %f",tapPoint.x,tapPoint.y);
    
    if(true) { // badalo put if in correct zone
        NSArray *animationArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"bottle.png"],[UIImage imageNamed:@"bottle_glow.png"], nil];
        [NSTimer scheduledTimerWithTimeInterval:.50 target:self selector:@selector(myAnimate:) userInfo:nil repeats:NO];
        self.bottleImage.animationImages = animationArray;
        self.bottleImage.animationDuration = 0.3;
        self.bottleImage.animationRepeatCount = 0;
        [self.bottleImage startAnimating];
        CABasicAnimation *crossFade = [CABasicAnimation animationWithKeyPath:@"contents"];
        crossFade.autoreverses = YES;
        crossFade.repeatCount = 0;
        crossFade.duration = .5;
    }
    NSLog(@"%d" , currentScore);
}

- (void) myAnimate :(NSTimer *)timer{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut]; // user dependent transition acn be set here
    self.bottleImage.alpha = !self.bottleImage.alpha;
    [UIView commitAnimations];
}

-(void)elapsedTime{
    static int i = 10;
    static int score = 100;
    currentScore = score;
    self.timeLabel.text = [NSString stringWithFormat:@"%d",i];
    self.scoreLabel.text = [NSString stringWithFormat:@"%d" , (score < 10 ? 10 : score)];
    i--;
    score -= 10;
    if(i<0)
    {
        [aTimer invalidate];
        aTimer = nil;
    }
}


@end
