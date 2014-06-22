//
//  H7ProgramViewController.m
//  TheColorsConcorenza
//
//  Created by Heba Gamal on 5/19/14.
//  Copyright (c) 2014 Heba Gamal. All rights reserved.
//

#import "H7ProgramViewController.h"
#import "H7ConstantsModel.h"
#import "Channels.h"
#import "H7channelCell.h"

#import <CoreData+MagicalRecord.h>
#import <AFNetworking/AFNetworking.h>
@interface H7ProgramViewController ()

@end

@implementation H7ProgramViewController {
    NSMutableArray *channels;
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
    
    // Set program image
    NSData *imgData = self.currentProgram.binaryImage;
    UIImage *thumbNail = [UIImage imageWithData:imgData scale:1.0f];
    self.programImage.image = thumbNail;

    channels = [[Channels MR_findAll] mutableCopy];
    NSMutableArray *tmp = [[NSMutableArray alloc] init];
    for (int i=0 ; i<[channels count]; i++) {
        Channels *ch = [channels objectAtIndex:i];
        if([ch.programId isEqualToString:self.currentProgram.programId]) {
            [tmp addObject:ch];
        }
    }
    channels = tmp;
    if(![channels count]) {
        // Get channels
        [self getChannels];
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
    return [channels count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    H7channelCell *cell= (H7channelCell*)[tableView dequeueReusableCellWithIdentifier:@"channelCell"];
    if(cell == nil) {
        cell = (H7channelCell*)[[H7channelCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"channelCell"];
    }
    Channels *ch = [channels objectAtIndex:indexPath.row];
    cell.channelName.text = ch.channelName;
    cell.time.text = ch.time;
    return cell;
}

- (void) getChannels {
    NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@tv_channels/format/json/programId/%@", PLATFORM_URL , self.currentProgram.programId]];
    NSLog(@"%@" , url);
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:url];
    AFJSONRequestOperation *request = [AFJSONRequestOperation JSONRequestOperationWithRequest:urlRequest success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSDictionary *d = JSON;
        NSLog(@"%@" , d);
        int sz = [[d objectForKey:@"size"] intValue];
        for (int i=0 ; i < sz; i++) {
            NSDictionary * dict = [d objectForKey:[NSString stringWithFormat:@"%d" , i]];
            Channels *ch = [Channels MR_createEntity];
            ch.programId = self.currentProgram.programId;
            ch.channelName =[NSString stringWithCString:[[dict objectForKey:@"channel"]cStringUsingEncoding:NSUTF8StringEncoding] encoding:NSUTF8StringEncoding];
            ch.time = [NSString stringWithFormat:@"%@" , [dict objectForKey:@"time"]];
            [channels addObject:ch];
            [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
        }
        [self.channelsTable reloadData];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        // Get from core data
        NSLog(@"Failed to get Tv Guide");
    }];
    [request start];
}

@end
