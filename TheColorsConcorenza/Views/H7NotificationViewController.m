//
//  H7NotificationViewController.m
//  TheColorsConcorenza
//
//  Created by Heba Gamal on 3/26/14.
//  Copyright (c) 2014 Heba Gamal. All rights reserved.
//

#import "H7NotificationViewController.h"
#import "H7NotificationCell.h"

@interface H7NotificationViewController ()

@end

@implementation H7NotificationViewController {
    NSMutableArray *notifications;
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
    
    notifications = [[NSMutableArray alloc] init];
    
    // Get from core data
    
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/* Table Data source */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if([notifications count])
        return [notifications count];
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    H7NotificationCell *cell = (H7NotificationCell*)[tableView dequeueReusableCellWithIdentifier:@"notificationCell"];
    if(cell == nil) {
        cell = (H7NotificationCell*)[[H7NotificationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"notificationCell"];
    }
    if([notifications count])
        cell.notificationDescription.text =[notifications objectAtIndex:indexPath.row];
    return cell;
}

/*  Table Delegate */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90.0;
}


@end
