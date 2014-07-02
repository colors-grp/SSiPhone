//
//  H7MosalslatQuiz.m
//  TheColorsConcorenza
//
//  Created by Heba Gamal on 5/27/14.
//  Copyright (c) 2014 Heba Gamal. All rights reserved.
//

#import "H7MosalslatScore.h"
#import "H7MosalslatQuiz.h"
#import "H7MosalslatQuizStart.h"

@interface H7MosalslatQuiz ()

@end

@implementation H7MosalslatQuiz

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
    
    // Set the image of the mosalsal
    [self getImage];

    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)buttonClicked:(id)sender {
    
    if([self.currentCard.areMosalslatQuestionsDownloaded isEqualToNumber:[NSNumber numberWithBool:NO]]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        H7MosalslatQuizStart *myController = [storyboard instantiateViewControllerWithIdentifier:@"goToQuiz"];
        myController.currentCard = self.currentCard;
        [self.navigationController pushViewController:myController animated:YES];
    }else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"OPSSS!!" message:[NSString stringWithFormat:@"Your already played this game and scored %@ points" , self.currentCard.cardScore] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
    }

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier]isEqualToString:@"startMosalslatQuiz"]) {
            }
}

-(void) getImage{
    NSData *imgData = self.currentCard.imageBinary;
    UIImage *thumbNail = [UIImage imageWithData:imgData scale:1.0f];
    [self.mosalsalImage setImage:thumbNail];

}

@end
