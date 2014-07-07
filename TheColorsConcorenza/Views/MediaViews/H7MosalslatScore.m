//
//  H7MosalslatScore.m
//  TheColorsConcorenza
//
//  Created by Heba Gamal on 7/2/14.
//  Copyright (c) 2014 Heba Gamal. All rights reserved.
//

#import "H7MosalslatScore.h"
#import <FacebookSDK/FacebookSDK.h>

@interface H7MosalslatScore ()

@end

@implementation H7MosalslatScore

- (void)viewDidLoad
{
    [super viewDidLoad];
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
    
    // Show score for 1.5 secs
    self.scoreLabel.text = [NSString stringWithFormat:@"%d",self.score];
    double delayInSeconds = 1.7;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
    [self.navigationController popToRootViewControllerAnimated:YES];
    });
    
    
    // Do any additional setup after loading the view.
}

//-(void)FB {
//    
////    NSMutableDictionary<FBGraphObject> *action = [FBGraphObject graphObject];
////    action[@"moslsalat_quiz"] = @"http://supersayem.com" ;
////    action[@"og:title"]=@"سوبر صايم - سلي صيامك";
////    action[@"og:image"]= @"https://hitseven.net/SuperSayem/h7-assets/resources/img/categories/sally.png";
////    action[@"og:description"] = @"كل يوم لعبة جديدة تجمع فيها الكلمات وتختبر تركيزك";
////    [FBRequestConnection startForPostWithGraphPath:@"me/hitsevenapp:solve"
////                                       graphObject:action
////                                 completionHandler:^(FBRequestConnection *connection,
////                                                     id result,
////                                                     NSError *error) {
////                                 }];
//    NSMutableDictionary<FBGraphObject> *action = [FBGraphObject graphObject];
//    action[@"og:url"] = @"http://supersayem.com";
//    
//    [FBRequestConnection startForPostWithGraphPath:@"me/hitsevenapp:solve"
//                                       graphObject:action
//                                 completionHandler:^(FBRequestConnection *connection,
//                                                     id result,
//                                                     NSError *error) {
//                                     // handle the result
//                                 }];
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
