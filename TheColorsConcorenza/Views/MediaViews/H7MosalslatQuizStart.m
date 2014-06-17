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

#import <AFNetworking/AFNetworking.h>

@interface H7MosalslatQuizStart ()

@end

@implementation H7MosalslatQuizStart {
    NSMutableArray *questions;
    NSMutableArray *c1;
    NSMutableArray *c2;
    NSMutableArray *c3;
    NSMutableArray *correct;
    int curQuestion , size;
}

- (void)viewDidLoad
{
    /* Setting background image */
    UIImage *background = [UIImage imageNamed: @"bg_all_4.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage: background];
    [self.view insertSubview: imageView atIndex:0];

    // Set current question index
    curQuestion = 0;
    
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    curQuestion++;
    [self reload];
}

-(void)reload {
    if(curQuestion < size) {
        [self.choices reloadData];
        self.question.text = [questions objectAtIndex:curQuestion];
    }else if (curQuestion == size) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Messege" message:@"Thank you for solving todays Mosalslat Quiz!!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
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
        [self.view setUserInteractionEnabled:YES];
        [self.activityIndicator setHidden:YES];
        [self.activityIndicator stopAnimating];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        // Get from core data
        NSLog(@"Couldn't get Questions");
    }];
    [request start];

}

-(void) getImage{
    NSData *imgData = self.currentCard.imageBinary;
    UIImage *thumbNail = [UIImage imageWithData:imgData scale:1.0f];
    [self.mosalsalImage setImage:thumbNail];
    
}
@end
