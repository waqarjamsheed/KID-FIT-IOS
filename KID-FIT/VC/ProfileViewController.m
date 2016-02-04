//
//  ProfileViewController.m
//  KidFit
//
//  Created by Muhammad Faraz on 24/11/2015.
//  Copyright © 2015 Mojo Solutions Services (Pvt) Ltd. All rights reserved.
//

#import "ProfileViewController.h"

@interface ProfileViewController () <UIPickerViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@end

@implementation ProfileViewController

@synthesize name,email,password,username,accounttype,subscriptionstatus;

- (void)viewDidLoad

{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
   
    

    
    
    
    
    self.name.text=nameL;
    self.email.text=emailL;
   
    
    
    
    //    NSString * = [ preferences
    //                      stringForKey:@"name"];
    
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    
    [super viewWillAppear:YES];
}



    




@end
