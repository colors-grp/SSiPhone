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
#import "H7ConstantsModel.h"

#import <AFNetworking/AFNetworking.h>
#import <CoreData+MagicalRecord.h>

@interface H7SponsorViewController ()

@end

@implementation H7SponsorViewController {
    NSMutableArray *programs;
    NSMutableArray *coreDataPrograms;
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
    
    // Get Tv guide
    coreDataPrograms = [[SponsorPrograms MR_findAllSortedBy:@"programId" ascending:YES] mutableCopy];
    if([coreDataPrograms count] == 0) {
        [self.view setUserInteractionEnabled:NO];
        [self.activityIndicator setHidden:NO];
        [self.activityIndicator startAnimating];
        
        [self getTvGuide];
    }
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [coreDataPrograms count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    H7SponsorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sponsorCell"];
    if (cell == nil) {
        cell = (H7SponsorTableViewCell*)[[H7SponsorTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"sponsorCell"];
    }
    SponsorPrograms *p =[coreDataPrograms objectAtIndex:indexPath.row];
    cell.titleLabel.text =  p.programName;
    if(p.binaryImage == nil) {
        [self downloadGuideImage:indexPath.row+1 andSponsor:p SetImage:cell.image];
    }else {
        NSData *imgData = p.binaryImage;
        UIImage *thumbNail = [UIImage imageWithData:imgData scale:1.0f];
        cell.image.image = thumbNail;
    }
    return cell;
}

- (void) getTvGuide {
    NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@tv_guide/format/json", PLATFORM_URL]];
    NSLog(@"%@" , url);
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:url];
    AFJSONRequestOperation *request = [AFJSONRequestOperation JSONRequestOperationWithRequest:urlRequest success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSDictionary *d = JSON;
        NSLog(@"%@" , d);
        int sz = [[d objectForKey:@"size"] intValue];
        for (int i=0 ; i < sz; i++) {
            NSDictionary * dict = [d objectForKey:[NSString stringWithFormat:@"%d" , i]];
            SponsorPrograms *newProgram = [SponsorPrograms MR_createEntity];
            newProgram.programId = [dict objectForKey:@"id"];
            newProgram.programName =[NSString stringWithCString:[[dict objectForKey:@"name"]cStringUsingEncoding:NSUTF8StringEncoding] encoding:NSUTF8StringEncoding];
            newProgram.binaryImage = nil;
            [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
            NSLog(@"%@" , newProgram.programName);
        }
        coreDataPrograms = [[SponsorPrograms MR_findAllSortedBy:@"programId" ascending:YES] mutableCopy];
        [self.programsTable reloadData];
        [self.view setUserInteractionEnabled:YES];
        [self.activityIndicator setHidden:YES];
        [self.activityIndicator stopAnimating];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        // Get from core data
        NSLog(@"Failed to get Tv Guide");
    }];
    [request start];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"showProgramInfo"]) {
        H7ProgramViewController *view = [segue destinationViewController];
        NSIndexPath *indexPath = [self.programsTable indexPathForSelectedRow];
        view.currentProgram = [coreDataPrograms objectAtIndex:indexPath.row];
    }
}


- (void)downloadGuideImage:(int)programId andSponsor:(SponsorPrograms*)program SetImage:(UIImageView*)image {
    // Set URL for image
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat: @"%@guide/%d.png" ,ASSETS_URL,programId]];
    
    // Set the request
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    // Get directory to save & retrieve image
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"guide"]];
    
    // Create directory
    NSFileManager *filemgr;
    filemgr =[NSFileManager defaultManager];
    if ([filemgr createDirectoryAtPath:documentsDirectory withIntermediateDirectories:YES
                            attributes:nil error: NULL] == NO){
        NSLog(@"Failed to create local directory");
    }
    
    // Save file
    NSString *fullPath = [NSString stringWithFormat:@"%@/%d.png", documentsDirectory , programId];
    [operation setOutputStream:[NSOutputStream outputStreamToFileAtPath:fullPath append:NO]];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *imgData = [[NSData alloc] initWithContentsOfURL:[NSURL fileURLWithPath:fullPath]];
        [imgData writeToFile:fullPath atomically:YES];
        UIImage *thumbNail = [[UIImage alloc] initWithData:imgData];
        //Set image with thumbnail here
        image.image = thumbNail;
        //Set card.isAvailble to be true & save to coredata & binary image
        program.binaryImage = imgData;
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"ERR: %@", [error description]);
    }];
    [operation start];
}


@end
