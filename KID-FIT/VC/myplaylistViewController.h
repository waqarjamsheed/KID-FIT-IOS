//
//  myplaylistViewController.h
//  KidFit
//
//  Created by Muhammad Faraz on 24/11/2015.
//  Copyright © 2015 Mojo Solutions Services (Pvt) Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "PCAngularActivityIndicatorView.h"

@interface myplaylistViewController : UIViewController <UISearchBarDelegate, UISearchDisplayDelegate,NSURLConnectionDelegate>

@property (nonatomic,strong) NSArray *JSONARRAY;
@property (nonatomic,strong) NSMutableArray *playlistARRAY;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;


-(void)retrievedata;


@property (strong, nonatomic) IBOutlet UITableView *playlistTableView;

@property(nonatomic,strong) NSString *playlistID;

@property (strong) NSManagedObject *downloads;
@property IBOutlet UISearchBar *SearchBar;
@property (strong,nonatomic) NSMutableArray *filteredArrayList;

@property (nonatomic, strong) PCAngularActivityIndicatorView *activityIndicator;

@end
