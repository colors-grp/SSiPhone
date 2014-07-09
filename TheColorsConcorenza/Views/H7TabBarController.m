//
//  H7TabBarController.m
//  TheColorsConcorenza
//
//  Created by Heba Gamal on 4/14/14.
//  Copyright (c) 2014 Heba Gamal. All rights reserved.
//

#import "H7TabBarController.h"

@interface H7TabBarController ()

@end

@implementation H7TabBarController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    // Customizing the tabbar
    UITabBar *tabBar = self.tabBar;
    
    // Setting tabbar background color
    tabBar.barTintColor =[UIColor colorWithRed:(253/255.0) green:(223/255.0) blue:(50/255.0) alpha:1];
    
    // Get tabBar items
    UITabBarItem *item1 = [tabBar.items objectAtIndex:0];
    UITabBarItem *item2 = [tabBar.items objectAtIndex:1];
    UITabBarItem *item3 = [tabBar.items objectAtIndex:2];
    UITabBarItem *item4 = [tabBar.items objectAtIndex:3];
    UITabBarItem *item5 = [tabBar.items objectAtIndex:4];
    
    item1.image = [[UIImage imageNamed:@"TabIcons30/me.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    item1.selectedImage = [[UIImage imageNamed:@"TabIcons30/me_selected.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    item2.image = [[UIImage imageNamed:@"TabIcons30/collections.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    item2.selectedImage = [[UIImage imageNamed:@"TabIcons30/collections_selected.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    item3.image = [[UIImage imageNamed:@"TabIcons30/scoreboard.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    item3.selectedImage = [[UIImage imageNamed:@"TabIcons30/scoreboard_selected.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    item4.image = [[UIImage imageNamed:@"TabIcons30/guide.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    item4.selectedImage = [[UIImage imageNamed:@"TabIcons30/guide_selected.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    item5.image = [[UIImage imageNamed:@"TabIcons30/notifications.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    item5.selectedImage = [[UIImage imageNamed:@"TabIcons30/notifications_selected.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    
    //Change Navigation bar title color to red
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:(212/255.0) green:(39/255.0) blue:(51/255.0) alpha:1]}];
    
    // Change Navigation Bar background image
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"nav_bg.png"] forBarMetrics:UIBarMetricsDefault];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
