//
//  HomeViewController.m
//  KidFit
//
//  Created by Muhammad Faraz on 23/11/2015.
//  Copyright © 2015 Mojo Solutions Services (Pvt) Ltd. All rights reserved.
//

#import "HomeViewController.h"
#import "SWRevealViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad


{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
        
    {
        
        [self.sidebarButton addTarget: self.revealViewController
                               action: @selector(revealToggle:)
                     forControlEvents:UIControlEventTouchUpInside];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        
        
    }

    UITabBarController *tabBarController = (UITabBarController *)self.tabBarController;
    [tabBarController.tabBar setTintColor:[UIColor whiteColor]];
}

- (void)didReceiveMemoryWarning


{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated

{
    
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    [super viewWillAppear:YES];
}

@end
