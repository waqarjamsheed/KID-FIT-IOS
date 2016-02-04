//
//  ProfileViewController.h
//  KidFit
//
//  Created by Muhammad Faraz on 24/11/2015.
//  Copyright © 2015 Mojo Solutions Services (Pvt) Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileViewController : UIViewController

@property (weak,nonatomic)IBOutlet UILabel *name;
@property (weak,nonatomic)IBOutlet UILabel *email;
@property (weak,nonatomic)IBOutlet UILabel *password;

@property (nonatomic,strong) IBOutlet UILabel *username;
@property (nonatomic,strong) IBOutlet UILabel *accounttype;
@property (nonatomic,strong) IBOutlet UILabel *subscriptionstatus;

@end
