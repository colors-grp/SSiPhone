//
//  H7ScoreboardViewController.m
//  TheColorsConcorenza
//
//  Created by Heba Gamal on 3/26/14.
//  Copyright (c) 2014 Heba Gamal. All rights reserved.
//

#import "H7ScoreboardViewController.h"
#import "MyCategory.h"
#import "H7ScoreboardCell.h"
#import "H7ConstantsModel.h"
#import "H7AppDelegate.h"

#import <CoreData+MagicalRecord.h>
#import <AFNetworking.h>
#import <FacebookSDK/FacebookSDK.h>

@interface H7ScoreboardViewController ()

@end

@implementation H7ScoreboardViewController {
    MyCategory *myCat;
    NSMutableArray *myCategories;
    int selectedSegment;
    NSString *curCategoryId;
    NSString *curCategoryName;
    
    NSMutableArray *names;
    NSMutableArray *facebookIds;
    NSMutableArray *scores;
    NSMutableArray *ranks;
    
    Boolean isConnected;
}

- (void)viewDidLoad
{
    /* Setting background image */
    UIImage *background = [UIImage imageNamed: @"bg_all_4.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage: background];
    [self.view insertSubview: imageView atIndex:0];
    
    // Set segment contorol color to red
    self.segmentControl.tintColor =[UIColor colorWithRed:(212/255.0) green:(39/255.0) blue:(51/255.0) alpha:1];
    
    // Set activity indicator to hidden
    [self.view setUserInteractionEnabled:NO];
    [self.activityIndicator setHidden:NO];
    [self.activityIndicator startAnimating];
    
    names = [[NSMutableArray alloc] init];
    facebookIds = [[NSMutableArray alloc] init];
    ranks = [[NSMutableArray alloc] init];
    scores = [[NSMutableArray alloc] init];
    
    // Get my favourite categories
    myCategories = [[MyCategory MR_findAllSortedBy:@"categoryId" ascending:YES] mutableCopy];
    
    // Set default selected segment
    selectedSegment = 0;
    
    // Set current selected category
    myCat = [myCategories objectAtIndex:0];
    curCategoryId = [NSString stringWithFormat:@"%@" , myCat.categoryId];
    curCategoryName = myCat.categoryName;
    
    // temp set data
    [self getScoreBoardAllWithChange:NO];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)segmentControllValueChanged:(id)sender {
    if([self.segmentControl selectedSegmentIndex] == 0) {
        // Set activity indicator to hidden
        [self.view setUserInteractionEnabled:NO];
        [self.activityIndicator setHidden:NO];
        [self.activityIndicator startAnimating];

        selectedSegment = 0;
        [self getScoreBoardAllWithChange:YES];
    }
    else if([self.segmentControl selectedSegmentIndex] == 1) {
        // Set activity indicator to hidden
        [self.view setUserInteractionEnabled:NO];
        [self.activityIndicator setHidden:NO];
        [self.activityIndicator startAnimating];

        selectedSegment = 1;
        [self getScoreboardFriendsWithChange:YES];
    }
}

// Collection view data source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [myCategories count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"categoryCell" forIndexPath:indexPath];
    UIImageView *image = (UIImageView*)[cell viewWithTag:17];
    myCat = [myCategories objectAtIndex:indexPath.row];
    image.image = [UIImage imageNamed:[NSString stringWithFormat:@"CategoriesIcons/%@.png" , [myCat valueForKey:@"categoryId"]]];
    if([curCategoryId isEqualToString:[NSString stringWithFormat:@"%ld" , indexPath.row +1]]) {
        image.image = [UIImage imageNamed:[NSString stringWithFormat:@"CategoriesIcons/%@_selected.png" , [myCat valueForKey:@"categoryId"]]];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    myCat = [myCategories objectAtIndex:indexPath.row];
    curCategoryId = [NSString stringWithFormat:@"%@" , myCat.categoryId];
    curCategoryName = myCat.categoryName;
    
    // Handle activity indicator actions
    [self.view setUserInteractionEnabled:NO];
    [self.activityIndicator setHidden:NO];
    [self.activityIndicator startAnimating];
    
    if(selectedSegment == 0)
        [self getScoreBoardAllWithChange:YES];
    if(selectedSegment == 1)
        [self getScoreboardFriendsWithChange:YES];
    // Reload collection view of categories to highlight the selected category
    [self.categoriesCollection reloadData];
}

// Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [names count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    H7ScoreboardCell *cell = [tableView dequeueReusableCellWithIdentifier:@"scoreboardCell"];
    if(cell == nil) {
        cell = (H7ScoreboardCell*)[[H7ScoreboardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"scoreboardCell"];
    }
    cell.nameLabel.text = [names objectAtIndex:indexPath.row];
    cell.scoreLabel.text = [scores objectAtIndex:indexPath.row];
    cell.rankLabel.text = [NSString stringWithFormat:@"%@" , [ranks objectAtIndex:indexPath.row]];
    if(isConnected == YES)
        cell.profileImage.profileID = [facebookIds objectAtIndex:indexPath.row];
    else
        cell.profileImage.profileID = nil;
    
    return cell;
}


//to load more friends use willDisplayCell
- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(selectedSegment == 0 && (indexPath.row + 1)% 10 == 7 && [names count] - indexPath.row < 10) {
        // Handle activity indicator actions
        [self.view setUserInteractionEnabled:NO];
        [self.activityIndicator setHidden:NO];
        [self.activityIndicator startAnimating];
        
        [self getScoreBoardAllWithChange:NO];
    }
    else if (selectedSegment == 1 && (indexPath.row + 1)% 10 == 7 && [names count] - indexPath.row < 10) {
        // Handle activity indicator actions
        [self.view setUserInteractionEnabled:NO];
        [self.activityIndicator setHidden:NO];
        [self.activityIndicator startAnimating];
        
        [self getScoreboardFriendsWithChange:NO];
    }
}

// Get Scoreboard from web service
-(void)getScoreBoardAllWithChange:(Boolean)changed{
    if(changed == YES) {
        names = [[NSMutableArray alloc] init];
        facebookIds = [[NSMutableArray alloc] init];
        ranks = [[NSMutableArray alloc] init];
        scores = [[NSMutableArray alloc] init];
    }
    int start = [names count];
    NSURL *url = [[NSURL alloc] initWithString:[ NSString stringWithFormat:@"%@all_scoreboard/format/json/categoryId/%@/categoryName/%@/start/%d/size/10", PLATFORM_URL , curCategoryId , curCategoryName , start]];
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:url];
    NSLog(@"%@" , url);
    AFJSONRequestOperation *request = [AFJSONRequestOperation JSONRequestOperationWithRequest:urlRequest success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSDictionary *tmp = JSON;
        int size = [[tmp objectForKey:@"size"] intValue];
        for(int i = 0 ; i < size ; i++) {
            NSDictionary *dect = [tmp objectForKey:[NSString stringWithFormat:@"%d" , i]];
            [names addObject:[dect objectForKey:@"name"]];
            [facebookIds addObject:[dect objectForKey:@"fbid"]];
            [ranks addObject:[dect objectForKey:@"rank"]];
            [scores addObject:[dect objectForKey:@"score"]];
        }
        [self.scoreBoardTable reloadData];
        if(changed == YES) {
            NSIndexPath* ipath = [NSIndexPath indexPathForRow:0 inSection: 0];
            [self.scoreBoardTable scrollToRowAtIndexPath: ipath atScrollPosition: UITableViewScrollPositionTop animated: NO];
            myCat.binaryData = [NSKeyedArchiver archivedDataWithRootObject:tmp];
            
            // Save in core data
            [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
        }
        isConnected = YES;
        
        // Handle activity indicator actions
        [self.view setUserInteractionEnabled:YES];
        [self.activityIndicator stopAnimating];
        [self.activityIndicator setHidden:YES];

        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Failed to get scoreboard all !!!");
        names = [[NSMutableArray alloc] init];
        facebookIds = [[NSMutableArray alloc] init];
        ranks = [[NSMutableArray alloc] init];
        scores = [[NSMutableArray alloc] init];
        
        NSData *data = myCat.binaryData;
        NSDictionary *dect = (NSDictionary *) [NSKeyedUnarchiver unarchiveObjectWithData:data];

        int size = [[dect objectForKey:@"size"] intValue];
        
        for(int i = 0 ; i < size ; i++) {
            NSDictionary *info = [dect objectForKey:[NSString stringWithFormat:@"%d" , i]];
            [names addObject:[info objectForKey:@"name"]];
            [facebookIds addObject:[info objectForKey:@"fbid"]];
            [ranks addObject:[info objectForKey:@"rank"]];
            [scores addObject:[info objectForKey:@"score"]];
        }
        [self.scoreBoardTable reloadData];
        isConnected = NO;
        
        // Handle activity indicator actions
        [self.view setUserInteractionEnabled:YES];
        [self.activityIndicator stopAnimating];
        [self.activityIndicator setHidden:YES];

    }];
    [request start];
}

-(void)getScoreboardFriendsWithChange:(Boolean)changed {
    if (changed == YES) {
        names = [[NSMutableArray alloc] init];
        facebookIds = [[NSMutableArray alloc] init];
        ranks = [[NSMutableArray alloc] init];
        scores = [[NSMutableArray alloc] init];
    }
    int start = [names count] ;
    H7AppDelegate *appDel = [[UIApplication sharedApplication] delegate];
    NSURL *url = [[NSURL alloc] initWithString:[ NSString stringWithFormat:@"%@friends_scoreboard/format/json/facebookId/%@/categoryId/%@/categoryName/%@/start/%d/size/10" ,PLATFORM_URL, appDel.userFbId , curCategoryId , curCategoryName , start]];
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:url];
    NSLog(@"%@" , url);
    AFJSONRequestOperation *request = [AFJSONRequestOperation JSONRequestOperationWithRequest:urlRequest success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSDictionary *tmp = JSON;
        NSLog(@"%@" , tmp);
        int size = [[tmp objectForKey:@"size"] intValue];
        for(int i = 0 ; i < size ; i++) {
            NSDictionary *dect = [tmp objectForKey:[NSString stringWithFormat:@"%d" , i]];
            [names addObject:[dect objectForKey:@"name"]];
            [facebookIds addObject:[dect objectForKey:@"fbid"]];
            [ranks addObject:[dect objectForKey:@"rank"]];
            [scores addObject:[dect objectForKey:@"score"]];
        }
        [self.scoreBoardTable reloadData];
        if(changed == YES) {
            NSIndexPath* ipath = [NSIndexPath indexPathForRow:0 inSection: 0];
            [self.scoreBoardTable scrollToRowAtIndexPath: ipath atScrollPosition: UITableViewScrollPositionTop animated: YES];
            myCat.binaryData = [NSKeyedArchiver archivedDataWithRootObject:tmp];
            
            // Save in core data
            [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
        }
        isConnected = YES;
        
        // Handle activity indicator actions
        [self.view setUserInteractionEnabled:YES];
        [self.activityIndicator stopAnimating];
        [self.activityIndicator setHidden:YES];

    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Failed to get scoreboard all !!!");
        names = [[NSMutableArray alloc] init];
        facebookIds = [[NSMutableArray alloc] init];
        ranks = [[NSMutableArray alloc] init];
        scores = [[NSMutableArray alloc] init];
        
        NSData *data = myCat.binaryData;
        NSDictionary *dect = (NSDictionary *) [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
        int size = [[dect objectForKey:@"size"] intValue];
        
        for(int i = 0 ; i < size ; i++) {
            NSDictionary *info = [dect objectForKey:[NSString stringWithFormat:@"%d" , i]];
            [names addObject:[info objectForKey:@"name"]];
            [facebookIds addObject:[info objectForKey:@"fbid"]];
            [ranks addObject:[info objectForKey:@"rank"]];
            [scores addObject:[info objectForKey:@"score"]];
        }
        [self.scoreBoardTable reloadData];
        isConnected = NO;
        
        // Handle activity indicator actions
        [self.view setUserInteractionEnabled:YES];
        [self.activityIndicator stopAnimating];
        [self.activityIndicator setHidden:YES];

    }];
    [request start];
}

@end
