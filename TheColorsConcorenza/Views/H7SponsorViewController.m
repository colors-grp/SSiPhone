//
//  H7SponsorViewController.m
//  TheColorsConcorenza
//
//  Created by Heba Gamal on 5/19/14.
//  Copyright (c) 2014 Heba Gamal. All rights reserved.
//

#import "H7SponsorViewController.h"
#import "H7SponsorTableViewCell.h"
#import "SponsorPrograms.h"
#import "H7ProgramViewController.h"

#import <CoreData+MagicalRecord.h>

@interface H7SponsorViewController ()

@end

@implementation H7SponsorViewController {
    NSArray *programs;
}

- (void)viewDidLoad
{
    /* Setting background image */
    UIImage *background = [UIImage imageNamed: @"bg_all_4.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage: background];
    [self.view insertSubview: imageView atIndex:0];
    
    programs = [SponsorPrograms MR_findAll];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [programs count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    H7SponsorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sponsorCell"];
    if (cell == nil) {
        cell = (H7SponsorTableViewCell*)[[H7SponsorTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"sponsorCell"];
    }
    SponsorPrograms * sponsorProgram = [programs objectAtIndex:indexPath.row];
    cell.titleLabel.text = sponsorProgram.title;
    cell.image.image = [UIImage imageNamed:sponsorProgram.imageName];
    return cell;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"showProgramInfo"]) {
        H7ProgramViewController *view = [segue destinationViewController];
        NSIndexPath *indexPath = [self.programsTable indexPathForSelectedRow];
        NSLog(@"%d" , indexPath.row);
        view.currentProgram = [programs objectAtIndex:indexPath.row];
    }
}





@end
