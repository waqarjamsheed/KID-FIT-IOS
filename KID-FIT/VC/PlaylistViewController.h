//
//  PlaylistViewController.h
//  KidFit
//
//  Created by Muhammad Faraz on 24/11/2015.
//  Copyright © 2015 Mojo Solutions Services (Pvt) Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlaylistViewController : UIViewController<UISearchBarDelegate, UISearchDisplayDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

@property (nonatomic,strong) NSArray *JSONARRAY;
@property (nonatomic,strong) NSMutableArray *playlistARRAY;


-(void)retrievedata;


@property (strong, nonatomic) IBOutlet UITableView *playlistTableView;

@property(nonatomic,strong) NSString *catID;

@property IBOutlet UISearchBar *SearchBar;
@property (strong,nonatomic) NSMutableArray *filteredArrayList;



@end
