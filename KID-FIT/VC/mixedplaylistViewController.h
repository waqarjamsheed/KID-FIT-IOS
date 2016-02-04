//
//  mixedplaylistViewController.h
//  KidFit
//
//  Created by Muhammad Faraz on 24/11/2015.
//  Copyright © 2015 Mojo Solutions Services (Pvt) Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface mixedplaylistViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate, UISearchDisplayDelegate,NSURLConnectionDelegate>

@property (nonatomic,strong) NSArray *JSONARRAY;
@property (nonatomic,strong) NSMutableArray *playlistARRAY;


-(void)retrievedata;


@property (strong, nonatomic) IBOutlet UITableView *mixplaylistTableView;
@property IBOutlet UISearchBar *SearchBar;
@property (strong,nonatomic) NSMutableArray *filteredArrayList;

@end
