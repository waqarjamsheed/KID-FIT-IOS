//
//  SignupViewController.h
//  KidFit
//
//  Created by Muhammad Faraz on 23/11/2015.
//  Copyright © 2015 Mojo Solutions Services (Pvt) Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignupViewController : UIViewController <UITextFieldDelegate>



    @property (weak, nonatomic) IBOutlet UITextField *name;
    @property (weak, nonatomic) IBOutlet UITextField *email;
    @property (weak, nonatomic)IBOutlet UITextField *password;
    @property (weak, nonatomic) IBOutlet UITextField *phone;
    @property (weak, nonatomic)IBOutlet UITextField *country;
    @property (weak, nonatomic)IBOutlet UITextField *city;
    
    @property (weak, nonatomic) IBOutlet UIScrollView *myscrollView;
   


-(IBAction)signup:(id)sender;


-(BOOL)emailFormat:(NSString *)emailText;




@end
