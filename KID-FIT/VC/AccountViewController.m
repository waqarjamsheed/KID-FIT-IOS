//
//  AccountViewController.m
//  KidFit
//
//  Created by Muhammad Faraz on 25/11/2015.
//  Copyright © 2015 Mojo Solutions Services (Pvt) Ltd. All rights reserved.
//

#import "AccountViewController.h"

@interface AccountViewController ()

@end

@implementation AccountViewController
@synthesize username,email,accounttype,subscriptionstatus;

- (void)viewDidLoad


{
    [super viewDidLoad];
    
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    
    NSString *currentLevelKey = @"currentlevel";
    
    if ([preferences objectForKey:currentLevelKey] == nil)
    {
        
        
        
    }
    else
    {
        //  Get current level
        NSString *currentLevel = [preferences stringForKey:@"email"];
        //NSString *currentLevel = [preferences stringForKey:@"name"];
        
         email.text = currentLevel;
    }

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning


{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated

{
    
    
    // [[self navigationController] setNavigationBarHidden:YES animated:YES];
    
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    
    
    NSString *nameL = [ preferences
                       stringForKey:@"name"];
    NSString *emailL = [ preferences
                        stringForKey:@"email"]; 
    self.username.text=nameL;
    self.email.text=emailL;
    
    
    
    
    //    NSString * = [ preferences
    //                      stringForKey:@"name"];
    
    [super viewWillAppear:YES];
    
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    
    [super viewWillAppear:YES];
}



@end
