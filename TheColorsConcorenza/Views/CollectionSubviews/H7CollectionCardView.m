//
//  H7CollectionCardView.m
//  TheColorsConcorenza
//
//  Created by Heba Gamal on 4/6/14.
//  Copyright (c) 2014 Heba Gamal. All rights reserved.
//

#import "H7CollectionCardView.h"
#import "MyCard.h"
#import "H7CollectionCardInfoView.h"

@interface H7CollectionCardView () {
    NSMutableArray *favouriteCards;
}
@end

@implementation H7CollectionCardView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    /* Setting background image */
    UIImage *background = [UIImage imageNamed: @"bg_all_4.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage: background];
    [self.view insertSubview: imageView atIndex:0];
    
    /* Set collection view selection to only one card */
    self.cardsCollection.allowsMultipleSelection = NO;
    
    /*  Setting navigation car title */
    self.navigationItem.title = [NSString stringWithFormat:@"%@ Cards" , [self.currentCategory valueForKey:@"categoryName"]];
    
    [self getFavouriteCards];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
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
    return  [favouriteCards count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionCardCell" forIndexPath:indexPath];
    UIImageView *image = (UIImageView*)[cell viewWithTag:9];
    NSString *imagePath = [NSString stringWithFormat:@"categories/%@/cards/%@/ui/grid_view.png" ,[self.currentCategory valueForKey:@"categoryName"], [[favouriteCards objectAtIndex:indexPath.row] valueForKey:@"cardId"]];
    UILabel *nameLabel = (UILabel*) [cell viewWithTag:10];
    image.image = [UIImage imageNamed:imagePath];
    nameLabel.text =[[favouriteCards objectAtIndex:indexPath.row] valueForKey:@"cardName"];
    return  cell;
}



-(void)getFavouriteCards {
    NSArray *tmp = [[self.currentCategory hasCards] allObjects];
    NSLog(@"%d" , [tmp count]);
    favouriteCards = [[NSMutableArray alloc] init];
    for (int i = 0; i < [tmp count]; i++) {
        MyCard *card = [tmp objectAtIndex:i];
//        if ([[card valueForKey:@"isBought"] isEqualToNumber:[NSNumber numberWithBool:YES]]) {
//            [favouriteCards addObject:card];
//        }
        [favouriteCards addObject:card];
    }
//    NSLog(@"%d" , [favouriteCards count]);
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"collectionShowCardInfo"]) {
        H7CollectionCardInfoView *view = [segue destinationViewController];
        NSIndexPath *indexPath = [[self.cardsCollection indexPathsForSelectedItems] objectAtIndex:0];
        view.currentCard = [favouriteCards objectAtIndex:indexPath.row];
    }
}

@end

