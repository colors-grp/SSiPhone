//
//  H7MosalslatQuizStart.m
//  TheColorsConcorenza
//
//  Created by Heba Gamal on 6/16/14.
//  Copyright (c) 2014 Heba Gamal. All rights reserved.
//

#import "H7MosalslatQuizStart.h"
#import "H7ConstantsModel.h"
#import "H7choicesCell.h"

#import "User.h"

#import <CoreData+MagicalRecord.h>
#import <AFNetworking/AFNetworking.h>

@interface H7MosalslatQuizStart ()

@end

@implementation H7MosalslatQuizStart {
    NSMutableArray *questions;
    NSMutableArray *c1;
    NSMutableArray *c2;
    NSMutableArray *c3;
    NSMutableArray *correct;
    NSMutableArray *userSelection;
    int curQuestion , size;
}

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

    // Set current question index
    curQuestion = 0;
    
    // Instantiate user array
    userSelection = [[NSMutableArray alloc] init];
    // Activity indicator to show info is getting fetched from web service
    [self.view setUserInteractionEnabled:NO];
    [self.activityIndicator setHidden:NO];
    [self.activityIndicator startAnimating];
    
    // Get Questions from web service
    [self getQuestionsForCard];
    
    // Get image for mosalsal
    [self getImage];
    
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    H7choicesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"choiceCell"];
    if(cell == nil) {
        cell = (H7choicesCell*)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"choiceCell"];
    }
    if(indexPath.row == 0) {
        cell.choiceLabel.text = [c1 objectAtIndex:curQuestion];
    }
    
    if(indexPath.row == 1) {
        cell.choiceLabel.text = [c2 objectAtIndex:curQuestion];
    }
    
    if(indexPath.row == 2) {
        cell.choiceLabel.text = [c3 objectAtIndex:curQuestion];
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.choices deselectRowAtIndexPath:indexPath animated:NO];
}


-(void)reload {
    if(curQuestion < size) {
        [self.choices reloadData];
        self.question.text = [questions objectAtIndex:curQuestion];
    }else if (curQuestion >= size) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Messege" message:@"Thank you for solving todays Mosalslat Quiz!!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        int score = [self calculateScore];
        NSArray *a = [User MR_findAll];
        User *u = [a firstObject];
        NSString *userId = u.userAccountId;
        NSString *catId = @"2";
        NSString *cardId = [NSString stringWithFormat:@"%@" , self.currentCard.cardId];
        NSString *Score = [NSString stringWithFormat:@"%d" , score];
        [self updateScoreInDBWithUserId:userId catId:catId cardId:cardId score:Score];
    }
}

-(int)calculateScore {
    int score = 0;
    for (int i = 0 ; i < size; i++) {
        if([[userSelection objectAtIndex:i] isEqualToString:[correct objectAtIndex:i]])
            score += 10;
        NSLog(@"%@ %@" , [userSelection objectAtIndex:i] , [correct objectAtIndex:i]);
        NSLog(@"%d" , score);
    }
    return  score;
}

- (void) updateScoreInDBWithUserId:(NSString*)userId catId:(NSString*)catId cardId:(NSString*)cardId score:(NSString*)score {
    NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@update_score_for_card/format/json/userId/%@/catId/%@/cardId/%@/score/%@", PLATFORM_URL , userId,catId,cardId,score]];
    NSLog(@"%@" , url);
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:url];
    AFJSONRequestOperation *request = [AFJSONRequestOperation JSONRequestOperationWithRequest:urlRequest success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"%@" , JSON);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        // Get from core data
        NSLog(@"Failed to update score in server");
    }];
    [request start];
}


- (IBAction)buttonClicked:(id)sender {
    NSIndexPath *path = [self.choices indexPathForSelectedRow];
    if(path) {
        curQuestion++;
        [userSelection addObject:[NSString stringWithFormat:@"%d" , path.row + 1]];
        [self reload];
    }else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Messege" message:@"You must answer the Question" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
}

-(void)getQuestionsForCard {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@mosalslat_card_question/format/json/categoryId/3/cardId/%@" , PLATFORM_URL , self.currentCard.cardId]];
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:url];
    AFJSONRequestOperation *request = [AFJSONRequestOperation JSONRequestOperationWithRequest:urlRequest success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        c1 = [[NSMutableArray alloc] init];
        c2 = [[NSMutableArray alloc] init];
        c3 = [[NSMutableArray alloc] init];
        questions = [[NSMutableArray alloc] init];
        correct = [[NSMutableArray alloc] init];
        NSDictionary *d = JSON;
        if([[d objectForKey:@"status"] isEqualToString:@"Request performed successfully"]) {
            size = [[d objectForKey:@"size"] intValue];
            for (int i = 0 ; i < [[d objectForKey:@"size"] intValue]; i++) {
                NSDictionary *value = [d objectForKey:[NSString stringWithFormat:@"%d" , i]];
                NSString *correctQuestion = [NSString stringWithCString:[[value objectForKey:@"question"] cStringUsingEncoding:NSUTF8StringEncoding] encoding:NSUTF8StringEncoding];
                NSString *correctC1 = [NSString stringWithCString:[[value objectForKey:@"choice1"] cStringUsingEncoding:NSUTF8StringEncoding] encoding:NSUTF8StringEncoding];
                NSString *correctC2 = [NSString stringWithCString:[[value objectForKey:@"choice2"] cStringUsingEncoding:NSUTF8StringEncoding] encoding:NSUTF8StringEncoding];
                NSString *correctC3 = [NSString stringWithCString:[[value objectForKey:@"choice3"] cStringUsingEncoding:NSUTF8StringEncoding] encoding:NSUTF8StringEncoding];
                NSString *correctAns = [NSString stringWithCString:[[value objectForKey:@"correct_choice"] cStringUsingEncoding:NSUTF8StringEncoding] encoding:NSUTF8StringEncoding];
                [questions addObject:correctQuestion];
                [c1 addObject:correctC1];
                [c2 addObject:correctC2];
                [c3 addObject:correctC3];
                [correct addObject:correctAns];
                [self reload];
            }
        }
        NSMutableDictionary *binary = [[NSMutableDictionary alloc] init];
        [binary setObject:questions forKey:@"questions"];
        [binary setObject:c1 forKey:@"choice1"];
        [binary setObject:c2 forKey:@"choice2"];
        [binary setObject:c3 forKey:@"choice3"];
        [binary setObject:correct forKey:correct];
        [binary setObject:[NSNumber numberWithInt:size] forKey:@"sz"];
        self.currentCard.mosalslatQuestions = [NSKeyedArchiver archivedDataWithRootObject:binary];
        
        // Save in core data
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
        
        // Stopping activity indicator
        [self.view setUserInteractionEnabled:YES];
        [self.activityIndicator setHidden:YES];
        [self.activityIndicator stopAnimating];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        // Get from core data
        NSLog(@"Couldn't get Questions");
        NSData *data = self.currentCard.mosalslatQuestions;
        NSDictionary *dect = (NSDictionary *) [NSKeyedUnarchiver unarchiveObjectWithData:data];
        c1 = [[NSMutableArray alloc] init];
        c2 = [[NSMutableArray alloc] init];
        c3 = [[NSMutableArray alloc] init];
        questions = [[NSMutableArray alloc] init];
        correct = [[NSMutableArray alloc] init];

        questions = [dect objectForKey:@"questions"];
        c1 =[dect objectForKey:@"choice1"];
        c2 =[dect objectForKey:@"choice2"];
        c3 =[dect objectForKey:@"choice3"];
        correct = [dect objectForKey:@"correct"];
        NSNumber *tmp =[dect objectForKey:@"sz"];
        size =tmp.intValue;
        
        // Stopping activity indicator
        [self.view setUserInteractionEnabled:YES];
        [self.activityIndicator setHidden:YES];
        [self.activityIndicator stopAnimating];
        
        [self reload];
    }];
    [request start];

}

-(void) getImage{
    NSData *imgData = self.currentCard.imageBinary;
    UIImage *thumbNail = [UIImage imageWithData:imgData scale:1.0f];
    [self.mosalsalImage setImage:thumbNail];
    
}
@end
