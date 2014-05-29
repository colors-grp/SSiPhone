//
//  H7CollectionCardInfoView.m
//  TheColorsConcorenza
//
//  Created by Heba Gamal on 4/7/14.
//  Copyright (c) 2014 Heba Gamal. All rights reserved.
//

#import "H7CollectionCardInfoView.h"
#import "MyCard.h"
#import "MyCategory.h"

@interface H7CollectionCardInfoView ()

@end

@implementation H7CollectionCardInfoView

- (void)viewDidLoad
{
    /* Setting background image */
    UIImage *background = [UIImage imageNamed: @"bg_all_4.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage: background];
    [self.view insertSubview: imageView atIndex:0];
    
    /* Setting navigation bar title */
    self.navigationItem.title = [self.currentCard valueForKey:@"cardName"];
    
    /* Setting card Info */
    MyCategory *currentCategory = [self.currentCard belongsTo];
    NSString *path = [NSString stringWithFormat:@"categories/%@/cards/%@/ui/grid_view.png" , [currentCategory valueForKey:@"categoryName"] , [self.currentCard valueForKey:@"cardId"]];
    self.cardImage.image = [UIImage imageNamed:path];
    self.cardNameLabel.text = [self.currentCard valueForKey:@"cardName"];
    self.imagesCountLabel.text = [NSString stringWithFormat:@"%d",[[[self.currentCard hasImages]allObjects] count]];
    
    //Setting media info
    self.mediaTypeImage.image = [UIImage imageNamed:@"media_icons/cards_photo.png"];
    self.mediaTypeLabel.text = @"Images";
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)segmentControllValueChanged:(id)sender {
    if([self.segmentControll selectedSegmentIndex] == 0){
        self.mediaTypeImage.image = [UIImage imageNamed:@"media_icons/cards_photo.png"];
        self.mediaTypeLabel.text = @"Images";
    }else if([self.segmentControll selectedSegmentIndex] == 1) {
        self.mediaTypeImage.image = [UIImage imageNamed:@"media_icons/cards_music.png"];
        self.mediaTypeLabel.text = @"Music";
    }else if([self.segmentControll selectedSegmentIndex] == 2) {
        self.mediaTypeImage.image = [UIImage imageNamed:@"media_icons/cards_video.png"];
        self.mediaTypeLabel.text = @"Videos";
    }else if([self.segmentControll selectedSegmentIndex] == 3) {
        self.mediaTypeImage.image = [UIImage imageNamed:@"media_icons/cards_game.png"];
        self.mediaTypeLabel.text = @"Games";
    }
}

@end
