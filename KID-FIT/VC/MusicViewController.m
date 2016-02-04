//
//  MusicViewController.m
//  KidFit
//
//  Created by Muhammad Faraz on 24/11/2015.
//  Copyright © 2015 Mojo Solutions Services (Pvt) Ltd. All rights reserved.
//

#import "MusicViewController.h"
#import "SWRevealViewController.h"

@interface MusicViewController()
@end

@implementation MusicViewController
@synthesize sidebarButton;


- (void)viewDidLoad{
    
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

}

- (void)didReceiveMemoryWarning

{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//-(IBAction)myplaylist
//
//{
//UIAlertView *Alert = [[UIAlertView alloc]
//                                    initWithTitle:@"Make Unlimited Custom Mixes" message:@"Create custom mixes at KIDFIT music & workout then access & download free" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:@"subscription"];
//    
//    // Display the Hello World Message
//    [Alert show];
//    
//    
//}


-(void)viewWillAppear:(BOOL)animated

{
    
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    [super viewWillAppear:YES];
}

-(IBAction)myplaylist

{
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Make Unlimited Custom Mixes with a KID-FIT Subscription!" message:@"Create custom mixes at KID-FIT Music & Workouts then access and download here." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Log In",nil];
    
    
    [alert show];
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex == 0){
        [self performSegueWithIdentifier:@"goto_myplay" sender:self];
    }
    if (buttonIndex == 1){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.google.com"]];
        //    NSString *subscription =[[NSString alloc]init];
        NSString *murl = @"https://www.google.com/maps/dir/";
        
        NSURL *url = [NSURL URLWithString:murl];
        
        [[UIApplication sharedApplication] openURL:url];
        
    }
}


@end
