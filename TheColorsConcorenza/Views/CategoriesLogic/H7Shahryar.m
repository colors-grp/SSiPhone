//
//  H7Shahryar.m
//  TheColorsConcorenza
//
//  Created by Heba Gamal on 5/26/14.
//  Copyright (c) 2014 Heba Gamal. All rights reserved.
//

#import "H7Shahryar.h"
#import "H7ShahryarStory.h"
#import "H7AppDelegate.h"

#import "H7ConstantsModel.h"

#import <AFNetworking/AFNetworking.h>

@interface H7Shahryar ()

@end

@implementation H7Shahryar {
    NSArray * cards;
    NSDictionary *cardStatus;
}

- (void)viewDidLoad
{
    /* Setting background image */
    UIImage *background = [UIImage imageNamed: @"bg_all_4.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage: background];
    [self.view insertSubview: imageView atIndex:0];
    
    // Get cards status
    [self getOpenedCards];
    
    [super viewDidLoad];
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/* Collection Data source */

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSLog(@"%@" , self.currentCategory.categoryName);

    return [self.currentCategory.hasCards count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"shahryarCardCell" forIndexPath:indexPath];
    UIImageView *image = (UIImageView*)[cell viewWithTag:200];
    bool inLoop =false;
    NSString *imagePath;
    for (int i=0 ; i < [cardStatus count]; i++) {
        if([cardStatus objectForKey:[NSString stringWithFormat:@"%d" , indexPath.row+1]]!= nil && [[cardStatus objectForKey:[NSString stringWithFormat:@"%d" , indexPath.row+1]] isEqualToString:@"1"]) {
           imagePath = [NSString stringWithFormat:@"Categories/shahryar/cards/%d/img.png" , indexPath.row + 1];
            inLoop = true;
        }
    }
    if(!inLoop)
        imagePath = [NSString stringWithFormat:@"Playbutton.png"];
    
    image.image = [UIImage imageNamed:imagePath];
    return  cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    H7ShahryarStory *story = [segue destinationViewController];
    NSArray *indexPaths = [self.cardsCollection indexPathsForSelectedItems];
    NSIndexPath *index = [indexPaths objectAtIndex:0];
    story.cardId = index.row + 1;
}

-(void)getOpenedCards {
    NSURL *url = [[NSURL alloc] initWithString:[ NSString stringWithFormat:@"%@cards_status/format/json/categoryId/%@", PLATFORM_URL ,self.currentCategory.categoryId]];
    NSLog(@"%@" , url);
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:url];
    AFJSONRequestOperation *request = [AFJSONRequestOperation JSONRequestOperationWithRequest:urlRequest success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        cardStatus = JSON;
        [self.cardsCollection reloadData];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {

        NSLog(@"Failed to get scores");
    }];
    [request start];
}


@end
