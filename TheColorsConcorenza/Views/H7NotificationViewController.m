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

@implementation H7NotificationViewController

- (void)viewDidLoad
{
    /* Setting background image */
    UIImage *background = [UIImage imageNamed: @"bg_all_4.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage: background];
    [self.view insertSubview: imageView atIndex:0];
    
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
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    H7NotificationCell *cell = (H7NotificationCell*)[tableView dequeueReusableCellWithIdentifier:@"notificationCell"];
    if(cell == nil) {
        cell = (H7NotificationCell*)[[H7NotificationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"notificationCell"];
    }
    cell.notificationDescription.text = @"heba w 5ayri w noor a3do 3'ano shwyt a3'any";
    cell.notificationProfilePicture.image = [UIImage imageNamed:@"1467210_748325908515087_1110498616_n.jpg"];
    return cell;
}

/*  Table Delegate */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90.0;
}


@end
