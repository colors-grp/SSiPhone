//
//  H7ManElQatelAudio.m
//  TheColorsConcorenza
//
//  Created by Heba Gamal on 5/27/14.
//  Copyright (c) 2014 Heba Gamal. All rights reserved.
//

#import "H7ManElQatelAudio.h"
#import <AVFoundation/AVFoundation.h>


@interface H7ManElQatelAudio (){
    AVAudioPlayer *audioPlayer;
    AVAudioSession *audioSession;
}


@end

@implementation H7ManElQatelAudio

- (void)viewDidLoad
{
    /* Setting background image */
    UIImage *background = [UIImage imageNamed: @"bg_all_4.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage: background];
    [self.view insertSubview: imageView atIndex:0];
    
    // Play Audio file
    audioSession = [AVAudioSession sharedInstance];
    NSError *error;
    // This will send the audio to the speaker. If you just want the audio to go to the headset, change the Category to AVAudioSessionCategoryPlayAndRecord
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:&error];
	[audioSession setActive:YES error:&error];
    NSString *dir = [NSString stringWithFormat:@"Categories/manElQatel/cards/%d" , self.cardId];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"audio" ofType:@"mp3" inDirectory:dir];
    NSLog(@"dir = %@ && path = %@" , dir , path);
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:NULL];
    [audioPlayer prepareToPlay];

    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (IBAction)playAudio:(UIButton *)button {
    if ([button.titleLabel.text isEqualToString:@"Play"]) {
        [button setTitle:@"Stop" forState:UIControlStateNormal];
        [audioPlayer play];
    } else {
        [button setTitle:@"Play" forState:UIControlStateNormal];
        [audioPlayer stop];
        
        // This will reset the audio back to the beginning. Not doing this will just pause the audio.
        audioPlayer.currentTime = 0;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
