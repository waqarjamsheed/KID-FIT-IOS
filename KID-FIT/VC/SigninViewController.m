//
//  ViewController.m
//  KidFit
//
//  Created by Muhammad Faraz on 23/11/2015.
//  Copyright © 2015 Mojo Solutions Services (Pvt) Ltd. All rights reserved.
//

#import "SigninViewController.h"

@interface SigninViewController ()

@end

@implementation SigninViewController

@synthesize signin;
@synthesize email;
@synthesize txtPassword;

- (void)viewDidLoad


{
    [super viewDidLoad];
   
    self.email.delegate = self;
    self.txtPassword.delegate = self;
    
    
    
//    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
//    
//    
//    NSString *savedValue = [ preferences
//                            stringForKey:@"email"];
//   
//    
//
//    if(savedValue)
//    {
//        
//        [self performSegueWithIdentifier:@"login_success" sender:self];
//    }
}

- (void)didReceiveMemoryWarning


{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)signin:(id)sender

{
    NSInteger success = 0;
    
    @try
    
    
    {
        
        
        if ([[self.email text] isEqualToString:@""] || [[self.txtPassword text] isEqualToString:@""])
            
        {
            
            [self alertStatus:@"Please enter Email and Password" :@"Sign in Failed!":0];
            
        }
        
        else
            
        {
            
            NSString *post =[[NSString alloc] initWithFormat:@"email=%@&pwd=%@",[self.email text],[self.txtPassword text]];
            
            
            NSLog(@"PostData: %@",post);
            
            NSURL *url=[NSURL URLWithString:@"http://mojosol.com/kidfit/webservice/login.php"];
            
            NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
            
            NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
            
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setURL:url];
            
            [request setHTTPMethod:@"POST"];
            [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            [request setHTTPBody:postData];
            
            //[NSURLRequest setAllowsAnyHTTPSCertificate:YES forHost:[url host]];
            
            NSError *error = [[NSError alloc] init];
            NSHTTPURLResponse *response = nil;
            
            NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
            
            NSLog(@"Response code: %ld", (long)[response statusCode]);
            
            if ([response statusCode] >= 200 && [response statusCode] < 300)
                
            {
                
        NSString *responseData = [[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
                
                
                NSLog(@"Response ==> %@", responseData);
                
                NSError *error = nil;
                NSDictionary *jsonData = [NSJSONSerialization
                                          JSONObjectWithData:urlData
                                          options:NSJSONReadingMutableContainers
                                          error:&error];
                
                success = [jsonData[@"status"] integerValue];
                NSLog(@"Success: %ld",(long)success);
                
                if(success == 1)
                {
                    NSLog(@"Login SUCCESS");
                    //[self.INDICATOR startAnimating];
                    
                    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
                    // NSString *str =jsonData[@"username"];
                    [preferences setObject:jsonData[@"name"] forKey:@"name"];
                    [preferences setObject:jsonData[@"email"] forKey:@"email"];
                    [preferences setObject:jsonData[@"phone"] forKey:@"phone"];
                    [preferences setObject:jsonData[@"country"] forKey:@"country"];
                    [preferences setObject:jsonData[@"id"] forKey:@"user_id"];
                    
                    
                }
                else
                    
                {
                    
                    NSString *error_msg = (NSString *) jsonData[@"error_message"];
                    [self alertStatus:error_msg :@"Sign in Failed!" :0];
                }
                
            }
            else
            {
                //if (error) NSLog(@"Error: %@", error);
                [self alertStatus:@"Connection Failed" :@"Sign in Failed!" :0];
            }
        }
    }
    
    @catch (NSException * e)
    
    {
        NSLog(@"Exception: %@", e);
        [self alertStatus:@"Sign in Failed." :@"Error!" :0];
    }
    
    
    if (success)
        
    {
        [self performSegueWithIdentifier:@"login_success" sender:self];
    }
}

- (void) alertStatus:(NSString *)msg :(NSString *)title :(int) tag
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:msg
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil, nil];
    alertView.tag = tag;
    [alertView show];
}

- (IBAction)backgroundTap:(id)sender

{
    [self.view endEditing:YES];
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    
    
    NSString *savedValue = [ preferences
                            stringForKey:@"name"];
    if(savedValue)
    {
        
        [self performSegueWithIdentifier:@"login_success" sender:self];
    }
    
    
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}




@end
