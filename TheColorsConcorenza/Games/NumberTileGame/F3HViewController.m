//
//  F3HViewController.m
//  NumberTileGame
//
//  Created by Austin Zheng on 3/22/14.
//
//

#import "F3HViewController.h"

#import "F3HNumberTileGameViewController.h"

@interface F3HViewController ()
@end

@implementation F3HViewController

- (IBAction)playGameButtonTapped:(id)sender {
    F3HNumberTileGameViewController *c = [F3HNumberTileGameViewController numberTileGameWithDimension:4
                                                                                         winThreshold:2048
                                                                                      backgroundColor:
                                          [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_all_4.png"]]
                                                                                          scoreModule:YES
                                                                                       buttonControls:NO
                                                                                        swipeControls:YES];
    [self.navigationController pushViewController:c animated:YES];
}

@end
