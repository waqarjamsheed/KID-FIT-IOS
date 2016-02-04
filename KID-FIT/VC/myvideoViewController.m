//
//  myvideoViewController.m
//  KidFit
//
//  Created by Muhammad Faraz on 24/11/2015.
//  Copyright © 2015 Mojo Solutions Services (Pvt) Ltd. All rights reserved.
//

#import "myvideoViewController.h"

@interface myvideoViewController ()

@end

@implementation myvideoViewController

@synthesize myvideoTableView;

- (void)viewDidLoad

{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg.jpg"]];
[tempImageView setFrame:self.myvideoTableView.frame];

self.myvideoTableView.backgroundView = tempImageView;



}

- (void)didReceiveMemoryWarning

{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




-(void)viewWillAppear:(BOOL)animated

{
    
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    [super viewWillAppear:YES];
}

@end
