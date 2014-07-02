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
#import "ViewController.h"
#import "H7MosalslatScore.h"
#import <CoreData+MagicalRecord.h>
#import <AFNetworking/AFNetworking.h>

@interface H7MosalslatQuizStart ()
@end

@implementation H7MosalslatQuizStart {
    NSMutableArray *questions;
    NSMutableArray *c1;
    NSMutableArray *c2;
    NSMutableArray *c3;
    NSMutableArray *c4;
    NSMutableArray *correct;
    NSMutableArray *userSelection;
    int curQuestion , size , userScore;
    NSDate *currentDate;
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
    [self.activityIndicator setHidden:YES];

    // Set current question index & user score to 0
    curQuestion = 0;
    
    
    // Instantiate user array
    userSelection = [[NSMutableArray alloc] init];
    
    if([[self.currentCard areMosalslatQuestionsDownloaded] isEqualToNumber:[NSNumber numberWithBool:NO]]) {
        // Activity indicator to show info is getting fetched from web service
        [self.view setUserInteractionEnabled:NO];
        [self.activityIndicator setHidden:NO];
        [self.activityIndicator startAnimating];
        
        // Get Questions from web service
        [self getQuestionsForCard];
    }else {
        [self setDataForQuestions];
    }
    
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
    return 4;
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
    
    if(indexPath.row == 3) {
        cell.choiceLabel.text = [c4 objectAtIndex:curQuestion];
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.choices deselectRowAtIndexPath:indexPath animated:NO];
}


-(void)reload {
    if(curQuestion < size) {
        double delayInSeconds = 1.0;
        UITableViewCell *cell = [self.choices cellForRowAtIndexPath:[self.choices indexPathForSelectedRow]];
        int tmp = curQuestion;
        if (tmp) {
            curQuestion--;
            if([[userSelection objectAtIndex:curQuestion] isEqualToString:[correct objectAtIndex:curQuestion]])
                cell.backgroundColor = [UIColor greenColor];
            else
                cell.backgroundColor = [UIColor redColor];
            [self.choices reloadData];
        }
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            //code to be executed on the main queue after delay
            if(tmp)
                curQuestion++;
            cell.backgroundColor = [UIColor clearColor];
            [self.choices reloadData];
            self.question.text = [questions objectAtIndex:curQuestion];
            currentDate = [[NSDate alloc] init];
        });
    }else if (curQuestion >= size) {
        double delayInSeconds = 1.0;
        UITableViewCell *cell = [self.choices cellForRowAtIndexPath:[self.choices indexPathForSelectedRow]];
        int tmp = curQuestion;
        if (tmp) {
            curQuestion--;
            if([[userSelection objectAtIndex:curQuestion] isEqualToString:[correct objectAtIndex:curQuestion]])
                cell.backgroundColor = [UIColor greenColor];
            else
                cell.backgroundColor = [UIColor redColor];
            [self.choices reloadData];
        }
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){

            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Messege" message:@"Thank you for solving todays Mosalslat Quiz!!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
            NSArray *a = [User MR_findAll];
            User *u = [a firstObject];
            NSString *userId = u.userAccountId;
            NSString *catId = @"2";
            NSString *cardId = [NSString stringWithFormat:@"%@" , self.currentCard.cardId];
            NSString *Score = [NSString stringWithFormat:@"%d" , userScore];
            [self updateScoreInDBWithUserId:userId catId:catId cardId:cardId score:Score];
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            H7MosalslatScore *myController = [storyboard instantiateViewControllerWithIdentifier:@"mossalslatScore"];
            myController.score = userScore;
            [self.navigationController pushViewController: myController animated:YES];
            
        });
    }
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
        [userSelection addObject:[NSString stringWithFormat:@"%d" , path.row]];
        NSDate *timeNow = [[NSDate alloc] init];
        int timeTaken = [timeNow timeIntervalSinceDate:currentDate];
        if([[userSelection objectAtIndex:curQuestion] isEqualToString:[correct objectAtIndex:curQuestion]])
        {
            userScore += ( (50 - (5*timeTaken)) > 10 ?(50 - (5*timeTaken))  : 10);
        }
        NSLog(@"%d %d" ,timeTaken , (50 - (5*timeTaken)));
        curQuestion++;
        [self reload];
    }else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Messege" message:@"You must answer the Question" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
}

-(void)getQuestionsForCard {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@mosalslat_card_question/format/json/categoryId/2/cardId/%@" , PLATFORM_URL , self.currentCard.cardId]];
    NSLog(@"%@" , url);
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:url];
    AFJSONRequestOperation *request = [AFJSONRequestOperation JSONRequestOperationWithRequest:urlRequest success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        c1 = [[NSMutableArray alloc] init];
        c2 = [[NSMutableArray alloc] init];
        c3 = [[NSMutableArray alloc] init];
        c4= [[NSMutableArray alloc] init];
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
                 NSString *correctC4 = [NSString stringWithCString:[[value objectForKey:@"choice4"] cStringUsingEncoding:NSUTF8StringEncoding] encoding:NSUTF8StringEncoding];
                NSString *correctAns = [NSString stringWithCString:[[value objectForKey:@"correct_choice"] cStringUsingEncoding:NSUTF8StringEncoding] encoding:NSUTF8StringEncoding];
                [questions addObject:correctQuestion];
                [c1 addObject:correctC1];
                [c2 addObject:correctC2];
                [c3 addObject:correctC3];
                [c4 addObject:correctC4];
                [correct addObject:correctAns];
                [self reload];
            }
        }
        NSMutableDictionary *binary = [[NSMutableDictionary alloc] init];
        [binary setObject:questions forKey:@"questions"];
        [binary setObject:c1 forKey:@"choice1"];
        [binary setObject:c2 forKey:@"choice2"];
        [binary setObject:c3 forKey:@"choice3"];
        [binary setObject:c4 forKey:@"choice4"];
        [binary setObject:correct forKey:@"correct"];
        [binary setObject:[NSNumber numberWithInt:size] forKey:@"sz"];
        self.currentCard.mosalslatQuestions = [NSKeyedArchiver archivedDataWithRootObject:binary];
        self.currentCard.areMosalslatQuestionsDownloaded = [NSNumber numberWithBool:YES];
        // Save in core data
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
        
        // Stopping activity indicator
        [self.view setUserInteractionEnabled:YES];
        [self.activityIndicator setHidden:YES];
        [self.activityIndicator stopAnimating];
        currentDate = [[NSDate alloc] init];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        // Get from core data
        NSLog(@"Couldn't get Questions");
        [self setDataForQuestions];
        
        // Stopping activity indicator
        [self.view setUserInteractionEnabled:YES];
        [self.activityIndicator setHidden:YES];
        [self.activityIndicator stopAnimating];
        currentDate = [[NSDate alloc] init];
    }];
    [request start];
}

-(void)setDataForQuestions {
    NSData *data = self.currentCard.mosalslatQuestions;
    NSDictionary *dect = (NSDictionary *) [NSKeyedUnarchiver unarchiveObjectWithData:data];
    c1 = [[NSMutableArray alloc] init];
    c2 = [[NSMutableArray alloc] init];
    c3 = [[NSMutableArray alloc] init];
    c4 = [[NSMutableArray alloc] init];
    questions = [[NSMutableArray alloc] init];
    correct = [[NSMutableArray alloc] init];
    
    questions = [dect objectForKey:@"questions"];
    c1 =[dect objectForKey:@"choice1"];
    c2 =[dect objectForKey:@"choice2"];
    c3 =[dect objectForKey:@"choice3"];
    c4 =[dect objectForKey:@"choice4"];
    correct = [dect objectForKey:@"correct"];
    NSLog(@"%@" , correct);
    NSNumber *tmp =[dect objectForKey:@"sz"];
    size =tmp.intValue;
    [self reload];
}

-(void) getImage{
    NSData *imgData = self.currentCard.imageBinary;
    UIImage *thumbNail = [UIImage imageWithData:imgData scale:1.0f];
    [self.mosalsalImage setImage:thumbNail];
}
@end
