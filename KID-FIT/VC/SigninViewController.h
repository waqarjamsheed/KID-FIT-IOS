//
//  ViewController.h
//  KidFit
//
//  Created by Muhammad Faraz on 23/11/2015.
//  Copyright © 2015 Mojo Solutions Services (Pvt) Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SigninViewController : UIViewController  <UITextFieldDelegate>

@property (strong, nonatomic)IBOutlet UIButton *signin;

@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;

- (IBAction)signin:(id)sender;




@end

