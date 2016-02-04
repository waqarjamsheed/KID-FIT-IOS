//
//  SignupViewController.m
//  KidFit
//
//  Created by Muhammad Faraz on 23/11/2015.
//  Copyright © 2015 Mojo Solutions Services (Pvt) Ltd. All rights reserved.
//

#import "SignupViewController.h"

@interface SignupViewController ()

@end

@implementation SignupViewController

@synthesize name,email,password,phone,country,city,myscrollView;

- (void)viewDidLoad

{
    [super viewDidLoad];
   
    
    self.name.delegate = self;
    self.password.delegate = self;
    
    [myscrollView setContentSize:CGSizeMake(320, 300)];
    
    //secondView.hidden = YES;
    
    
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    
    
    NSString *savedValue = [ preferences
                            stringForKey:@"name"];
    if(savedValue)
    {
        
        [self performSegueWithIdentifier:@"goto_signin" sender:self];
    }

}

- (void)didReceiveMemoryWarning


{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)signup:(id)sender

{
    NSInteger success = 0;
    
    @try
    
    
    {
        
        
        if ([[self.name text] isEqualToString:@""] || [[self.password text] isEqualToString:@""])
            
        {
            
            [self alertStatus:@"Please enter all required field" :@"Sign in Failed!":0];
            
        }
        
        else
            
        {
            
NSString *post =[[NSString alloc] initWithFormat:@"name=%@&pwd=%@&email=%@&phone=%@&country=%@&city=%@",[self.name text],[self.password text],[self.email text],[self.country text],[self.phone text],[self.city text]];
            
            
            NSLog(@"PostData: %@",post);
            
            NSURL *url=[NSURL URLWithString:@"http://mojosol.com/kidfit/webservice/signup.php"];
            
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
                    [preferences setObject:jsonData[@"username"] forKey:@"name"];
                    [preferences setObject:jsonData[@"email"] forKey:@"email"];
                    [preferences setObject:jsonData[@"phone"] forKey:@"phone"];
                    [preferences setObject:jsonData[@"country"] forKey:@"country"];
                    [preferences setObject:jsonData[@"city"] forKey:@"city"];
                    
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
        [self performSegueWithIdentifier:@"goto_signin" sender:self];
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
        
        //  [self performSegueWithIdentifier:@"login_success" sender:self];
    }
    
    
    
}

//- (BOOL)textFieldShouldReturn:(UITextField *)textField
//{
//    [textField resignFirstResponder];
//
//    return YES;
//}

-(BOOL)textFieldShouldReturn:(UITextField *)textField

{
    if(textField == name)
        
    {
        [password becomeFirstResponder];
        [myscrollView setContentOffset:CGPointMake(0, 120) animated:YES];
    }
    else if(textField == password)
    {
        [password resignFirstResponder];
        [myscrollView setContentOffset:CGPointMake(0, 140) animated:YES];
    }
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(textField == name)
    {
        [myscrollView setContentOffset:CGPointMake(0, 120) animated:YES];
    }
    else if(textField == email)
    {
        [myscrollView setContentOffset:CGPointMake(0, 140) animated:YES];
    }
    else if(textField == password)
    {
        [myscrollView setContentOffset:CGPointMake(0, 140) animated:YES];
    }
    else if(textField == phone)
    {
        [myscrollView setContentOffset:CGPointMake(0, 140) animated:YES];
    }
    else if(textField == country)
    {
        [myscrollView setContentOffset:CGPointMake(0, 140) animated:YES];
    }
    else if(textField == city)
    {
        [myscrollView setContentOffset:CGPointMake(0, 140) animated:YES];
    }
    return YES;
}


@end
